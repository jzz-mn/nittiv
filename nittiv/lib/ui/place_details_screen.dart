import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'saved_places_manager.dart';

class PlaceDetailsScreen extends StatefulWidget {
  final String placeName;
  final String imagePath;

  PlaceDetailsScreen({required this.placeName, required this.imagePath});

  @override
  _PlaceDetailsScreenState createState() => _PlaceDetailsScreenState();
}

class _PlaceDetailsScreenState extends State<PlaceDetailsScreen> {
  bool isSaved = false;
  Map<String, dynamic>? placeInfo;

  @override
  void initState() {
    super.initState();
    loadPlaceInfo();
    checkIfSaved();
  }

  Future<void> loadPlaceInfo() async {
    try {
      final String response =
          await rootBundle.loadString('assets/place_info.json');
      final data = json.decode(response) as List;
      setState(() {
        placeInfo = data.expand((region) => region['places']).firstWhere(
            (place) => place['name'] == widget.placeName,
            orElse: () => null);
      });
      print('Place info loaded: $placeInfo');
    } catch (e) {
      print('Error loading place info: $e');
    }
  }

  Future<void> checkIfSaved() async {
    final savedPlaces = await SavedPlacesManager.getSavedPlaces();
    setState(() {
      isSaved = savedPlaces.contains(widget.placeName);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: placeInfo == null
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Loading place information...'),
                ],
              ),
            )
          : CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: Container(
                    height: 300,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(widget.imagePath),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.placeName,
                          style: TextStyle(
                              fontSize: 28, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Row(
                                children: [
                                  Icon(Icons.location_on,
                                      color: Color(0xFF008575)),
                                  SizedBox(width: 4),
                                  Flexible(
                                    child: Text(
                                      placeInfo!['location'],
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            _buildSaveButton(),
                          ],
                        ),
                        SizedBox(height: 16),
                        _buildInfoSection(
                          icon: Icons.info,
                          title: 'About',
                          content: placeInfo!['description'],
                        ),
                        SizedBox(height: 16),
                        _buildInfoSection(
                          icon: Icons.star,
                          title: 'Highlight',
                          content: placeInfo!['highlight'],
                        ),
                        SizedBox(height: 16),
                        _buildInfoCard(
                          icon: Icons.calendar_today,
                          title: 'Best Time to Visit',
                          content: placeInfo!['recommendedVisitTime'],
                        ),
                        SizedBox(height: 8),
                        _buildInfoCard(
                          icon: Icons.tips_and_updates,
                          title: 'Traveler Tips',
                          content: placeInfo!['travelerTips'],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildSaveButton() {
    return ElevatedButton.icon(
      onPressed: () async {
        setState(() {
          isSaved = !isSaved;
        });
        if (isSaved) {
          await SavedPlacesManager.savePlace(widget.placeName);
        } else {
          await SavedPlacesManager.removePlace(widget.placeName);
        }
      },
      icon: Icon(isSaved ? Icons.favorite : Icons.favorite_border,
          color: Colors.white),
      label: Text(isSaved ? 'SAVED' : 'SAVE',
          style: TextStyle(color: Colors.white)),
      style: ElevatedButton.styleFrom(
        backgroundColor: Color(0xFF008575),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
    );
  }

  Widget _buildInfoSection(
      {required IconData icon,
      required String title,
      required String content}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: Color(0xFF008575)),
            SizedBox(width: 8),
            Text(
              title,
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        SizedBox(height: 8),
        Text(
          content,
          style: TextStyle(fontSize: 16),
        ),
      ],
    );
  }

  Widget _buildInfoCard(
      {required IconData icon,
      required String title,
      required String content}) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: Color(0xFF008575)),
                SizedBox(width: 8),
                Text(
                  title,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            SizedBox(height: 8),
            Text(content, style: TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'place_details_screen.dart';
import 'settings_screen.dart';
import 'loading_screen.dart';
// Make sure to import your LoadingScreen

class ExploreScreen extends StatefulWidget {
  @override
  _ExploreScreenState createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  List<dynamic> _places = [];
  List<String> _regions = [];
  String? _selectedRegion;

  @override
  void initState() {
    super.initState();
    _loadPlaces();
  }

  Future<void> _loadPlaces() async {
    String jsonString = await rootBundle.loadString('assets/place_info.json');
    List<dynamic> jsonData = json.decode(jsonString);
    setState(() {
      _regions =
          jsonData.map<String>((region) => region['region'] as String).toList();
      _places = jsonData
          .expand((region) => region['places'] as List<dynamic>)
          .toList();
    });
  }

  void _showRegionFilter(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return Container(
          height: 300,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Select Region',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: _regions.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(_regions[index]),
                      onTap: () {
                        setState(() {
                          _selectedRegion = _regions[index];
                        });
                        Navigator.pop(context);
                        _filterPlaces();
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _filterPlaces() {
    if (_selectedRegion != null) {
      setState(() {
        _places = _places
            .where((place) => place['region'] == _selectedRegion)
            .toList();
      });
    } else {
      _loadPlaces(); // Reset to all places if no region is selected
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Explore',
          style: TextStyle(
            color: Color(0xFF008575),
            fontWeight: FontWeight.w200,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  'Hello,',
                  style: TextStyle(
                    fontSize: 12,
                    color: Color(0xFF008575),
                    fontWeight: FontWeight.normal,
                  ),
                ),
                Text(
                  'Alexandra',
                  style: TextStyle(
                    fontSize: 20,
                    color: Color(0xFF008575),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 10),
          CircleAvatar(
            backgroundImage: AssetImage('assets/profile_image.jpg'),
          ),
          SizedBox(width: 10),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Color(0xFF008575),
              ),
              child: Text(
                'Settings',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text('Settings'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SettingsScreen()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text('Sign Out'),
              onTap: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => LoadingScreen()),
                  (Route<dynamic> route) => false,
                );
              },
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Row(
              children: [
                _buildFilterChip(context, 'Region'),
                SizedBox(width: 10),
                _buildFilterChip(context, 'Accessibility'),
                SizedBox(width: 10),
                _buildFilterChip(context, 'Landscape'),
              ],
            ),
          ),
          Expanded(
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.75,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              padding: EdgeInsets.all(16),
              itemCount: _places.length,
              itemBuilder: (context, index) {
                final place = _places[index];
                return _buildPlaceCard(
                  context,
                  place['name'],
                  place['location'],
                  place['imagePath'],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(BuildContext context, String label) {
    return FilterChip(
      label: Text(label),
      onSelected: (bool selected) {
        if (label == 'Region') {
          _showRegionFilter(context);
        }
        // Implement other filters similarly
      },
      selected: label == 'Region' && _selectedRegion != null,
      selectedColor: Colors.teal[100],
    );
  }

  Widget _buildPlaceCard(
      BuildContext context, String name, String location, String imagePath) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PlaceDetailsScreen(
              placeName: name,
              imagePath: imagePath,
            ),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              spreadRadius: 2,
              blurRadius: 5,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
              child: Image.asset(
                imagePath,
                height: 120,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 4),
                  Text(
                    location,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

class PlaceDetailsScreen extends StatefulWidget {
  final String placeName;
  final String imagePath;

  PlaceDetailsScreen({required this.placeName, required this.imagePath});

  @override
  _PlaceDetailsScreenState createState() => _PlaceDetailsScreenState();
}

class _PlaceDetailsScreenState extends State<PlaceDetailsScreen> {
  bool isSaved = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 200.0,
            floating: false,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(widget.placeName),
              background: Image.network(
                widget.imagePath,
                fit: BoxFit.cover,
              ),
            ),
            backgroundColor: Color(0xFF008575),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.location_on, color: Color(0xFF008575)),
                          SizedBox(width: 4),
                          Text('Location, Country'),
                        ],
                      ),
                      _buildSaveButton(),
                    ],
                  ),
                  SizedBox(height: 16),
                  Text(
                    'About',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Discover the beauty of ${widget.placeName}! This eco-friendly destination offers a perfect blend of natural wonders and sustainable practices.',
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Eco-friendly Features',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  _buildFeature('100% Renewable Energy', Icons.eco),
                  _buildFeature('Zero-Waste Policy', Icons.delete_outline),
                  _buildFeature('Local Community Projects', Icons.people),
                  SizedBox(height: 16),
                  _buildInfoCard('Best Time to Visit', 'April to October'),
                  _buildInfoCard('Eco-Rating', '9.5/10'),
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
      onPressed: () {
        setState(() {
          isSaved = !isSaved;
        });
        // TODO: Implement save functionality
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

  Widget _buildFeature(String feature, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, color: Color(0xFF008575)),
          SizedBox(width: 12),
          Text(feature, style: TextStyle(fontSize: 16)),
        ],
      ),
    );
  }

  Widget _buildInfoCard(String title, String info) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Text(info, style: TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}

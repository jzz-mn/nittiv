import 'package:flutter/material.dart';
import 'explore_screen.dart';
import 'place_details_screen.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.menu),
          onPressed: () {
            Scaffold.of(context).openDrawer();
          },
        ),
        title: Text(
          'Home',
          style: TextStyle(
            color: Color(0xFF008575),
            fontWeight: FontWeight.w200,
          ),
        ),
        actions: [
          CircleAvatar(
            backgroundImage: AssetImage('assets/profile_image.jpg'),
          ),
          SizedBox(width: 10),
          Center(child: Text('Hello,\nAlexandra', textAlign: TextAlign.right)),
          SizedBox(width: 10),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                decoration: InputDecoration(
                  hintText: 'Search',
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.teal[100],
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Your Dream Trip Awaits',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    Text(
                        'Find Your Perfect Destination Based on Your Preferences!'),
                    ElevatedButton(
                      onPressed: () {
                        // Implement find functionality
                      },
                      child: Text('Find Now'),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              Text('Trending Spots',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                      child: _buildPlaceCard(
                          context, 'Wind Farm', 'assets/wind_farm.jpg')),
                  SizedBox(width: 10),
                  Expanded(
                      child: _buildPlaceCard(context, 'Sugbao Lagoon',
                          'assets/sugbao_lagoon.jpg')),
                ],
              ),
              SizedBox(height: 20),
              Text('Top Eco-Destinations',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                      child: _buildPlaceCard(context, 'Rice Terraces',
                          'assets/rice_terraces.jpg')),
                  SizedBox(width: 10),
                  Expanded(
                      child: _buildPlaceCard(
                          context, 'El Nido', 'assets/el_nido.jpg')),
                ],
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Color(0xFF008575),
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white.withOpacity(0.6),
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.explore), label: 'Explore'),
          BottomNavigationBarItem(icon: Icon(Icons.bookmark), label: 'Saved'),
          BottomNavigationBarItem(icon: Icon(Icons.book), label: 'Journal'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
        onTap: (index) {
          if (index == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ExploreScreen()),
            );
          }
        },
      ),
    );
  }

  Widget _buildPlaceCard(BuildContext context, String name, String imagePath) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                PlaceDetailsScreen(placeName: name, imagePath: imagePath),
          ),
        );
      },
      child: Card(
        child: Column(
          children: [
            Image.asset(imagePath, fit: BoxFit.cover),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(name, style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'place_details_screen.dart';
import 'settings_screen.dart';

class SavedScreen extends StatefulWidget {
  @override
  _SavedScreenState createState() => _SavedScreenState();
}

class _SavedScreenState extends State<SavedScreen> {
  final List<Map<String, String>> _savedPlaces = [];

  void _addSavedPlace(String name, String imagePath) {
    setState(() {
      _savedPlaces.add({'name': name, 'imagePath': imagePath});
    });
  }

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
          'Saved',
          style: TextStyle(
            color: Color(0xFF008575),
            fontWeight: FontWeight.w200,
          ),
        ),
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
                // Implement sign-out functionality
              },
            ),
          ],
        ),
      ),
      body: _savedPlaces.isEmpty
          ? Center(child: Text('No saved places yet.'))
          : ListView.builder(
              itemCount: _savedPlaces.length,
              itemBuilder: (context, index) {
                final place = _savedPlaces[index];
                return ListTile(
                  leading: Image.asset(
                    place['imagePath']!,
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                  ),
                  title: Text(place['name']!),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PlaceDetailsScreen(
                          placeName: place['name']!,
                          imagePath: place['imagePath']!,
                        ),
                      ),
                    );
                  },
                );
              },
            ),
    );
  }
}

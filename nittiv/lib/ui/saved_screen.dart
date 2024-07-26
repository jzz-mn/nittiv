import 'package:flutter/material.dart';
import 'place_details_screen.dart';
import 'settings_screen.dart';
import 'saved_places_manager.dart';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

class SavedScreen extends StatefulWidget {
  @override
  _SavedScreenState createState() => _SavedScreenState();
}

class _SavedScreenState extends State<SavedScreen> {
  List<Map<String, dynamic>> _savedPlaces = [];

  @override
  void initState() {
    super.initState();
    loadSavedPlaces();
  }

  Future<void> loadSavedPlaces() async {
    final savedPlaceNames = await SavedPlacesManager.getSavedPlaces();
    final String response =
        await rootBundle.loadString('assets/place_info.json');
    final data = await json.decode(response);

    List<Map<String, dynamic>> loadedPlaces = [];
    for (var region in data) {
      for (var place in region['places']) {
        if (savedPlaceNames.contains(place['name'])) {
          loadedPlaces.add(place);
        }
      }
    }

    setState(() {
      _savedPlaces = loadedPlaces;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
                    place['imagePath'],
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                  ),
                  title: Text(place['name']),
                  subtitle: Text(place['location']),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PlaceDetailsScreen(
                          placeName: place['name'],
                          imagePath: place['imagePath'],
                        ),
                      ),
                    ).then((_) =>
                        loadSavedPlaces()); // Reload saved places when returning from details screen
                  },
                );
              },
            ),
    );
  }
}

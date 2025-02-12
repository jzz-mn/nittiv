import 'package:flutter/material.dart';
import 'loading_screen.dart';
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
              leading: Icon(Icons.settings, color: Color(0xFF008575)),
              title:
                  Text('Settings', style: TextStyle(color: Color(0xFF008575))),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SettingsScreen()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.logout, color: Color(0xFF008575)),
              title:
                  Text('Sign Out', style: TextStyle(color: Color(0xFF008575))),
              onTap: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => LoadingScreen()),
                  (Route<dynamic> route) => false,
                );
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
                return Card(
                  margin: EdgeInsets.all(8.0),
                  elevation: 4,
                  child: ListTile(
                    contentPadding: EdgeInsets.all(8.0),
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
                  ),
                );
              },
            ),
    );
  }
}

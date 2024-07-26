import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Dummy data for profile details
    final String profilePicture = 'assets/profile_image.jpg';
    final String name = 'Alexandra';
    final String lastName = 'Saint Mleux';
    final String birthdate = 'January 1, 2000';
    final String location = 'Manila, Philippines';
    final List<String> interests = ['Hiking', 'Swimming'];
    final List<String> badges = ['Traveler', 'Volunteer'];

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Profile',
          style: TextStyle(
            color: Color(0xFF008575),
            fontWeight: FontWeight.w200,
          ),
        ),
        actions: [
          CircleAvatar(
            backgroundImage: AssetImage(profilePicture),
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
              leading: Icon(Icons.settings, color: Color(0xFF008575)),
              title:
                  Text('Settings', style: TextStyle(color: Color(0xFF008575))),
              onTap: () {
                // Navigate to settings screen
              },
            ),
            ListTile(
              leading: Icon(Icons.logout, color: Color(0xFF008575)),
              title:
                  Text('Sign Out', style: TextStyle(color: Color(0xFF008575))),
              onTap: () {
                // Implement sign-out functionality
              },
            ),
          ],
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 182,
                    height: 182,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Color(0xFF008575),
                        width: 5.35,
                      ),
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        image: AssetImage(profilePicture),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 16),
                Center(
                  child: Text(
                    '$name $lastName',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF008575),
                    ),
                  ),
                ),
                SizedBox(height: 16),
                ProfileBox(label: 'Birthdate:', value: birthdate),
                ProfileBox(label: 'Location:', value: location),
                ProfileBox(
                  label: 'Interests:',
                  value: '· ${interests[0]}\n· ${interests[1]}',
                ),
                ProfileBox(
                  label: 'Badges:',
                  value: '· ${badges[0]}\n· ${badges[1]}',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ProfileBox extends StatelessWidget {
  final String label;
  final String value;

  ProfileBox({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 102,
            child: Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Color(0xFF008575),
                fontSize: 18,
              ),
            ),
          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(
                  color: Color(0xFF008575),
                  width: 2.0,
                ),
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Text(
                value,
                style: TextStyle(
                  fontSize: 16,
                  color: Color(0xFF008575),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
        backgroundColor: Color(0xFF008575),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              title: Text('Account'),
              onTap: () {
                // Implement account settings
              },
            ),
            ListTile(
              title: Text('Notifications'),
              onTap: () {
                // Implement notifications settings
              },
            ),
            ListTile(
              title: Text('Privacy'),
              onTap: () {
                // Implement privacy settings
              },
            ),
            ListTile(
              title: Text('Help & Support'),
              onTap: () {
                // Implement help and support
              },
            ),
          ],
        ),
      ),
    );
  }
}

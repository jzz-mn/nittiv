import 'package:flutter/material.dart';
import 'profile_screen.dart';
import 'loading_screen.dart';

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
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ProfileScreen()),
                );
              },
            ),
            ListTile(
              title: Text('Privacy'),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('Privacy Policy'),
                      content: Text(
                          'Your privacy is important to us. We are committed to protecting your personal information and ensuring its confidentiality. Please review our Privacy Policy to understand how we collect, use, and safeguard your data.'),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text('Done'),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
            ListTile(
              title: Text('Help & Support'),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('Help & Support'),
                      content: Text(
                          'If you need assistance or have any questions, please contact our support team at support-ph@nittiv.com. We are here to help you with any issues you may encounter.'),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text('Done'),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
            ListTile(
              title: Text('Sign Out'),
              onTap: () {
                // Implement sign-out functionality
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
    );
  }
}

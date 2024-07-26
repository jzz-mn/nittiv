import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'settings_screen.dart'; // Assuming you've created a new file for SettingsScreen

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  User? user;
  String profilePictureUrl = '';
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    user = _auth.currentUser;
    if (user != null) {
      emailController.text = user!.email ?? '';
      try {
        profilePictureUrl = await _storage
            .ref('profile_pictures/${user!.uid}.jpg')
            .getDownloadURL();
      } catch (e) {
        print("No profile picture found: $e");
        profilePictureUrl = '';
      }
      setState(() {});
    }
  }

  Future<void> _updatePassword() async {
    if (user != null && passwordController.text.isNotEmpty) {
      try {
        await user!.updatePassword(passwordController.text);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Password updated successfully"),
        ));
        passwordController.clear();
      } catch (e) {
        print("Error updating password: $e");
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Error updating password: ${e.toString()}"),
        ));
      }
    }
  }

  Future<void> _confirmAndUpdate() async {
    bool? confirm = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Confirm Update"),
          content: Text(
              "Only password can be updated. To update your email, please contact support-ph@nittiv.com.\n\nDo you want to update your password?"),
          actions: <Widget>[
            TextButton(
              child: Text("Cancel"),
              onPressed: () => Navigator.of(context).pop(false),
            ),
            TextButton(
              child: Text("Update Password"),
              onPressed: () => Navigator.of(context).pop(true),
            ),
          ],
        );
      },
    );

    if (confirm == true) {
      await _updatePassword();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Profile',
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
                Navigator.pop(context); // Close the drawer
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
                _auth.signOut();
                Navigator.of(context).pushReplacementNamed('/login');
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
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: 182,
                  height: 182,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Color(0xFF008575),
                      width: 5.35,
                    ),
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      image: AssetImage('assets/images/profile_image.jpg'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                SizedBox(height: 24),
                ProfileBox(
                  label: 'Email:',
                  value: emailController.text,
                  isEditable: false,
                ),
                SizedBox(height: 16),
                ProfileBox(
                  label: 'Password:',
                  value: '********',
                  isEditable: true,
                  controller: passwordController,
                  obscureText: _obscurePassword,
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword
                          ? Icons.visibility
                          : Icons.visibility_off,
                      color: Color(0xFF008575),
                    ),
                    onPressed: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    },
                  ),
                ),
                SizedBox(height: 24),
                ElevatedButton(
                  onPressed: _confirmAndUpdate,
                  child: Text('UPDATE', style: TextStyle(color: Colors.white)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF008575),
                    padding: EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                  ),
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
  final bool isEditable;
  final TextEditingController? controller;
  final bool obscureText;
  final Widget? suffixIcon;

  ProfileBox({
    required this.label,
    required this.value,
    this.isEditable = false,
    this.controller,
    this.obscureText = false,
    this.suffixIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Color(0xFF008575),
            fontSize: 18,
          ),
        ),
        SizedBox(height: 8),
        isEditable
            ? TextField(
                controller: controller,
                obscureText: obscureText,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  suffixIcon: suffixIcon,
                ),
              )
            : Container(
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
      ],
    );
  }
}

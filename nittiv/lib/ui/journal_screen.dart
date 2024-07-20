import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Add this import statement
import 'settings_screen.dart';

class JournalScreen extends StatefulWidget {
  @override
  _JournalScreenState createState() => _JournalScreenState();
}

class _JournalScreenState extends State<JournalScreen> {
  final _entries = <JournalEntry>[];
  DateTime _selectedDate = DateTime.now();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _imageController = TextEditingController();

  void _addEntry() {
    final title = _titleController.text;
    final description = _descriptionController.text;
    final imagePath = _imageController.text;

    if (title.isEmpty || description.isEmpty || imagePath.isEmpty) return;

    setState(() {
      _entries.add(JournalEntry(
        date: _selectedDate,
        title: title,
        description: description,
        imagePath: imagePath,
      ));
    });

    Navigator.pop(context);
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
          'Journal',
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
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _entries.length,
              itemBuilder: (context, index) {
                final entry = _entries[index];
                return ListTile(
                  leading: entry.imagePath.isNotEmpty
                      ? Image.asset(
                          entry.imagePath,
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                        )
                      : null,
                  title: Text(entry.title),
                  subtitle: Text(
                      '${DateFormat.yMMMd().format(entry.date)}\n${entry.description}'),
                );
              },
            ),
          ),
          ElevatedButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: Text('Add Journal Entry'),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextField(
                          controller: _titleController,
                          decoration: InputDecoration(labelText: 'Title'),
                        ),
                        TextField(
                          controller: _descriptionController,
                          decoration: InputDecoration(labelText: 'Description'),
                        ),
                        TextField(
                          controller: _imageController,
                          decoration: InputDecoration(labelText: 'Image Path'),
                        ),
                        SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: _addEntry,
                          child: Text('Add Entry'),
                        ),
                      ],
                    ),
                  );
                },
              );
            },
            child: Text('Add Journal Entry'),
          ),
        ],
      ),
    );
  }
}

class JournalEntry {
  final DateTime date;
  final String title;
  final String description;
  final String imagePath;

  JournalEntry({
    required this.date,
    required this.title,
    required this.description,
    required this.imagePath,
  });
}

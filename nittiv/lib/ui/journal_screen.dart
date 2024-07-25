import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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
  int _selectedTabIndex = 0;

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

  Widget _buildTabContent() {
    if (_selectedTabIndex == 0) {
      return Center(child: Text('Calendar View'));
    } else if (_selectedTabIndex == 1) {
      return Center(child: Text('Gallery View'));
    } else {
      return ListView.builder(
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
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Journal',
              style: TextStyle(
                color: Color(0xFF008575),
                fontWeight: FontWeight.w200,
              ),
            ),
            Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'Hello,',
                      style: TextStyle(
                        fontSize: 12,
                        color: Color(0xFF008575),
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                    Text(
                      'Alexandra',
                      style: TextStyle(
                        fontSize: 20,
                        color: Color(0xFF008575),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                SizedBox(width: 10),
                CircleAvatar(
                  backgroundImage: AssetImage('assets/profile_image.jpg'),
                ),
              ],
            ),
          ],
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: Color(0xFF008575)),
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
          Container(
            padding: EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  'View:',
                  style: TextStyle(
                    color: Color(0xFF008575),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(width: 10),
                ChoiceChip(
                  label: Text(
                    'Calendar',
                    style: TextStyle(
                      color: Color(0xFF5CAFA5),
                    ),
                  ),
                  selected: _selectedTabIndex == 0,
                  onSelected: (selected) {
                    setState(() {
                      _selectedTabIndex = 0;
                    });
                  },
                  side: BorderSide(color: Color(0xFF5CAFA5)),
                ),
                SizedBox(width: 10),
                ChoiceChip(
                  label: Text(
                    'Gallery',
                    style: TextStyle(
                      color: Color(0xFF5CAFA5),
                    ),
                  ),
                  selected: _selectedTabIndex == 1,
                  onSelected: (selected) {
                    setState(() {
                      _selectedTabIndex = 1;
                    });
                  },
                  side: BorderSide(color: Color(0xFF5CAFA5)),
                ),
                SizedBox(width: 10),
                ChoiceChip(
                  label: Text(
                    'List',
                    style: TextStyle(
                      color: Color(0xFF5CAFA5),
                    ),
                  ),
                  selected: _selectedTabIndex == 2,
                  onSelected: (selected) {
                    setState(() {
                      _selectedTabIndex = 2;
                    });
                  },
                  side: BorderSide(color: Color(0xFF5CAFA5)),
                ),
              ],
            ),
          ),
          Expanded(child: _buildTabContent()),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
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
                            decoration:
                                InputDecoration(labelText: 'Description'),
                          ),
                          TextField(
                            controller: _imageController,
                            decoration:
                                InputDecoration(labelText: 'Image Path'),
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

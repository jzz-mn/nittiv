import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
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
  int _highlightedIndex = -1;

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
      return _buildCalendarView();
    } else if (_selectedTabIndex == 1) {
      return Center(child: Text('Gallery View'));
    } else {
      return ListView.builder(
        itemCount: _entries.length,
        itemBuilder: (context, index) {
          final entry = _entries[index];
          return Container(
            margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            padding: EdgeInsets.all(12.0),
            decoration: BoxDecoration(
              color:
                  _highlightedIndex == index ? Color(0xFF008575) : Colors.white,
              borderRadius: BorderRadius.circular(8.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                entry.imagePath.isNotEmpty
                    ? Image.asset(
                        entry.imagePath,
                        width: 175,
                        height: 150,
                        fit: BoxFit.cover,
                      )
                    : SizedBox(
                        width: 100,
                        height: 100,
                        child: Placeholder(),
                      ),
                SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Title: ${entry.title}',
                        overflow: TextOverflow.visible,
                        maxLines: null, // Remove line limit
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: _highlightedIndex == index
                              ? Colors.white
                              : Colors.black,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Date: ${DateFormat.yMMMd().format(entry.date)}',
                        overflow: TextOverflow.visible,
                        maxLines: null, // Remove line limit
                        style: TextStyle(
                          fontSize: 14,
                          color: _highlightedIndex == index
                              ? Colors.white
                              : Colors.grey[600],
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Description: ${entry.description}',
                        overflow: TextOverflow.visible,
                        maxLines: null, // Remove line limit
                        style: TextStyle(
                          fontSize: 14,
                          color: _highlightedIndex == index
                              ? Colors.white
                              : Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      );
    }
  }

  Widget _buildCalendarView() {
    Map<DateTime, List<JournalEntry>> _groupedEntries = {};

    for (var entry in _entries) {
      if (_groupedEntries[entry.date] == null) {
        _groupedEntries[entry.date] = [];
      }
      _groupedEntries[entry.date]!.add(entry);
    }

    return Column(
      children: [
        TableCalendar(
          focusedDay: _selectedDate,
          firstDay: DateTime.utc(2020, 1, 1),
          lastDay: DateTime.utc(2100, 12, 31),
          calendarFormat: CalendarFormat.month,
          selectedDayPredicate: (day) {
            return isSameDay(day, _selectedDate);
          },
          onDaySelected: (selectedDay, focusedDay) {
            setState(() {
              _selectedDate = selectedDay;
            });
          },
          eventLoader: (day) {
            return _groupedEntries[day] ?? [];
          },
          calendarStyle: CalendarStyle(
            selectedDecoration: BoxDecoration(
              color: Color.fromRGBO(0, 133, 117, 1),
              shape: BoxShape.circle,
            ),
            todayDecoration: BoxDecoration(
              color: Colors.blue,
              shape: BoxShape.circle,
            ),
            markerDecoration: BoxDecoration(
              color: Colors.red,
              shape: BoxShape.circle,
            ),
          ),
        ),
        Expanded(
          child: ListView(
            children: _groupedEntries[_selectedDate] != null
                ? _groupedEntries[_selectedDate]!.map((entry) {
                    return ListTile(
                      leading: entry.imagePath.isNotEmpty
                          ? Image.asset(
                              entry.imagePath,
                              width: 50,
                              height: 50,
                              fit: BoxFit.cover,
                            )
                          : SizedBox(
                              width: 50,
                              height: 50,
                              child: Placeholder(),
                            ),
                      title:
                          Text('Title: ${entry.title}'), // Removed truncation
                      subtitle: Text(
                          'Date: ${DateFormat.yMMMd().format(entry.date)}'),
                      onTap: () {
                        setState(() {
                          _selectedTabIndex = 2;
                          _highlightedIndex = _entries.indexOf(entry);
                        });
                      },
                    );
                  }).toList()
                : [Center(child: Text('No entries for selected date'))],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Journal',
          style: TextStyle(
            color: Color(0xFF008575),
            fontWeight: FontWeight.w200,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
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
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _titleController.clear();
          _descriptionController.clear();
          _imageController.clear();
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            builder: (context) {
              return Padding(
                padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom,
                ),
                child: Container(
                  padding: EdgeInsets.all(16.0),
                  child: SingleChildScrollView(
                    child: Column(
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
                  ),
                ),
              );
            },
          );
        },
        child: Icon(Icons.add),
        backgroundColor: Color(0xFF008575),
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

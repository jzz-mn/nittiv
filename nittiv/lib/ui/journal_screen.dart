import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import 'loading_screen.dart';
import 'settings_screen.dart';
import 'entries_manager.dart';

class JournalScreen extends StatefulWidget {
  @override
  _JournalScreenState createState() => _JournalScreenState();
}

class _JournalScreenState extends State<JournalScreen> {
  final EntriesManager _entriesManager = EntriesManager();
  DateTime _selectedDate = DateTime.now();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  List<Map<String, dynamic>> _places = [];
  Map<String, dynamic>? _selectedPlace;
  int _selectedTabIndex = 0;
  int _highlightedIndex = -1;

  @override
  void initState() {
    super.initState();
    _loadPlaces();
    _entriesManager.loadEntries().then((_) {
      setState(() {});
    });
  }

  void _loadPlaces() async {
    String data = await DefaultAssetBundle.of(context)
        .loadString('assets/place_info.json');
    final jsonResult = json.decode(data);
    final List<Map<String, dynamic>> places = [];
    for (var region in jsonResult) {
      for (var place in region['places']) {
        places.add(place);
      }
    }
    setState(() {
      _places = places;
    });
  }

  Future<void> _addEntry() async {
    final title = _titleController.text;
    final description = _descriptionController.text;
    final placeName = _selectedPlace?['name'] ?? '';
    final imagePath = _selectedPlace?['imagePath'] ?? '';

    if (title.isEmpty || description.isEmpty || placeName.isEmpty) return;

    final newEntry = JournalEntry(
      title: title,
      description: description,
      placeName: placeName,
      date: _selectedDate,
      images: [imagePath],
    );

    await _entriesManager.addEntry(newEntry);
    setState(() {});

    Navigator.pop(context);
  }

  Future<void> _deleteEntry(JournalEntry entry) async {
    await _entriesManager.deleteEntry(entry);
    setState(() {});
  }

  Widget _buildTabContent() {
    if (_selectedTabIndex == 0) {
      return _buildCalendarView();
    } else {
      return _buildEntriesView();
    }
  }

  Widget _buildCalendarView() {
    Map<DateTime, List<JournalEntry>> _groupedEntries = {};

    for (var entry in _entriesManager.getEntries()) {
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
              color: Color(0xFF008575),
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
                    return Dismissible(
                      key: UniqueKey(),
                      background: Container(
                        color: Colors.red,
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: Padding(
                            padding: EdgeInsets.only(right: 16.0),
                            child: Icon(Icons.delete, color: Colors.white),
                          ),
                        ),
                      ),
                      direction: DismissDirection.endToStart,
                      onDismissed: (direction) async {
                        await _deleteEntry(entry);
                      },
                      child: ListTile(
                        leading: entry.images.isNotEmpty
                            ? Image.asset(
                                entry.images[0],
                                width: 50,
                                height: 50,
                                fit: BoxFit.cover,
                              )
                            : SizedBox(
                                width: 50,
                                height: 50,
                                child: Placeholder(),
                              ),
                        title: Text('Title: ${entry.title}'),
                        subtitle: Text(
                            'Date: ${DateFormat.yMMMd().format(entry.date)}'),
                        onTap: () {
                          setState(() {
                            _selectedTabIndex = 1;
                            _highlightedIndex =
                                _entriesManager.getEntries().indexOf(entry);
                          });
                        },
                      ),
                    );
                  }).toList()
                : [Center(child: Text('No entries for selected date'))],
          ),
        ),
      ],
    );
  }

  Widget _buildEntriesView() {
    return ListView.builder(
      itemCount: _entriesManager.getEntries().length,
      itemBuilder: (context, index) {
        final entry = _entriesManager.getEntries()[index];
        return Dismissible(
          key: UniqueKey(),
          background: Container(
            color: Colors.red,
            child: Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: EdgeInsets.only(right: 16.0),
                child: Icon(Icons.delete, color: Colors.white),
              ),
            ),
          ),
          direction: DismissDirection.endToStart,
          onDismissed: (direction) {
            _deleteEntry(entry);
          },
          child: Container(
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
                entry.images.isNotEmpty
                    ? Image.asset(
                        entry.images[0],
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
                        maxLines: null,
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
                        maxLines: null,
                        style: TextStyle(
                          fontSize: 14,
                          color: _highlightedIndex == index
                              ? Colors.white
                              : Colors.grey[600],
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Place: ${entry.placeName}',
                        overflow: TextOverflow.visible,
                        maxLines: null,
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
                        maxLines: null,
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
          ),
        );
      },
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
                      color: _selectedTabIndex == 0
                          ? Colors.white
                          : Color(0xFF5CAFA5),
                    ),
                  ),
                  selected: _selectedTabIndex == 0,
                  selectedColor: Color(0xFF008575),
                  onSelected: (selected) {
                    setState(() {
                      _selectedTabIndex = 0;
                    });
                  },
                ),
                SizedBox(width: 10),
                ChoiceChip(
                  label: Text(
                    'Entries',
                    style: TextStyle(
                      color: _selectedTabIndex == 1
                          ? Colors.white
                          : Color(0xFF5CAFA5),
                    ),
                  ),
                  selected: _selectedTabIndex == 1,
                  selectedColor: Color(0xFF008575),
                  onSelected: (selected) {
                    setState(() {
                      _selectedTabIndex = 1;
                      _highlightedIndex = -1;
                    });
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: _buildTabContent(),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color(0xFF008575),
        onPressed: () {
          _titleController.clear();
          _descriptionController.clear();
          _selectedPlace = null;
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text('Add Entry'),
                content: SingleChildScrollView(
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
                      DropdownButtonFormField<Map<String, dynamic>>(
                        value: _selectedPlace,
                        decoration: InputDecoration(labelText: 'Select Place'),
                        items: _places
                            .map((place) => DropdownMenuItem(
                                  value: place,
                                  child: Row(
                                    children: [
                                      Image.asset(
                                        place['imagePath'],
                                        width: 50,
                                        height: 50,
                                        fit: BoxFit.cover,
                                      ),
                                      SizedBox(width: 10),
                                      Text(place['name']),
                                    ],
                                  ),
                                ))
                            .toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedPlace = value;
                          });
                        },
                      ),
                    ],
                  ),
                ),
                actions: [
                  TextButton(
                    child: Text('Cancel'),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  TextButton(
                    child: Text('Add'),
                    onPressed: _addEntry,
                  ),
                ],
              );
            },
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

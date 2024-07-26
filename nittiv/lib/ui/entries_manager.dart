import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class JournalEntry {
  final String title;
  final String description;
  final String placeName;
  final DateTime date;
  final List<String> images;

  JournalEntry({
    required this.title,
    required this.description,
    required this.placeName,
    required this.date,
    required this.images,
  });

  // Convert a JournalEntry into a Map
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'placeName': placeName,
      'date': date.toIso8601String(),
      'images': images,
    };
  }

  // Create a JournalEntry from a Map
  factory JournalEntry.fromMap(Map<String, dynamic> map) {
    return JournalEntry(
      title: map['title'],
      description: map['description'],
      placeName: map['placeName'],
      date: DateTime.parse(map['date']),
      images: List<String>.from(map['images']),
    );
  }
}

class EntriesManager {
  static const String _key = 'journal_entries';
  List<JournalEntry> _entries = [];

  // Load entries from SharedPreferences
  Future<void> loadEntries() async {
    final prefs = await SharedPreferences.getInstance();
    final entriesJson = prefs.getString(_key);
    if (entriesJson != null) {
      final entriesList = json.decode(entriesJson) as List;
      _entries = entriesList.map((e) => JournalEntry.fromMap(e)).toList();
    }
  }

  // Save entries to SharedPreferences
  Future<void> _saveEntries() async {
    final prefs = await SharedPreferences.getInstance();
    final entriesJson = json.encode(_entries.map((e) => e.toMap()).toList());
    await prefs.setString(_key, entriesJson);
  }

  Future<void> addEntry(JournalEntry entry) async {
    _entries.add(entry);
    await _saveEntries();
  }

  Future<void> deleteEntry(JournalEntry entry) async {
    _entries.remove(entry);
    await _saveEntries();
  }

  List<JournalEntry> getEntries() {
    return _entries;
  }
}

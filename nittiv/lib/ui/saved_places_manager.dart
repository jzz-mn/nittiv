// saved_places_manager.dart
import 'package:shared_preferences/shared_preferences.dart';

class SavedPlacesManager {
  static const String _key = 'saved_places';

  static Future<List<String>> getSavedPlaces() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_key) ?? [];
  }

  static Future<void> savePlace(String placeName) async {
    final prefs = await SharedPreferences.getInstance();
    final savedPlaces = await getSavedPlaces();
    if (!savedPlaces.contains(placeName)) {
      savedPlaces.add(placeName);
      await prefs.setStringList(_key, savedPlaces);
    }
  }

  static Future<void> removePlace(String placeName) async {
    final prefs = await SharedPreferences.getInstance();
    final savedPlaces = await getSavedPlaces();
    savedPlaces.remove(placeName);
    await prefs.setStringList(_key, savedPlaces);
  }
}

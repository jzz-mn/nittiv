import 'dart:convert';
import 'package:flutter/services.dart';

class DataService {
  Future<List<dynamic>> fetchPlaces() async {
    final response = await rootBundle.loadString('assets/place_info.json');
    final data = json.decode(response);
    return data.map((place) => Place.fromJson(place)).toList();
  }
}

class Place {
  final String name;
  final String imagePath;

  Place({required this.name, required this.imagePath});

  factory Place.fromJson(Map<String, dynamic> json) {
    return Place(
      name: json['name'] ?? 'Unknown Place',
      imagePath: json['imagePath'] ?? 'https://example.com/default_image.jpg',
    );
  }
}

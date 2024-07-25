class Place {
  final String name;
  final String description;
  final String location;
  final String imagePath;
  final String accessibility;
  final String landscape;
  final String region;
  final String highlight;
  final String recommendedVisitTime;
  final String travelerTips;

  Place({
    required this.name,
    required this.description,
    required this.location,
    required this.imagePath,
    required this.accessibility,
    required this.landscape,
    required this.region,
    required this.highlight,
    required this.recommendedVisitTime,
    required this.travelerTips,
  });

  factory Place.fromJson(Map<String, dynamic> json, String region) {
    return Place(
      name: json['name'],
      description: json['description'],
      location: json['location'],
      imagePath: json['imagePath'],
      accessibility: json['accessibility'] ?? 'Unknown',
      landscape: json['landscape'] ?? 'Unknown',
      region: region,
      highlight: json['highlight'],
      recommendedVisitTime: json['recommendedVisitTime'],
      travelerTips: json['travelerTips'],
    );
  }
}

class Incident {
  final String imageUrl;
  final String location;
  final String timestamp;

  Incident({
    required this.imageUrl,
    required this.location,
    required this.timestamp,
  });

  factory Incident.fromJson(Map<String, dynamic> json) {
    return Incident(
      location: json['location'] ?? '',
      timestamp: json['timestamp'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
    );
  }
}

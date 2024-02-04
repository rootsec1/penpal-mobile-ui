/*
locationEntries.add({
"latitude": position.latitude,
"longitude": position.longitude,
"timestamp": position.timestamp,
});
*/

class LocationLogModel {
  final double latitude;
  final double longitude;
  final String timestamp;

  LocationLogModel({
    required this.latitude,
    required this.longitude,
    required this.timestamp,
  });

  Map<String, dynamic> toJson() {
    return {
      "latitude": latitude,
      "longitude": longitude,
      "timestamp": timestamp,
    };
  }

  factory LocationLogModel.fromJson(Map<String, dynamic> json) {
    return LocationLogModel(
      latitude: json['latitude'],
      longitude: json['longitude'],
      timestamp: json['timestamp'],
    );
  }
}

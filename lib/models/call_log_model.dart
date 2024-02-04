/*
callEntries.add({
"to_number": callLogEntry.number,
"duration": callLogEntry.duration, // in milliseconds
"type": callLogEntry.callType,
"timestamp": callLogEntry.timestamp,
});
*/

class CallLogModel {
  final String toNumber;
  final int duration;
  final String type;
  final int timestamp;

  CallLogModel({
    required this.toNumber,
    required this.duration,
    required this.type,
    required this.timestamp,
  });

  Map<String, dynamic> toJson() {
    return {
      "to_number": toNumber,
      "duration": duration,
      "type": type,
      "timestamp": timestamp,
    };
  }

  factory CallLogModel.fromJson(Map<String, dynamic> json) {
    return CallLogModel(
      toNumber: json['to_number'],
      duration: json['duration'],
      type: json['type'],
      timestamp: json['timestamp'],
    );
  }
}

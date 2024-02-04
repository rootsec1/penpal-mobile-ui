/*
calendarEntries.add({
"title": event.title,
"description": event.description,
"timestamp_start": event.start.toString(),
"timestamp_end": event.end.toString(),
});
*/

class CalendarLogModel {
  final String title;
  final String description;
  final String timestampStart;
  final String timestampEnd;

  CalendarLogModel({
    required this.title,
    required this.description,
    required this.timestampStart,
    required this.timestampEnd,
  });

  Map<String, dynamic> toJson() {
    return {
      "title": title,
      "description": description,
      "timestamp_start": timestampStart,
      "timestamp_end": timestampEnd,
    };
  }

  factory CalendarLogModel.fromJson(Map<String, dynamic> json) {
    return CalendarLogModel(
      title: json['title'],
      description: json['description'],
      timestampStart: json['timestamp_start'],
      timestampEnd: json['timestamp_end'],
    );
  }
}

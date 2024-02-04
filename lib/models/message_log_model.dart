/*
messageEntries.add({
"to_number": message.address,
"body": message.body,
"timestamp": message.dateSent,
});
*/

class MessageLogModel {
  final String toNumber;
  final String body;
  final String timestamp;

  MessageLogModel({
    required this.toNumber,
    required this.body,
    required this.timestamp,
  });

  Map<String, dynamic> toJson() {
    return {
      "to_number": toNumber,
      "body": body,
      "timestamp": timestamp,
    };
  }

  factory MessageLogModel.fromJson(Map<String, dynamic> json) {
    return MessageLogModel(
      toNumber: json['to_number'],
      body: json['body'],
      timestamp: json['timestamp'],
    );
  }
}

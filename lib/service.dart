// ignore_for_file: use_build_context_synchronously
import 'package:dio/dio.dart';
import 'package:penpal/constants.dart';
import 'package:penpal/models/calendar_log_model.dart';
import 'package:penpal/models/call_log_model.dart';
import 'package:penpal/models/location_log_model.dart';
import 'package:penpal/models/message_log_model.dart';
import 'package:penpal/models/usage_log_model.dart';

final Dio dio = Dio();

Future<List<String>> syncContactsNumberAndName(
    Map<String, String> contactsMap) async {
  final response = await dio.post(
    "$baseApiUrl/contacts/sync/",
    data: contactsMap,
  );
  List<String> contacts = List<String>.from(response.data);
  return contacts;
}

Future<String> syncRunningJournalToServer(
  List<CallLogModel> callEntries,
  List<MessageLogModel> messageEntries,
  List<CalendarLogModel> calendarEntries,
  List<LocationLogModel> locationEntries,
  List<UsageLogModel> usageStatsEntries,
) async {
  final response = await dio.post(
    "$baseApiUrl/journal/sync/",
    data: {
      "call_logs": callEntries.map((e) => e.toJson()).toList(),
      "message_logs": messageEntries.map((e) => e.toJson()).toList(),
      "calendar_logs": calendarEntries.map((e) => e.toJson()).toList(),
      "location_logs": locationEntries.map((e) => e.toJson()).toList(),
      "usage_logs": usageStatsEntries.map((e) => e.toJson()).toList(),
    },
  );
  final String runningJournal = response.data;
  return runningJournal;
}

Future<String> describeImageAndMergeWithText(
  String imageUrl,
  String existingContent,
) async {
  final response = await dio.post(
    "$baseApiUrl/util/describe_image_and_merge_with_text/",
    data: {
      "image_url": imageUrl,
      "text": existingContent,
    },
  );
  final String mergedContent = response.data;
  return mergedContent;
}

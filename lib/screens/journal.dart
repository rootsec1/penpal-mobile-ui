// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:call_log/call_log.dart';
import 'package:device_calendar/device_calendar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sms_inbox/flutter_sms_inbox.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';
import 'package:firebase_storage/firebase_storage.dart';

// Local
import 'package:penpal/constants.dart';
import 'package:penpal/models/calendar_log_model.dart';
import 'package:penpal/models/call_log_model.dart';
import 'package:penpal/models/location_log_model.dart';
import 'package:penpal/models/message_log_model.dart';
import 'package:penpal/models/usage_log_model.dart';
import 'package:penpal/service.dart';
import 'package:penpal/util.dart';
import 'package:penpal/widgets/custom_appbar.dart';
import 'package:usage_stats/usage_stats.dart';

final firebaseStorageRef = FirebaseStorage.instance.ref();

class JournalFragment extends StatefulWidget {
  const JournalFragment({super.key});

  @override
  State<JournalFragment> createState() => _JournalFragmentState();
}

class _JournalFragmentState extends State<JournalFragment> {
  final SmsQuery smsQuery = SmsQuery();
  final DeviceCalendarPlugin _deviceCalendarPlugin = DeviceCalendarPlugin();
  final ImagePicker _picker = ImagePicker();
  final AudioPlayer audioPlayer = AudioPlayer();

  final List<CallLogModel> callEntries = [];
  final List<MessageLogModel> messageEntries = [];
  final List<CalendarLogModel> calendarEntries = [];
  final List<LocationLogModel> locationEntries = [];
  final List<UsageLogModel> usageStatsEntries = [];

  String _runningJournalContent = "";
  bool _isLoading = true;
  bool _isAudioLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: _isLoading
          ? null
          : Container(
              margin: const EdgeInsets.only(
                right: standardSeparation,
                bottom: standardSeparation / 2,
              ),
              child: FloatingActionButton(
                onPressed: onSpeakerButtonPressed,
                child: _isAudioLoading
                    ? const CircularProgressIndicator()
                    : const Icon(Icons.speaker_outlined),
              ),
            ),
      body: Container(
        margin: const EdgeInsets.only(
          left: standardSeparation,
          right: standardSeparation,
          top: standardSeparation,
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                const CustomAppBarRowWidget(),
                if (_isLoading)
                  SizedBox(height: MediaQuery.of(context).size.height / 6),
                if (_isLoading)
                  Container(
                    alignment: Alignment.center,
                    margin: const EdgeInsets.all(standardSeparation),
                    child: LottieBuilder.asset("assets/lottie/loading.json"),
                  ),
                if (!_isLoading) const SizedBox(height: standardSeparation),
                if (!_isLoading)
                  RunningJournalCard(
                    onAddVisualContextButtonPressed:
                        getPhotosTakenFromTodayWithPlaceMetadata,
                    runningJournalContent: _runningJournalContent,
                  ),
                if (!_isLoading) const SizedBox(height: standardSeparation * 2),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void didChangeDependencies() {
    audioPlayer.onPlayerStateChanged.listen((event) {
      if (event == PlayerState.paused) {
        audioPlayer.resume();
      } else {
        audioPlayer.pause();
      }
    });
    fetchDataPoints();
    super.didChangeDependencies();
  }

  @override
  dispose() {
    callEntries.clear();
    messageEntries.clear();
    calendarEntries.clear();
    locationEntries.clear();
    usageStatsEntries.clear();
    super.dispose();
  }

  fetchDataPoints() async {
    await getCallLogEntriesFromStartOfDay();
    await getMessagesFromStartOfDay();
    await getCalendarEventsForToday();
    await getPlacesVisited();
    await getUsageStats();
    await pushRunningJournalDataToServer();
  }

  Future<void> getCallLogEntriesFromStartOfDay() async {
    DateTime now = DateTime.now();
    DateTime startOfDay = DateTime(now.year, now.month, now.day);
    Iterable<CallLogEntry> callLogEntries = await CallLog.query(
      dateFrom: startOfDay.millisecondsSinceEpoch,
      dateTo: now.millisecondsSinceEpoch,
    );

    for (CallLogEntry callLogEntry in callLogEntries) {
      callEntries.add(
        CallLogModel(
          toNumber: callLogEntry.number ?? "Unknown",
          duration: callLogEntry.duration ?? 0,
          type: callLogEntry.callType?.toString() ?? "Unknown",
          timestamp: callLogEntry.timestamp ?? 0,
        ),
      );
    }
  }

  Future<void> getMessagesFromStartOfDay() async {
    List<SmsMessage> messages = await smsQuery.querySms(
      kinds: [SmsQueryKind.inbox, SmsQueryKind.sent],
    );

    for (SmsMessage message in messages) {
      messageEntries.add(
        MessageLogModel(
          toNumber: message.address ?? "Unknown",
          body: message.body ?? "Unknown",
          timestamp: message.dateSent?.toString() ?? "Unknown",
        ),
      );
    }
  }

  Future<void> getCalendarEventsForToday() async {
    DateTime now = DateTime.now();
    DateTime startOfDay = DateTime(now.year, now.month, now.day);
    DateTime endOfDay = DateTime(now.year, now.month, now.day, 23, 59, 59);
    final calendarResult = await _deviceCalendarPlugin.retrieveCalendars();
    final calendarsIterable = List.from(calendarResult.data as Iterable);

    for (Calendar calendar in calendarsIterable) {
      final events = await _deviceCalendarPlugin.retrieveEvents(
        calendar.id,
        RetrieveEventsParams(startDate: startOfDay, endDate: endOfDay),
      );
      for (Event event in List.from(events.data as Iterable)) {
        calendarEntries.add(
          CalendarLogModel(
            title: event.title ?? "Unknown",
            description: event.description ?? "Unknown",
            timestampStart: event.start.toString(),
            timestampEnd: event.end.toString(),
          ),
        );
      }
    }
  }

  Future<void> getPlacesVisited() async {
    print("LocationStream");
    Position? position = await Geolocator.getLastKnownPosition(
        forceAndroidLocationManager: true);
    if (position != null) {
      locationEntries.add(
        LocationLogModel(
          latitude: position.latitude,
          longitude: position.longitude,
          timestamp: position.timestamp.toString(),
        ),
      );
    }
  }

  Future<void> getUsageStats() async {
    DateTime now = DateTime.now();
    DateTime startOfDay = DateTime(now.year, now.month, now.day);
    List<UsageInfo> usageStats = await UsageStats.queryUsageStats(
      startOfDay,
      now,
    );
    print("UsageStats");
    print(usageStats.length);
    List<UsageInfo> usageStatsFiltered = usageStats
        .where((element) =>
            int.parse(element.totalTimeInForeground!) > 0 &&
            !element.packageName!.contains("android") &&
            !element.packageName!.contains("google"))
        .toList();
    for (UsageInfo usageInfo in usageStatsFiltered) {
      usageStatsEntries.add(
        UsageLogModel(
          packageName: usageInfo.packageName ?? "Unknown",
          totalTimeInForeground: int.parse(usageInfo.totalTimeInForeground!),
        ),
      );
    }
  }

  Future<void> getPhotosTakenFromTodayWithPlaceMetadata() async {
    print("FetchPhotos");
    DateTime now = DateTime.now();
    DateTime startOfDay = DateTime(now.year, now.month, now.day);
    XFile? selectedImage = await _picker.pickImage(source: ImageSource.gallery);
    if (selectedImage == null || selectedImage.path.isEmpty) {
      return;
    }

    final String journalContentPresent = _runningJournalContent;

    final tempStorageRef = firebaseStorageRef.child("temp.jpg");
    File tempFile = File(selectedImage.path);
    try {
      await tempStorageRef.putFile(tempFile);
      setState(() {
        _isLoading = true;
        _runningJournalContent = "";
      });

      await tempStorageRef.getDownloadURL().then((value) async {
        final String imageUrl = value.toString();
        print(imageUrl);

        final String mergedContent = await describeImageAndMergeWithText(
          imageUrl,
          journalContentPresent,
        );

        setState(() {
          _runningJournalContent = mergedContent;
          _isLoading = false;
        });
      });
    } on FirebaseException {
      alertUser(
        "There was an error uploading the image",
        context,
      );
    }
  }

  Future<void> pushRunningJournalDataToServer() async {
    print("PushRunningJournalDataToServer");

    print(callEntries);
    print(messageEntries);
    print(calendarEntries);
    print(locationEntries);
    print(usageStatsEntries);

    try {
      final String generatedJournalContent = await syncRunningJournalToServer(
        callEntries,
        messageEntries,
        calendarEntries,
        locationEntries,
        usageStatsEntries,
      );
      print(generatedJournalContent);
      setState(() {
        _runningJournalContent = generatedJournalContent;
        _isLoading = false;
      });
    } catch (e) {
      print(e);
      alertUser(
        "There was an error summarizing data points",
        context,
      );
    }
  }

  onSpeakerButtonPressed() async {
    // The speech request.
    setState(() => _isAudioLoading = true);
    final String ttsUrl = "$baseApiUrl/util/tts/?text=$_runningJournalContent";
    audioPlayer.play(UrlSource(ttsUrl));
    setState(() => _isAudioLoading = false);
  }
}

class RunningJournalCard extends StatelessWidget {
  final VoidCallback onAddVisualContextButtonPressed;
  final String runningJournalContent;

  const RunningJournalCard({
    super.key,
    required this.onAddVisualContextButtonPressed,
    required this.runningJournalContent,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: standardSeparation * 1.5,
      color: Colors.grey[50],
      child: Container(
        padding: const EdgeInsets.all(standardSeparation),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Today.',
              style: GoogleFonts.prata(
                fontSize: standardSeparation * 2,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: standardSeparation * 2),
            Text(
              runningJournalContent,
              style: GoogleFonts.ooohBaby(fontSize: standardSeparation * 1.5),
            ),
            const SizedBox(height: standardSeparation * 2),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: onAddVisualContextButtonPressed,
                icon: const Icon(Icons.camera_alt),
                label: const Text("add visual context"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

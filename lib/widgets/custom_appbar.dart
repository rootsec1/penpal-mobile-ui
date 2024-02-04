import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:penpal/constants.dart';
import 'package:penpal/theme.dart';
import 'package:penpal/util.dart';
import 'package:penpal/widgets/logo.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

stt.SpeechToText speech = stt.SpeechToText();

class CustomAppBarRowWidget extends StatefulWidget {
  const CustomAppBarRowWidget({super.key});

  @override
  State<CustomAppBarRowWidget> createState() => _CustomAppBarRowWidgetState();
}

class _CustomAppBarRowWidgetState extends State<CustomAppBarRowWidget> {
  bool isRecording = false;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const LogoWidget(fontSize: standardSeparation * 2),
            Text(
              'Hey Abhishek :)',
              style: GoogleFonts.ooohBaby(
                fontSize: standardSeparation * 1.5,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const Expanded(child: SizedBox()),
        IconButton(
          onPressed: onMicButtonPressed,
          icon: Icon(
            Icons.mic,
            size: standardSeparation * 2,
            color: isRecording ? Colors.red : defaultTextColor,
          ),
        ),
        // Title
        LottieBuilder.asset("assets/lottie/smiley.json"),
      ],
    );
  }

  onMicButtonPressed() async {
    print('here');
    if (isRecording) {
      setState(() => isRecording = false);
      speech.stop();
    }

    alertUser(
      "You can speak into your phone now and click the mic icon again when done",
      context,
    );

    bool available = await speech.initialize(
      onStatus: (status) => print("onStatus: $status"),
      onError: (errorNotification) {
        alertUser(
          "Speech to text error: $errorNotification",
          context,
        );
        setState(() => isRecording = false);
      },
    );
    if (available) {
      setState(() => isRecording = true);
      speech.listen(
        onResult: (result) {
          print("onResult: $result");
          String speech = result.recognizedWords;
          print("Speech: $speech");
          alertUser(speech, context);
        },
      );
    } else {
      print("The user has denied the use of speech recognition.");
    }
  }
}

// ignore_for_file: use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:lottie/lottie.dart';
import 'package:penpal/constants.dart';
import 'package:penpal/service.dart';
import 'package:penpal/theme.dart';
import 'package:penpal/widgets/logo.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:usage_stats/usage_stats.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void didChangeDependencies() {
    requestPermissions();
    syncContacts();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: const EdgeInsets.symmetric(horizontal: standardSeparation),
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Lottie
            Container(
              margin: const EdgeInsets.all(standardSeparation / 2),
              child: Lottie.asset('assets/lottie/splash.json'),
            ),
            // Title
            const LogoWidget(fontSize: standardSeparation * 4),
            // Subtitle
            Text(
              'Copilot for your journal',
              style: GoogleFonts.ooohBaby(
                fontSize: standardSeparation * 2,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: standardSeparation * 4),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: signInWithGoogle,
                icon: Image.asset(
                  'assets/images/google.png',
                  width: standardSeparation,
                ),
                label: const Text(
                  "Sign in with Google",
                  style: TextStyle(
                    color: defaultTextColor,
                    fontSize: standardSeparation * 1.5,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> signInWithGoogle() async {
    await FirebaseAuth.instance.signOut();
    await GoogleSignIn().signOut();

    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);
    } finally {
      await Navigator.pushNamedAndRemoveUntil(
        context,
        ScreenNames.HOME.name,
        (route) => false,
      );
    }
  }

  requestPermissions() async {
    await Permission.photos.request();
    await Permission.camera.request();
    await Permission.locationAlways.request();
    await Permission.locationWhenInUse.request();
    await Permission.location.request();
    await Permission.accessMediaLocation.request();
    await Permission.phone.request();
    await Permission.microphone.request();
    await Permission.speech.request();
    await Permission.storage.request();
    await Permission.manageExternalStorage.request();
    await Permission.mediaLibrary.request();
    await Permission.notification.request();
    await Permission.calendarFullAccess.request();
    await Permission.reminders.request();
    await Permission.sms.request();
    await Permission.contacts.request();
    await Permission.activityRecognition.request();
    await Permission.appTrackingTransparency.request();
    await Permission.sensorsAlways.request();
    await Permission.videos.request();
    await UsageStats.grantUsagePermission();
    await PhotoManager.requestPermissionExtend(
      requestOption: const PermissionRequestOption(
        androidPermission: AndroidPermission(
          type: RequestType.image,
          mediaLocation: true,
        ),
      ),
    );
  }

  syncContacts() async {
    List<Contact> contactList = await FlutterContacts.getContacts(
      withProperties: true,
    );
    Map<String, String> contactsMap = {};
    for (Contact contact in contactList) {
      String contactName = contact.displayName.trim();
      String contactNumber = contact.phones[0].normalizedNumber.trim();
      if (contactName.isEmpty || contactNumber.isEmpty) continue;

      contactsMap[contactNumber] = contactName;
    }

    List<String> contactsNumberNameList =
        await syncContactsNumberAndName(contactsMap);
    print("Contacts synced: $contactsNumberNameList");
  }
}

import 'package:dart_openai/dart_openai.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:penpal/constants.dart';
import 'package:penpal/firebase_options.dart';
import 'package:penpal/routes.dart';
import 'package:penpal/theme.dart';

Future<void> _runPreRenderOperations() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  OpenAI.apiKey = "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";
}

main(List<String> args) async {
  await _runPreRenderOperations();
  final MaterialApp materialApp = MaterialApp(
    debugShowCheckedModeBanner: false,
    title: appName,
    theme: appTheme,
    darkTheme: appTheme,
    routes: appRoutes,
    initialRoute: ScreenNames.SPLASH.name,
  );
  return runApp(materialApp);
}

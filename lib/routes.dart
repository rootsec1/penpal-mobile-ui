import 'package:flutter/material.dart';
import 'package:penpal/constants.dart';
import 'package:penpal/screens/home.dart';
import 'package:penpal/screens/splash.dart';

final Map<String, Widget Function(BuildContext)> appRoutes = {
  ScreenNames.SPLASH.name: (context) => const SplashScreen(),
  ScreenNames.HOME.name: (context) => const HomePage(),
};

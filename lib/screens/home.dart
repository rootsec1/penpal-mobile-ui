import 'package:flutter/material.dart';
import 'package:penpal/screens/chat.dart';
import 'package:penpal/screens/journal.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int currentPageIndex = 0;

  Widget getPage(int index) {
    switch (index) {
      case 1:
        return const Text("page 2");
      case 2:
        return const ChatFragment();
      case 3:
        return const Text("page 4");
      default:
        return const JournalFragment();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: getPage(currentPageIndex));
  }
}

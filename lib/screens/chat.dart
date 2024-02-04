import 'package:flutter/material.dart';
import 'package:penpal/constants.dart';
import 'package:penpal/widgets/custom_appbar.dart';

class ChatFragment extends StatefulWidget {
  const ChatFragment({super.key});

  @override
  State<ChatFragment> createState() => _ChatFragmentState();
}

class _ChatFragmentState extends State<ChatFragment> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: standardSeparation),
        child: Column(
          children: [
            const CustomAppBarRowWidget(),
            SizedBox(
              height: MediaQuery.of(context).size.height / 4,
            ),
            SizedBox(
              height: standardSeparation * 10,
              width: standardSeparation * 10,
              child: FloatingActionButton(
                onPressed: () {},
                child: const Icon(
                  Icons.mic,
                  size: standardSeparation * 8,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

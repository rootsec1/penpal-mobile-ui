import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LogoWidget extends StatelessWidget {
  const LogoWidget({super.key, this.fontSize = 32});

  final double fontSize;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Text(
          'Pen',
          style: GoogleFonts.prata(fontSize: fontSize),
        ),
        Text(
          'Pal',
          style: GoogleFonts.prata(
            fontSize: fontSize,
            color: Theme.of(context).primaryColor,
          ),
        ),
      ],
    );
  }
}

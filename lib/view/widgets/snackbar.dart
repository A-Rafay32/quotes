import 'package:flutter/material.dart';

import '../../res/constants.dart';

class SnackBarContent extends StatelessWidget {
  const SnackBarContent({
    super.key,
    required this.text,
  });

  final String text;

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    return SizedBox(
      width: w,
      child: RichText(
        text: TextSpan(children: [
          const TextSpan(
              text: ' " ',
              style: TextStyle(fontSize: 24, color: PopupCardColor)),
          TextSpan(
            text: text,
            style: const TextStyle(color: Colors.white70),
          ),
          const TextSpan(
            text: ' " ',
            style: TextStyle(fontSize: 24, color: PopupCardColor),
          ),
        ]),
      ),
    );
  }
}

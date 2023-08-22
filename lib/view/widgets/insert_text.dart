import 'package:flutter/material.dart';

class InsertQuoteText extends StatelessWidget {
  const InsertQuoteText({
    super.key,
    required this.h,
  });

  final double h;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.only(top: h * 0.3),
          child: Center(
            child: Text(
              "Write a Quote",
              style: TextStyle(
                  fontFamily: "Kanit",
                  fontSize: h * 0.038,
                  color: Colors.white54),
            ),
          ),
        )
      ],
    );
  }
}

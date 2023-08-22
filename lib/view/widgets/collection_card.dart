import 'package:flutter/material.dart';
import 'package:quotes/res/constants.dart';

import '../screens/user_collection_screen/user_collection.dart';

class CollectionCard extends StatefulWidget {
  const CollectionCard({
    super.key,
    required this.text,
  });
  final String text;

  @override
  State<CollectionCard> createState() => _CollectionCardState();
}

class _CollectionCardState extends State<CollectionCard> {
  Color borderColor = Colors.white70;
  double borderWidth = 1;

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.sizeOf(context).height;
    double w = MediaQuery.sizeOf(context).width;
    return GestureDetector(
        onLongPressCancel: () {
          setState(() {
            borderColor = Colors.white70;
            borderWidth = 1;
          });
        },
        onLongPress: () {
          setState(() {
            borderColor = PopupCardColor;
            borderWidth = 3;
          });
        },
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => const UserCollectionScreen(),
          ));
        },
        child: Container(
          // height: h * 0.,
          // width: w * 0.35,
          margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
              // color: kCardColor,
              border: Border.all(width: borderWidth, color: borderColor),
              borderRadius: BorderRadius.circular(20),
              boxShadow: const [
                BoxShadow(
                    blurRadius: 5,
                    color: Colors.transparent,
                    offset: Offset(10, 10))
              ]),
          child: Center(
              child: Text(
            widget.text,
            style: const TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.w100,
                color: Color.fromARGB(255, 219, 214, 214),
                fontFamily: "Kanit"),
          )),
        ));
  }
}

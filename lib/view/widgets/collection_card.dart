import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../res/constants.dart';
import '../../view_model/provider.dart';

class CollectionCard extends StatelessWidget {
  CollectionCard({
    super.key,
    required this.text,
    required this.borderColor,
    required this.borderWidth,
  });
  final String text;
  final Color borderColor;
  final double borderWidth;
  bool isSelected = false;

  @override
  Widget build(BuildContext context) {
    return Consumer<Model>(builder: (context, model, child) {
      return GestureDetector(
        onLongPress: () {
          model.unSelectAlbum();
          isSelected = model.isSelected;
          print("isSelected : $isSelected");
        },
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
              // color: kCardColor,
              border: Border.all(
                width: isSelected == true ? 3 : 1,
                color: isSelected == true ? PopupCardColor : Colors.white70,
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: const [
                BoxShadow(
                    blurRadius: 5,
                    color: Colors.transparent,
                    offset: Offset(10, 10))
              ]),
          child: Center(
              child: Text(
            text,
            style: const TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.w100,
                color: Color.fromARGB(255, 219, 214, 214),
                fontFamily: "Kanit"),
          )),
        ),
      );
    });
  }
}

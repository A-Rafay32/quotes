import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../model/models.dart';
import '../../res/constants.dart';
import '../../view_model/provider.dart';

class EditPopUpCard extends StatelessWidget {
  EditPopUpCard(
      {required this.quote,
      required this.quoteObj,
      required this.author,
      super.key});

  String quote;
  String author;
  Quote quoteObj;
  @override
  Widget build(BuildContext context) {
    Provider.of<Model>(context, listen: false).quoteController.text = quote;
    Provider.of<Model>(context, listen: false).authorController.text = author;
    final h = MediaQuery.sizeOf(context).height;
    final w = MediaQuery.sizeOf(context).width;
    return AlertDialog(
      backgroundColor: kCardColor,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20))),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller:
                Provider.of<Model>(context, listen: false).quoteController,
            cursorColor: Colors.white70,
            style: const TextStyle(fontSize: 21, fontFamily: "Kanit"),
            cursorHeight: 28,
            maxLines: 5,
            decoration: const InputDecoration(
              border: InputBorder.none,
            ),
          ),
          const Divider(
            color: Color.fromARGB(179, 214, 202, 202),
            thickness: 0.6,
          ),
          TextField(
            controller:
                Provider.of<Model>(context, listen: false).authorController,
            cursorColor: Colors.white70,
            cursorHeight: 19,
            // maxLines: 2,
            style: const TextStyle(fontSize: 20, fontFamily: "Rajdhani"),
            decoration: const InputDecoration(
              border: InputBorder.none,
            ),
          ),
          InkWell(
              onTap: () {
                //update quote
                Provider.of<Model>(context, listen: false)
                    .updateQuote(quoteObj);
                //Clear controllers
                Provider.of<Model>(context, listen: false)
                    .quoteController
                    .clear();

                Provider.of<Model>(context, listen: false)
                    .authorController
                    .clear();

                Navigator.pop(context);
              },
              child: const Icon(color: Colors.white70, size: 28, Icons.done)),
        ],
      ),
    );
  }
}

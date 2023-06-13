import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../model/provider.dart';
import '../../utils.dart';
import '../constants.dart';

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
    Provider.of<Model>(context, listen: false).Quotecontroller.text = quote;
    Provider.of<Model>(context, listen: false).Authorcontroller.text = author;
    Size size = MediaQuery.of(context).size;
    return SafeArea(
        child: Align(
      alignment: Alignment.center,
      child: Builder(builder: (context) {
        return Material(
          color: Colors.transparent,
          child: Container(
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(color: Colors.black, blurRadius: size.height)
              ],
              color: kCardColor,
              borderRadius: const BorderRadius.all(Radius.circular(20)),
            ),
            height: size.height * 0.5,
            width: size.width * 0.8,
            padding: const EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 10,
            ),
            child: Column(
              children: [
                TextField(
                  controller: Provider.of<Model>(context, listen: false)
                      .Quotecontroller,
                  cursorColor: Colors.white70,
                  style: const TextStyle(fontSize: 21, fontFamily: "Kanit"),
                  cursorHeight: 22,
                  maxLines: 5,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.all(20),
                  ),
                ),
                const Divider(
                  color: Color.fromARGB(179, 214, 202, 202),
                  thickness: 0.6,
                ),
                TextField(
                  controller: Provider.of<Model>(context, listen: false)
                      .Authorcontroller,
                  cursorColor: Colors.white70,
                  cursorHeight: 19,
                  // maxLines: 2,
                  style: const TextStyle(fontSize: 20, fontFamily: "Rajdhani"),
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.all(10),
                  ),
                ),
                Expanded(child: Container()),
                InkWell(
                    onTap: () {
                      //update quote
                      Provider.of<Model>(context, listen: false)
                          .updateQuote(quoteObj);
                      //Clear controllers
                      Provider.of<Model>(context, listen: false)
                          .Quotecontroller
                          .clear();

                      Provider.of<Model>(context, listen: false)
                          .Authorcontroller
                          .clear();

                      Navigator.pop(context);
                    },
                    child: const Icon(
                        color: Colors.white70, size: 28, Icons.done)),
              ],
            ),
          ),
        );
      }),
    ));
  }
}

import 'package:flutter/material.dart';
//for copy

import '../../utils.dart';
import '../constants.dart';
import 'add_button.dart';
import 'edit_pop_up.dart';

class QuoteTile extends StatelessWidget {
  QuoteTile(
      {required this.quote,
      required this.quoteObj,
      required this.author,
      required this.delete,
      required this.copy,
      required this.favorites,
      required this.favIcon,
      // required this.share,
      super.key});

  String quote;
  String author;
  Quote quoteObj;
  void Function()? delete;
  void Function()? favorites;
  void Function()? copy;
  Icon favIcon;

  // OverlayEntry? overlayEntry;

  // void createEditOverlay(Size size, BuildContext context, Quote quoteObj) {
  //   //remove prev overlay
  //   Provider.of<Model>(context, listen: false).removeEditOverlay();

  //   Provider.of<Model>(context, listen: false).Quotecontroller.text = quote;
  //   Provider.of<Model>(context, listen: false).Authorcontroller.text = author;

  //   //create overlay
  //   Provider.of<Model>(context, listen: false).overlayEntry = OverlayEntry(
  //     builder: (context) {
  //       return SafeArea(
  //           child: Align(
  //         alignment: Alignment.center,
  //         child: Material(
  //           color: Colors.transparent,
  //           child: Container(
  //             decoration: BoxDecoration(
  //               boxShadow: [
  //                 BoxShadow(color: Colors.black, blurRadius: size.height)
  //               ],
  //               color: kCardColor,
  //               borderRadius: const BorderRadius.all(Radius.circular(20)),
  //             ),
  //             height: size.height * 0.5,
  //             width: size.width * 0.8,
  //             padding: const EdgeInsets.symmetric(
  //               horizontal: 10,
  //               vertical: 10,
  //             ),
  //             child: Column(
  //               children: [
  //                 TextField(
  //                   controller: Provider.of<Model>(context, listen: false)
  //                       .Quotecontroller,
  //                   cursorColor: Colors.white70,
  //                   style: const TextStyle(fontSize: 21, fontFamily: "Kanit"),
  //                   cursorHeight: 22,
  //                   maxLines: 5,
  //                   decoration: const InputDecoration(
  //                     border: InputBorder.none,
  //                     contentPadding: EdgeInsets.all(20),
  //                   ),
  //                 ),
  //                 const Divider(
  //                   color: Color.fromARGB(179, 214, 202, 202),
  //                   thickness: 0.6,
  //                 ),
  //                 TextField(
  //                   controller: Provider.of<Model>(context, listen: false)
  //                       .Authorcontroller,
  //                   cursorColor: Colors.white70,
  //                   cursorHeight: 19,
  //                   // maxLines: 2,
  //                   style:
  //                       const TextStyle(fontSize: 20, fontFamily: "Rajdhani"),
  //                   decoration: const InputDecoration(
  //                     border: InputBorder.none,
  //                     contentPadding: EdgeInsets.all(10),
  //                   ),
  //                 ),
  //                 Expanded(child: Container()),
  //                 IconButton(
  //                     color: Colors.white70,
  //                     onPressed: () {
  //                       //remove overlay
  //                       Provider.of<Model>(context, listen: false)
  //                           .removeEditOverlay();
  //                       //update quote
  //                       Provider.of<Model>(context, listen: false)
  //                           .updateQuote(quoteObj);
  //                       //Clear controllers
  //                       Provider.of<Model>(context, listen: false)
  //                           .Quotecontroller
  //                           .clear();

  //                       Provider.of<Model>(context, listen: false)
  //                           .Authorcontroller
  //                           .clear();
  //                     },
  //                     icon: const Icon(Icons.done)),
  //               ],
  //             ),
  //           ),
  //         ),
  //       ));
  //     },
  //   );
  //   //insert overlay
  //   Overlay.of(context)
  //       .insert(Provider.of<Model>(context, listen: false).overlayEntry!);
  // }

  // void removeEditOverlay() {
  //   overlayEntry?.remove();
  //   overlayEntry = null;
  // }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Builder(
      builder: (context) {
        return Material(
          color: Colors.transparent,
          child: GestureDetector(
            onDoubleTap: (){
              Navigator.of(context).push(HeroDialogRoute(builder: (context) {
          return EditPopUpCard(
              author: quoteObj.author,
              quote: quoteObj.quote,
              quoteObj: quoteObj);
        }));
            },
            child: Container(
              margin: const EdgeInsets.all(10),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                  color: kCardColor,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: const [
                    BoxShadow(
                        blurRadius: 5,
                        color: Colors.transparent,
                        offset: Offset(10, 10))
                  ]),
              child: Column(children: [
                Text(
                  quote,
                  style: const TextStyle(
                      fontSize: 21,
                      fontWeight: FontWeight.w100,
                      color: Colors.white,
                      fontFamily: "Kanit"),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Container(
                      child: Row(
                        children: [
                          IconButton(
                              onPressed: delete,
                              icon: const Icon(
                                  color: Colors.white70,
                                  Icons.delete_outline_rounded)),
                          IconButton(
                              onPressed: copy,
                              icon: const Icon(
                                  color: Colors.white70, Icons.copy_rounded)),
                          // IconButton(
                          //     onPressed: share,
                          //     icon: const Icon(
                          //         color: Colors.white70, Icons.share_outlined)),
                          IconButton(onPressed: favorites, icon: favIcon),
                        ],
                      ),
                    ),
                    Expanded(child: Container()),
                    Text(
                      "~ $author",
                      style:
                          const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 20, fontFamily: "Rajdhani" , color: PopupCardColor),
                    ),
                    const SizedBox(
                      width: 20,
                    )
                  ],
                ),
              ]),
            ),
          ),
        );
      }
    );
  }
}

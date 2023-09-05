import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../res/constants.dart';
import '../../view_model/provider.dart';

class AddButton extends StatelessWidget {
  const AddButton({super.key, required this.onPressed});
  final Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          Navigator.of(context).push(HeroDialogRoute(builder: (context) {
            return _AddTodoPopupCard(onPressed);
          }));
        },
        child: Hero(
            tag: "add-pop-up-tag",
            child: Material(
              color: PopupCardColor,
              elevation: 2,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(32)),
              child: const Padding(
                padding: EdgeInsets.all(10),
                child: Icon(
                  Icons.add,
                  size: 40,
                ),
              ),
            )));
  }
}

class _AddTodoPopupCard extends StatelessWidget {
  /// {@macro add_todo_popup_card}
  _AddTodoPopupCard(
    this.onPressed,
  );
  final Function() onPressed;

  Map<String, dynamic> map = {
    "id": "",
    "collectionId": "",
    "author": "",
    "quote": "",
  };
  int id = 4;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Hero(
          tag: "add-pop-up-tag",
          createRectTween: (begin, end) {
            return CustomRectTween(begin: begin, end: end);
          },
          child: Material(
            color: PopupCardColor,
            elevation: 2,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: Provider.of<Model>(context, listen: false)
                          .quoteController,
                      onChanged: (value) {
                        map["quote"] = value;
                      },
                      decoration: const InputDecoration(
                        hintText: 'Write a quote',
                        hintStyle: TextStyle(
                            fontSize: 19,
                            fontWeight: FontWeight.w400,
                            color: Colors.black87),
                        border: InputBorder.none,
                      ),
                      cursorColor: Colors.black,
                      style: const TextStyle(color: Colors.black, fontSize: 21),
                      maxLines: 6,
                    ),
                    const Divider(
                      color: Colors.black,
                      thickness: 0.6,
                    ),
                    TextField(
                      controller: Provider.of<Model>(context, listen: false)
                          .authorController,
                      onChanged: (value) {
                        map["author"] = value;
                      },
                      decoration: const InputDecoration(
                        hintText: 'Author',
                        hintStyle: TextStyle(
                            fontSize: 19,
                            fontWeight: FontWeight.w400,
                            color: Colors.black87),
                        border: InputBorder.none,
                      ),
                      cursorColor: Colors.black,
                      maxLines: 2,
                      style: const TextStyle(color: Colors.black, fontSize: 21),
                    ),
                    const Divider(
                      color: Colors.black,
                      thickness: 0.6,
                    ),
                    TextButton(
                      onPressed: onPressed,
                      child: const Text(
                        'ADD',
                        style: TextStyle(
                            color: Colors.black,
                            fontFamily: "Kanit",
                            fontSize: 21,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class HeroDialogRoute<T> extends PageRoute<T> {
  HeroDialogRoute({
    required WidgetBuilder builder,
    RouteSettings? settings,
    bool fullscreenDialog = false,
  })  : _builder = builder,
        super(settings: settings, fullscreenDialog: fullscreenDialog);

  final WidgetBuilder _builder;

  @override
  bool get opaque => false;

  @override
  bool get barrierDismissible => true;

  @override
  Duration get transitionDuration => const Duration(milliseconds: 300);

  @override
  bool get maintainState => true;

  @override
  Color get barrierColor => Colors.black54;

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    return child;
  }

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    return _builder(context);
  }

  @override
  String get barrierLabel => 'Popup dialog open';
}

class CustomRectTween extends RectTween {
  /// {@macro custom_rect_tween}
  CustomRectTween({
    @required begin,
    @required end,
  }) : super(begin: begin, end: end);

  @override
  Rect lerp(double t) {
    final elasticCurveValue = Curves.easeOut.transform(t);
    return Rect.fromLTRB(
      lerpDouble(begin?.left, end?.left, elasticCurveValue) ?? 0.0,
      lerpDouble(begin?.top, end?.top, elasticCurveValue) ?? 0.0,
      lerpDouble(begin?.right, end?.right, elasticCurveValue) ?? 0.0,
      lerpDouble(begin?.bottom, end?.bottom, elasticCurveValue) ?? 0.0,
    );
  }
}

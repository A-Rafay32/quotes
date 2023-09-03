import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:quotes/model/data/db_author_collection.dart';

import '../../../res/constants.dart';

import '../../../view_model/provider.dart';
import '../author_collection_screen/author_collection_screen.dart';

class CustomDrawer extends StatefulWidget {
  const CustomDrawer({
    super.key,
    required this.size,
  });

  final Size size;

  @override
  State<CustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  @override
  void initState() {
    Provider.of<Model>(context, listen: false).futureC =
        DBAuthorCollection.getAuthorCollection();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
        elevation: 20.0,
        width: widget.size.width * 0.7,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.horizontal(right: Radius.circular(40))),
        backgroundColor: kbackgroundColor,
        child: Consumer<Model>(builder: (context, model, child) {
          return FutureBuilder(
            future: model.futureC,
            builder: (context, snapshot) => Column(
              children: [
                Container(
                    height: 100,
                    width: widget.size.width * 0.7,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 15, vertical: 10),
                    child: Align(
                      alignment: Alignment.bottomLeft,
                      child: Row(
                        children: [
                          SvgPicture.asset("assets/icons/author.svg",
                              height: 35,
                              width: 35,
                              colorFilter: const ColorFilter.mode(
                                  PopupCardColor, BlendMode.srcIn)),
                          const SizedBox(
                            width: 20,
                          ),
                          const Text(
                            "Authors",
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontFamily: "Kanit",
                                fontSize: 24,
                                color: PopupCardColor),
                          ),
                        ],
                      ),
                    )),
                SizedBox(
                  height: widget.size.height * 0.6,
                  width: widget.size.width * 0.7,
                  child: ListView.separated(
                      separatorBuilder: (context, index) => const Divider(
                            thickness: 0.5,
                            indent: 10,
                            endIndent: 10,
                            color: Colors.white70,
                          ),
                      itemCount: snapshot.data?.length ?? 0,
                      itemBuilder: (context, index) => ListTile(
                            trailing: IconButton(
                                onPressed: () => model.delAuthorCollection(
                                    snapshot.data?[index].name ?? ""),
                                // {
                                //first delete all quotes
                                // Provider.of<Model>(context, listen: false)
                                //     .delCollection2(snapshot.data?[index].name);
                                // then collection

                                // },
                                icon: const Icon(
                                    color: Colors.white70,
                                    Icons.delete_outline_rounded)),
                            onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => AuthorCollectionScreen(
                                      collectionName:
                                          snapshot.data?[index].name),
                                )),
                            title: Text(
                              snapshot.data?[index].name ?? "",
                              style: const TextStyle(
                                  fontFamily: "Rajdhani", fontSize: 18),
                            ),
                          )),
                ),
                Expanded(child: Container()),
                Container()
              ],
            ),
          );
        })
        // ]),
        );
  }
}

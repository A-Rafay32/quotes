import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quotes/res/constants.dart';
import 'package:quotes/view/screens/fav_screen/favourites.dart';
import 'package:quotes/view/screens/main_screen/scaffold_body.dart';
import 'package:quotes/view/screens/user_collection_screen/your_collection.dart';
import 'package:quotes/view/widgets/add_button.dart';

import '../../../model/models.dart';

import '../../../view_model/provider.dart';
import 'drawer.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  Future<List<Quote>>? futureQ;
  Future<List<AuthorCollection>>? futureC;

  @override
  void initState() {
    Provider.of<Model>(context, listen: false).init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: kbackgroundColor,
        // leading: SvgPicture.asset(
        //   "assets/icons/menu.svg",
        //   height: 20,
        //   width: 20,
        //   colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
        // ),
        elevation: 0,
        title: const Text(
          "Quotes",
          style: TextStyle(fontFamily: "Ramaraja", fontSize: 38),
        ),
      ),
      drawer: CustomDrawer(size: size),
      body: const ScaffoldBody(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton:
          // FloatingActionButton(onPressed: (){},),

          AddButton(
              onPressed: () =>
                  Provider.of<Model>(context, listen: false).addQuote()),
      bottomNavigationBar: BottomAppBar(
        padding: EdgeInsets.symmetric(horizontal: size.width * 0.18),
        height: size.height * 0.08,
        shape: const CircularNotchedRectangle(),
        notchMargin: 10,
        elevation: 30.0,
        color: kCardColor,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
                color: IconColor,
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const FavoritesScreen(),
                      ));
                },
                icon: const Icon(Icons.favorite_outline)),
            IconButton(
                color: IconColor,
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const YourCollectionScreen(),
                      ));
                },
                icon: const Icon(Icons.format_quote_sharp)),
          ],
        ),
      ),
    );
  }
}

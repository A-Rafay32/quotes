import "package:flutter/material.dart";
import "package:provider/provider.dart";

import 'package:quotes/model/helper/db_helper_quotes.dart';
import 'package:quotes/view_model/collection_view_model/author_collection.dart';
import 'package:quotes/view_model/collection_view_model/user_collection.dart';
import 'package:quotes/view_model/fav_view_model.dart';
import 'package:quotes/view_model/quotes_view_model.dart';
import 'package:quotes/res/constants.dart';
import 'package:quotes/view/screens/main_screen/main_screen.dart';
import "package:sqflite_common_ffi/sqflite_ffi.dart";

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // for linux
  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;
  // databaseFactory.deleteDatabase(
  //     "/home/a-rafay/Documents/flutter/quotes/.dart_tool/sqflite_common_ffi/databases/quote.db");
  // DBHelper.testDB();
  // DBHelper.testRI();
  // await DBHelper.clearDB();
  // await Model().start();
  await DBHelperQuotes.openDB();
  runApp(const app());
}

class app extends StatelessWidget {
  const app({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (context) => QuotesViewModel(),
          ),
          ChangeNotifierProvider(
            create: (context) => FavoriteViewModel(),
          ),
          ChangeNotifierProvider(
            create: (context) => AuthorCollectionViewModel(),
          ),
          ChangeNotifierProvider(
            create: (context) => UserCollectionViewModel(),
          ),
          // Provider<AuthorCollectionViewModel>(
          //   create: (context) => AuthorCollectionViewModel(),
          // ),
          // Provider<FavoriteViewModel>(
          //   create: (context) => FavoriteViewModel(),
          // ),
          // Provider<UserCollectionViewModel>(
          //   create: (context) => UserCollectionViewModel(),
          // ),
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
              colorScheme: ColorScheme.fromSwatch(
                accentColor: kbackgroundColor,
              ),
              textTheme: Theme.of(context)
                  .textTheme
                  .apply(bodyColor: Colors.white, displayColor: Colors.white),
              scaffoldBackgroundColor: kbackgroundColor),

          home: const MainScreen(),
          // Scaffold(),
          //
        ));
  }
}

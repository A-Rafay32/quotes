import "package:flutter/material.dart";
import "package:provider/provider.dart";
import 'package:quotes/model/data/db_quotes.dart';
import 'package:quotes/view_model/provider.dart';
import 'package:quotes/res/constants.dart';
import 'package:quotes/view/screens/main_screen/main_screen.dart';
import 'package:flutter/services.dart';
import 'package:sqflite/sqflite.dart';
import "package:path/path.dart";
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitDown,
    DeviceOrientation.portraitUp,
  ]);

  // for linux
  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;
  // databaseFactory.deleteDatabase(
  //     "/home/a-rafay/Documents/flutter/quotes/.dart_tool/sqflite_common_ffi/databases/quote.db");
  // var databasepath = await getDatabasesPath();
  // String path = join(databasepath, "quote.db");
  // databaseFactory.deleteDatabase(path);

  await DBQuotes.openDB();
  runApp(const app());
}

class app extends StatelessWidget {
  const app({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => Model(),
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
        ));
  }
}

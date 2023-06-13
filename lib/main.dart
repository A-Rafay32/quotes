import "package:flutter/material.dart";
import "package:provider/provider.dart";
import "package:quotes/database.dart";
import "package:quotes/model/provider.dart";
import "package:quotes/view/constants.dart";
import "package:quotes/view/main_screen.dart";
import "package:sqflite_common_ffi/sqflite_ffi.dart";

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // for linux
  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;
  databaseFactory.deleteDatabase(
      "/home/a-rafay/Documents/flutter/quotes/.dart_tool/sqflite_common_ffi/databases/quote.db");
  // DBHelper.testDB();
  // DBHelper.testRI();
  // await DBHelper.clearDB();
  await Model().start();
  await DBHelper.openDB();
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
          // Scaffold(),
          //
        ));
  }
}

import 'package:shared_preferences/shared_preferences.dart';

const recentlyDelKey = "RECENTLY_DEL_KEY";

void setTimer() async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  pref.setString(recentlyDelKey, DateTime.now().toIso8601String());
}

Future<DateTime> getTimer() async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  String? time = await pref.getString(recentlyDelKey);
  return DateTime.parse(time??"");
}

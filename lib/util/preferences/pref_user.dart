import 'package:shared_preferences/shared_preferences.dart';

class UserPreferences {
  static late SharedPreferences _prefs;

  static Future init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  String get lastPage {
    return _prefs.getString('lastPage') ?? '/';
  }

  set lastPage(String value) {
    _prefs.setString('lastPage', value);
  }
}

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
  String? get role => _prefs.getString('role');
  set role(String? value) {
    if (value != null) {
      _prefs.setString('role', value);
    } else {
      _prefs.remove('role');
    }
  }
}

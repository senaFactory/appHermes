import 'package:shared_preferences/shared_preferences.dart';

class UserPreferences {
  static late SharedPreferences _prefs;
  static final UserPreferences _instance = UserPreferences._internal();

  factory UserPreferences() {
    return _instance;
  }

  UserPreferences._internal();

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  String get lastPage => _prefs.getString('lastPage') ?? '/';
  set lastPage(String value) => _prefs.setString('lastPage', value);

  String? get role => _prefs.getString('role');
  set role(String? value) {
    if (value == null) {
      _prefs.remove('role');
    } else {
      _prefs.setString('role', value);
    }
  }

  bool get isDarkMode => _prefs.getBool('isDarkMode') ?? false;
  set isDarkMode(bool value) => _prefs.setBool('isDarkMode', value);
}

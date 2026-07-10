import 'package:shared_preferences/shared_preferences.dart';

class PreferencesService {
  static const _keyCurrentMl = 'current_ml';

  Future<int?> getCurrentMl() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_keyCurrentMl);
  }

  Future<void> setCurrentMl(int value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_keyCurrentMl, value);
  }
}


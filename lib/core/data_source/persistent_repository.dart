import 'package:shared_preferences/shared_preferences.dart';

import '../../core/services/interfaces/i_persistent_repository.dart';

class PersistentRepository implements IPersistentRepository {
  @override
  Future<int?> getInt(String s) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(s);
  }

  @override
  Future<void> setInt(String s, int value) async {
    var prefs = await SharedPreferences.getInstance();
    await prefs.setInt(s, value);
  }

  @override
  Future<String?> getString(String s) async {
    var prefs = await SharedPreferences.getInstance();
    return prefs.getString(s);
  }

  @override
  Future<void> setString(String s, String value) async {
    var prefs = await SharedPreferences.getInstance();
    await prefs.setString(s, value);
  }

  @override
  Future<bool?> getBool(String s) async {
    var prefs = await SharedPreferences.getInstance();
    return prefs.getBool(s);
  }

  @override
  Future<void> setBool(String s, bool value) async {
    var prefs = await SharedPreferences.getInstance();
    await prefs.setBool(s, value);
  }
}

import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Wraps SharedPreferences reads/writes with typed helpers.
@lazySingleton
class SharedPreferencesDataSource {
  final SharedPreferences _prefs;

  SharedPreferencesDataSource(this._prefs);

  Future<void> setString(String key, String value) async =>
      _prefs.setString(key, value);

  String? getString(String key) => _prefs.getString(key);

  Future<void> setBool(String key, bool value) async =>
      _prefs.setBool(key, value);

  bool? getBool(String key) => _prefs.getBool(key);

  Future<void> remove(String key) async => _prefs.remove(key);

  bool containsKey(String key) => _prefs.containsKey(key);
}

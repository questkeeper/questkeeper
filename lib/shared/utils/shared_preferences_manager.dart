import 'package:shared_preferences/shared_preferences.dart';

/// A class to manage SharedPreferences and create a single shared instance for the full app
/// This class follows the Singleton pattern to ensure only one instance exists
class SharedPreferencesManager {
  // Private constructor to prevent external instantiation
  SharedPreferencesManager._privateConstructor();

  // Single instance of SharedPreferencesManager
  static final SharedPreferencesManager _instance =
      SharedPreferencesManager._privateConstructor();

  // Getter to access the singleton instance
  static SharedPreferencesManager get instance => _instance;

  // Instance of SharedPreferences
  SharedPreferences? _prefs;

  /// Initializes SharedPreferences instance
  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  /// Gets a string value from SharedPreferences
  /// Returns null if the key doesn't exist
  String? getString(String key) => _prefs?.getString(key);

  /// Saves a string value to SharedPreferences
  Future<void> setString(String key, String value) async =>
      await _prefs?.setString(key, value);

  /// Saves a list of strings to SharedPreferences
  Future<void> setStringList(String key, List<String> value) async =>
      await _prefs?.setStringList(key, value);

  /// Gets a list of strings from SharedPreferences
  /// Returns null if the key doesn't exist
  List<String>? getStringList(String key) => _prefs?.getStringList(key);

  /// Saves an integer value to SharedPreferences
  Future<void> setInt(String key, int value) async =>
      await _prefs?.setInt(key, value);

  /// Gets an integer value from SharedPreferences
  /// Returns null if the key doesn't exist
  int? getInt(String key) => _prefs?.getInt(key);

  /// Saves a double value to SharedPreferences
  Future<void> setDouble(String key, double value) async =>
      await _prefs?.setDouble(key, value);

  /// Gets a double value from SharedPreferences
  /// Returns null if the key doesn't exist
  double? getDouble(String key) => _prefs?.getDouble(key);

  /// Saves a boolean value to SharedPreferences
  Future<void> setBool(String key, bool value) async =>
      await _prefs?.setBool(key, value);

  /// Gets a boolean value from SharedPreferences
  /// Returns null if the key doesn't exist
  bool? getBool(String key) => _prefs?.getBool(key);
}

import 'dart:convert';
import 'dart:ffi';
import 'package:shared_preferences/shared_preferences.dart';

class Preferences {
  static SharedPreferences? _preferences;

  // Keys for SharedPreferences
  static const String keyUsername = 'username';
  static const String keyBirthday = 'birthday';
  static const String keyHeight = 'height';
  static const String keyWeight = 'weight';
  static const String keyGender = 'gender';
  static const String keyInjuryStatus = 'injuryStatus';
  static const String keyInjuries = 'injuries';
  static const String jwtSecret = '';
  static const String userId = '';
  static const String keyCompletedExercises = 'completedExercises';

  static Future<void> init() async {
    _preferences ??= await SharedPreferences.getInstance();
  }

  // Username methods
  static Future<bool> setUsername(String username) async {
    try {
      if (_preferences == null) await init();
      return await _preferences?.setString(keyUsername, username) ?? false;
    } catch (e) {
      print("Error saving username: $e");
      return false;
    }
  }

  static String? getUsername() {
    try {
      return _preferences?.getString(keyUsername);
    } catch (e) {
      print("Error getting username: $e");
      return null;
    }
  }

  // Birthday methods
  static Future<bool> setBirthday(DateTime birthday) async {
    try {
      if (_preferences == null) await init();
      return await _preferences?.setString(
              keyBirthday, birthday.toIso8601String()) ??
          false;
    } catch (e) {
      print("Error saving birthday: $e");
      return false;
    }
  }

  static DateTime? getBirthday() {
    try {
      final birthdayStr = _preferences?.getString(keyBirthday);
      return birthdayStr != null ? DateTime.tryParse(birthdayStr) : null;
    } catch (e) {
      print("Error getting birthday: $e");
      return null;
    }
  }

  // Height methods
  static Future<bool> setHeight(int height) async {
    try {
      if (_preferences == null) await init();
      return await _preferences?.setInt(keyHeight, height) ?? false;
    } catch (e) {
      print("Error saving height: $e");
      return false;
    }
  }

  static int? getHeight() {
    try {
      return _preferences?.getInt(keyHeight);
    } catch (e) {
      print("Error getting height: $e");
      return null;
    }
  }

  // Weight methods
  static Future<bool> setWeight(int weight) async {
    try {
      if (_preferences == null) await init();
      return await _preferences?.setInt(keyWeight, weight) ?? false;
    } catch (e) {
      print("Error saving weight: $e");
      return false;
    }
  }

  static int? getWeight() {
    try {
      return _preferences?.getInt(keyWeight);
    } catch (e) {
      print("Error getting weight: $e");
      return null;
    }
  }

  // Gender methods
  static Future<bool> setGender(bool gender) async {
    try {
      if (_preferences == null) await init();
      return await _preferences?.setBool(keyGender, gender) ?? false;
    } catch (e) {
      print("Error saving gender: $e");
      return false;
    }
  }

  static bool? getGender() {
    try {
      return _preferences?.getBool(keyGender);
    } catch (e) {
      print("Error getting gender: $e");
      return null;
    }
  }

  // Injury Status methods
  static Future<bool> setInjuryStatus(int status) async {
    try {
      if (_preferences == null) await init();
      return await _preferences?.setInt(keyInjuryStatus, status) ?? false;
    } catch (e) {
      print("Error saving injury status: $e");
      return false;
    }
  }

  static int? getInjuryStatus() {
    try {
      return _preferences?.getInt(keyInjuryStatus);
    } catch (e) {
      print("Error getting injury status: $e");
      return null;
    }
  }

  // Injuries methods
  static Future<bool> setInjuries(List<String> injuries) async {
    try {
      if (_preferences == null) await init();
      return await _preferences?.setStringList(keyInjuries, injuries) ?? false;
    } catch (e) {
      print("Error saving injuries: $e");
      return false;
    }
  }

  static List<String>? getInjuries() {
    try {
      return _preferences?.getStringList(keyInjuries);
    } catch (e) {
      print("Error getting injuries: $e");
      return null;
    }
  }

  static Future<bool> setJwtSecret(String jwt) async {
    try {
      if (_preferences == null) await init();
      return await _preferences?.setString(jwtSecret, jwt) ?? false;
    } catch (e) {
      print("Error saving jwt: $e");
      return false;
    }
  }

  static String? getJwtSecret() {
    try {
      return _preferences?.getString(jwtSecret);
    } catch (e) {
      print("Error getting jwt: $e");
      return null;
    }
  }

  static Future<bool> setUserId(String _id) async {
    try {
      if (_preferences == null) await init();
      return await _preferences?.setString(userId, _id) ?? false;
    } catch (e) {
      print("Error saving jwt: $e");
      return false;
    }
  }

  static String? getUserid() {
    try {
      return _preferences?.getString(userId);
    } catch (e) {
      print("Error getting jwt: $e");
      return null;
    }
  }

  // Get all user information in one call
  static Map<String, dynamic> getUserInfo() {
    try {
      return {
        'username': getUsername(),
        'birthday': getBirthday(),
        'height': getHeight(),
        'weight': getWeight(),
        'gender': getGender(),
        'injuryStatus': getInjuryStatus(),
        'injuries': getInjuries(),
      };
    } catch (e) {
      print("Error getting user info: $e");
      return {};
    }
  }

  // Save all user information in one call
  static Future<bool> setUserInfo({
    required String username,
    required DateTime birthday,
    required int height,
    required int weight,
    required bool gender,
    required int injuryStatus,
    required List<String> injuries,
  }) async {
    try {
      if (_preferences == null) await init();

      final results = await Future.wait([
        setUsername(username),
        setBirthday(birthday),
        setHeight(height),
        setWeight(weight),
        setGender(gender),
        setInjuryStatus(injuryStatus),
        setInjuries(injuries),
      ]);

      return !results.contains(false);
    } catch (e) {
      print("Error saving user info: $e");
      return false;
    }
  }

  // Remove specific field
  static Future<bool> removeField(String key) async {
    try {
      if (_preferences == null) await init();
      return await _preferences?.remove(key) ?? false;
    } catch (e) {
      print("Error removing field: $e");
      return false;
    }
  }

  static Future<bool> clearPreferences() async {
    try {
      if (_preferences == null) await init();
      return await _preferences?.clear() ?? false;
    } catch (e) {
      print("Error clearing preferences: $e");
      return false;
    }
  }

  static Future<bool> saveCompletedExercises(List<String> completedExercises) async {
    try {
      if (_preferences == null) await init();
      return await _preferences?.setStringList(keyCompletedExercises, completedExercises) ?? false;
    } catch (e) {
      print("Error saving completed exercises: $e");
      return false;
    }
  }

  // Method to get completed exercises
  static List<String>? getCompletedExercises() {
    try {
      return _preferences?.getStringList(keyCompletedExercises);
    } catch (e) {
      print("Error getting completed exercises: $e");
      return null;
    }
  }

  // Method to add a single completed exercise
  static Future<bool> addCompletedExercise(String exerciseName) async {
    try {
      if (_preferences == null) await init();

      // Get existing completed exercises
      List<String> completedExercises = getCompletedExercises() ?? [];

      // Add new exercise if not already completed
      if (!completedExercises.contains(exerciseName)) {
        completedExercises.add(exerciseName);
      }

      // Save updated list
      return await _preferences?.setStringList(keyCompletedExercises, completedExercises) ?? false;
    } catch (e) {
      print("Error adding completed exercise: $e");
      return false;
    }
  }
}

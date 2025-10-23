import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';

class UserManager {
  static const String _usersKey = 'users';

  /// Tambah user baru
  static Future<void> addUser(User user) async {
    final prefs = await SharedPreferences.getInstance();
    // Ambil list user dari SharedPreferences
    List<String> users = prefs.getStringList(_usersKey) ?? [];

    // Cek username unik
    final exists = users.any((u) {
      final existingUser = User.fromJson(jsonDecode(u));
      return existingUser.username == user.username;
    });
    if (exists) {
      throw Exception("Username sudah terdaftar");
    }

    // Tambah user baru
    users.add(jsonEncode(user.toJson()));
    await prefs.setStringList(_usersKey, users);
  }

  /// Login user
  static Future<User?> login(String username, String password) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> users = prefs.getStringList(_usersKey) ?? [];

    for (var userString in users) {
      final user = User.fromJson(jsonDecode(userString));
      if (user.username == username && user.password == password) {
        return user;
      }
    }

    return null; // username/password salah
  }

  /// Ambil semua user (opsional, misal untuk admin)
  static Future<List<User>> getAllUsers() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> users = prefs.getStringList(_usersKey) ?? [];
    return users.map((u) => User.fromJson(jsonDecode(u))).toList();
  }

  /// Hapus semua user (debug/testing)
  static Future<void> clearUsers() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_usersKey);
  }
}
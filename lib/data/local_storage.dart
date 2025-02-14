import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import '../models/user_model.dart';
import 'api_service.dart';

class LocalStorage {
  static const String userBoxName = "users";

  // Save user to local storage (Hive)
  static Future<void> saveUser(User user) async {
    final box = await Hive.openBox<User>(userBoxName);
    await box.put(user.id, user);
  }

  // Retrieve all offline users
  static Future<List<User>> getOfflineUsers() async {
    final box = await Hive.openBox<User>(userBoxName);
    return box.values.toList();
  }

  // Clear all stored users (for debugging or reset)
  static Future<void> clearUsers() async {
    final box = await Hive.openBox<User>(userBoxName);
    await box.clear();
  }

  // **✅ Fix: Add syncOfflineUsers method**
  static Future<void> syncOfflineUsers() async {
    final box = await Hive.openBox<User>(userBoxName);
    final List<User> offlineUsers = box.values.toList();

    if (offlineUsers.isEmpty) return; // Nothing to sync

    final ApiService apiService = ApiService(); // Create API service instance

    for (User user in offlineUsers) {
      try {
        await apiService.addUser(user.firstName, "N/A"); // Sync to API
        await box.delete(user.id); // Remove from local storage after successful sync
        if (kDebugMode) {
          print("Synced user: ${user.firstName}");
        } // Debug log
      } catch (e) {
        if (kDebugMode) {
          print("Failed to sync user ${user.firstName}: $e");
        } // Debug error log
      }
    }
  }
}

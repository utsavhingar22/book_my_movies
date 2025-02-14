import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import '../models/user_model.dart';
import '../providers/user_provider.dart';

class UserNotifier extends StateNotifier<AsyncValue<List<User>>> {
  UserNotifier(this.ref) : super(const AsyncValue.loading()) {
    fetchUsers();
  }

  final Ref ref;
  final Dio _dio = Dio();
  final List<User> _users = [];
  final Box<User> _userBox = Hive.box('users'); // Hive storage

  Future<void> fetchUsers() async {
    try {
      final page = ref.read(userPageProvider);
      final response = await _dio.get('https://reqres.in/api/users?page=$page');
      final newUsers = (response.data['data'] as List).map((user) => User.fromJson(user)).toList();

      _users.addAll(newUsers);
      state = AsyncValue.data(_users);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  Future<void> addUser(String name, String job) async {
    final user = User(id: DateTime.now().millisecondsSinceEpoch, firstName: name, lastName: job, avatar: "");
    final connectivity = await Connectivity().checkConnectivity();

    if (connectivity == ConnectivityResult.none) {
      _userBox.put(user.id, user); // Store offline
    } else {
      try {
        final response = await _dio.post('https://reqres.in/api/users', data: {'name': name, 'job': job});
        final newUser = User.fromJson(response.data);
        _users.add(newUser);
        state = AsyncValue.data(_users);
      } catch (e) {
        _userBox.put(user.id, user); // Store if API fails
      }
    }
  }

  Future<void> syncOfflineUsers() async {
    final offlineUsers = _userBox.values.toList();
    for (var user in offlineUsers) {
      try {
        final response = await _dio.post('https://reqres.in/api/users', data: {'name': user.firstName, 'job': user.lastName});
        final newUser = User.fromJson(response.data);
        _users.add(newUser);
        _userBox.delete(user.id); // Remove from offline storage after sync
      } catch (e) {
        if (kDebugMode) {
          print("Failed to sync user: ${user.firstName}");
        }
      }
    }
    state = AsyncValue.data(_users);
  }
}

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import '../models/user_model.dart';

// Track current page
final userPageProvider = StateProvider<int>((ref) => 1);

final userNotifierProvider = StateNotifierProvider<UserNotifier, AsyncValue<List<User>>>(
      (ref) => UserNotifier(ref),
);

class UserNotifier extends StateNotifier<AsyncValue<List<User>>> {
  UserNotifier(this.ref) : super(const AsyncValue.loading()) {
    fetchUsers();
  }

  final Ref ref;
  final Dio _dio = Dio();
  final List<User> _users = [];

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
    try {
      final response = await _dio.post(
        'https://reqres.in/api/users',
        data: {'name': name, 'job': job},
      );

      final newUser = User.fromJson(response.data);
      _users.add(newUser);
      state = AsyncValue.data([..._users]); // Update state with new user
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  void loadNextPage() {
    ref.read(userPageProvider.notifier).state++; // Increase page number
    fetchUsers();
  }
}

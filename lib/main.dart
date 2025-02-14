import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:movies/data/local_storage.dart';
import 'package:movies/screens/add_user_screen.dart';
import 'package:movies/screens/movie_detail_screen.dart';
import 'package:movies/screens/movie_list_screen.dart';
import 'package:movies/screens/user_list_screen.dart';
import 'package:workmanager/workmanager.dart';
import 'package:go_router/go_router.dart';
import 'models/user_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive and register the User adapter
  await Hive.initFlutter();
  Hive.registerAdapter(UserAdapter()); // Register adapter for User model
  await Hive.openBox<User>('users'); // Open a box for User storage

  // Initialize WorkManager
  Workmanager().initialize(callbackDispatcher, isInDebugMode: true);

  // Register periodic sync task (runs every 15 minutes)
  Workmanager().registerPeriodicTask(
    "syncUsers",
    "syncOfflineUsers",
    frequency: const Duration(minutes: 15),
  );

  runApp(const ProviderScope(child: MyApp()));
}

// Background WorkManager callback
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    await LocalStorage.syncOfflineUsers(); // Sync offline users when triggered
    return Future.value(true);
  });
}

// Main App
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      routerConfig: GoRouter(
        routes: [
          GoRoute(path: '/', builder: (context, state) => const UserListScreen()),
          GoRoute(path: '/add-user', builder: (context, state) => const AddUserScreen()),
          GoRoute(path: '/movies', builder: (context, state) => const MovieListScreen()),
          GoRoute(
            path: '/movie-detail/:id',
            builder: (context, state) {
              final idStr = state.pathParameters['id'];
              final movieId = int.tryParse(idStr ?? '') ?? 0;
              return MovieDetailScreen(movieId: movieId);
            },
          ),
        ],
      ),
    );
  }
}

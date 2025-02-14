import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/movie_provider.dart';
import '../widgets/movie_card.dart';

class MovieListScreen extends ConsumerStatefulWidget {
  const MovieListScreen({super.key});

  @override
  ConsumerState<MovieListScreen> createState() => _MovieListScreenState();
}

class _MovieListScreenState extends ConsumerState<MovieListScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    // Initial fetch (you might want to move this elsewhere if needed)
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(movieProvider.notifier).fetchMovies();
    });
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      ref.read(movieProvider.notifier).fetchMovies();
    }
  }

  @override
  Widget build(BuildContext context) {
    final moviesAsync = ref.watch(movieProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Movies')),
      body: moviesAsync.when(
        data: (movies) => ListView.builder(
          controller: _scrollController,
          itemCount: movies.length,
          itemBuilder: (context, index) {
            return MovieCard(movie: movies[index]); // No need for GestureDetector here
          },
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) {
          // Improved error handling
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Error: $err'),
                ElevatedButton(
                  onPressed: () {
                    ref.read(movieProvider.notifier).fetchMovies(); // Retry
                  },
                  child: const Text("Retry"),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
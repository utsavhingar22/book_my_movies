// ignore_for_file: library_private_types_in_public_api
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/movie_provider.dart';
import '../widgets/movie_card.dart';

class MovieListScreen extends ConsumerStatefulWidget {
  const MovieListScreen({super.key});

  @override
  _MovieListScreenState createState() => _MovieListScreenState();
}

class _MovieListScreenState extends ConsumerState<MovieListScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200) {
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
            return GestureDetector(
              onTap: () {
                if (kDebugMode) {
                  print("🔥 Movie Clicked: ${movies[index].title}");
                } // Debugging log
                final movieId = movies[index].id;
                if (kDebugMode) {
                  print('Navigating to: /movie-detail/$movieId');
                } // Debugging log
                context.push('/movie-detail/$movieId');
              },
              child: MovieCard(movie: movies[index]),
            );
          },
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
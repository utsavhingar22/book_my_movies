import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import '../models/movie_model.dart';

final movieProvider = StateNotifierProvider<MovieNotifier, AsyncValue<List<Movie>>>((ref) {
  return MovieNotifier();
});

class MovieNotifier extends StateNotifier<AsyncValue<List<Movie>>> {
  MovieNotifier() : super(const AsyncValue.loading()) {
    fetchMovies();
  }

  final List<Movie> _movies = [];
  int _currentPage = 1;
  bool _hasMore = true;

  Future<void> fetchMovies() async {
    if (!_hasMore) return;

    try {
      final response = await Dio().get(
        'https://api.themoviedb.org/3/trending/movie/day',
        queryParameters: {
          'language': 'en-US',
          'page': _currentPage,
          'api_key': '3aa2c997ec3eb7851fa0e377b062b620',
        },
      );

      final List<dynamic> results = response.data['results'];
      if (results.isEmpty) {
        _hasMore = false;
        return;
      }

      _movies.addAll(results.map((movie) => Movie.fromJson(movie)));
      _currentPage++;

      state = AsyncValue.data(_movies);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }
}

import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/movie_model.dart';
import '../data/api_service.dart';

class MovieDetailScreen extends StatefulWidget {
  final int movieId;
  const MovieDetailScreen({required this.movieId, Key? key}) : super(key: key);

  @override
  State<MovieDetailScreen> createState() => _MovieDetailScreenState();
}

class _MovieDetailScreenState extends State<MovieDetailScreen> {
  late Future<Movie> _movieFuture; // Store the future

  @override
  void initState() {
    super.initState();
    _movieFuture = ApiService().fetchMovieDetails(widget.movieId); // Initialize in initState
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Movie Details'), // Initial title
      ),
      body: Center(
        child: FutureBuilder<Movie>(
          future: _movieFuture, // Use the stored future
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator(); // Show loader while waiting
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error.toString()}'); // Show error
            } else if (!snapshot.hasData || snapshot.data == null) {
              return const Text('No movie data available'); // Handle null data
            }

            final movie = snapshot.data!;
            return _buildMovieContent(movie); // Extract widget for better rebuilds
          },
        ),
      ),
    );
  }

  Widget _buildMovieContent(Movie movie) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: CachedNetworkImage(
              imageUrl: 'http://image.tmdb.org/t/p/w300/${movie.posterPath}',
              fit: BoxFit.cover,
              width: MediaQuery.of(context).size.width * 0.8,
              placeholder: (context, url) => const CircularProgressIndicator(),
              errorWidget: (context, url, error) => const Icon(Icons.error),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            movie.title,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 10),
          Text(
            'Release Date: ${movie.releaseDate}',
            style: const TextStyle(fontSize: 18),
          ),
          const SizedBox(height: 20),
          Text(
            movie.overview,
            style: const TextStyle(fontSize: 16),
            textAlign: TextAlign.justify,
          ),
        ],
      ),
    );
  }
}
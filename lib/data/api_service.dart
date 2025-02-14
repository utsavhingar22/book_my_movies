import 'package:dio/dio.dart';
import '../models/movie_model.dart';

class ApiService {
  final Dio _dio = Dio();

  // Add user
  Future<void> addUser(String name, String job) async {
    await _dio.post('https://reqres.in/api/users', data: {'name': name, 'job': job});
  }

  // Fetch movie details
  Future<Movie> fetchMovieDetails(int movieId) async {
    const apiKey = '3aa2c997ec3eb7851fa0e377b062b620';
    final url = 'https://api.themoviedb.org/3/movie/$movieId?api_key=$apiKey';
    final response = await _dio.get(url);
    return Movie.fromJson(response.data);
  }

}

import 'package:dio/dio.dart';
import '../../core/constants/api_constants.dart';
import '../models/movie.dart';

class MovieRepository {
  final Dio _dio;

  MovieRepository({Dio? dio}) : _dio = dio ?? Dio(
    BaseOptions(
      baseUrl: ApiConstants.baseUrl,
      queryParameters: {
        'api_key': ApiConstants.apiKey,
      },
    )
  );

  Future<List<Movie>> getTrendingMovies() async {
    try {
      final response = await _dio.get(ApiConstants.trendingMovies);
      final List results = response.data['results'];
      return results.map((e) => Movie.fromJson(e)).toList();
    } catch (e) {
      throw Exception('Failed to fetch trending movies: $e');
    }
  }

  Future<List<Movie>> getPopularMovies() async {
    try {
      final response = await _dio.get(ApiConstants.popularMovies);
      final List results = response.data['results'];
      return results.map((e) => Movie.fromJson(e)).toList();
    } catch (e) {
      throw Exception('Failed to fetch popular movies: $e');
    }
  }

  Future<List<Movie>> searchMovies(String query) async {
    try {
      final response = await _dio.get(
        ApiConstants.searchMovies,
        queryParameters: {'query': query},
      );
      final List results = response.data['results'];
      return results.map((e) => Movie.fromJson(e)).toList();
    } catch (e) {
      throw Exception('Failed to search movies: $e');
    }
  }
}

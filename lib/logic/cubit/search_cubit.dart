import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../data/models/movie.dart';
import '../../data/repositories/movie_repository.dart';

part 'search_state.dart';

class SearchCubit extends Cubit<SearchState> {
  final MovieRepository _movieRepository;

  SearchCubit({required MovieRepository movieRepository})
      : _movieRepository = movieRepository,
        super(SearchInitial());

  Future<void> searchMovies(String query) async {
    if (query.isEmpty) {
      emit(SearchInitial());
      return;
    }
    emit(SearchLoading());
    try {
      final results = await _movieRepository.searchMovies(query);
      emit(SearchLoaded(movies: results));
    } catch (e) {
      emit(SearchError(message: e.toString()));
    }
  }
}

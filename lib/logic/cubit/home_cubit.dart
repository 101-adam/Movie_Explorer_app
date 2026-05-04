import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../data/models/movie.dart';
import '../../data/repositories/movie_repository.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final MovieRepository _movieRepository;

  HomeCubit({required MovieRepository movieRepository})
      : _movieRepository = movieRepository,
        super(HomeInitial());

  Future<void> loadHomeData() async {
    emit(HomeLoading());
    try {
      final trending = await _movieRepository.getTrendingMovies();
      final popular = await _movieRepository.getPopularMovies();
      emit(HomeLoaded(trendingMovies: trending, popularMovies: popular));
    } catch (e) {
      emit(HomeError(message: e.toString()));
    }
  }
}

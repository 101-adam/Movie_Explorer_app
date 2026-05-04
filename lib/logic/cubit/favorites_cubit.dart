import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../data/models/movie.dart';
import '../../data/repositories/local_database_repository.dart';

part 'favorites_state.dart';

class FavoritesCubit extends Cubit<FavoritesState> {
  final LocalDatabaseRepository _localDbRepository;

  FavoritesCubit({required LocalDatabaseRepository localDbRepository})
      : _localDbRepository = localDbRepository,
        super(FavoritesInitial());

  Future<void> loadFavorites() async {
    emit(FavoritesLoading());
    try {
      final favorites = await _localDbRepository.getFavorites();
      emit(FavoritesLoaded(favorites: favorites));
    } catch (e) {
      emit(FavoritesError(message: e.toString()));
    }
  }

  Future<void> addFavorite(Movie movie) async {
    try {
      await _localDbRepository.addFavorite(movie);
      loadFavorites(); // Refresh list
    } catch (e) {
      emit(FavoritesError(message: e.toString()));
    }
  }

  Future<void> removeFavorite(int id) async {
    try {
      await _localDbRepository.removeFavorite(id);
      loadFavorites(); // Refresh list
    } catch (e) {
      emit(FavoritesError(message: e.toString()));
    }
  }

  Future<bool> isFavorite(int id) async {
    return await _localDbRepository.isFavorite(id);
  }
}

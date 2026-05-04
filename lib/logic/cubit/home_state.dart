part of 'home_cubit.dart';

abstract class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object> get props => [];
}

class HomeInitial extends HomeState {}

class HomeLoading extends HomeState {}

class HomeLoaded extends HomeState {
  final List<Movie> trendingMovies;
  final List<Movie> popularMovies;

  const HomeLoaded({required this.trendingMovies, required this.popularMovies});

  @override
  List<Object> get props => [trendingMovies, popularMovies];
}

class HomeError extends HomeState {
  final String message;

  const HomeError({required this.message});

  @override
  List<Object> get props => [message];
}

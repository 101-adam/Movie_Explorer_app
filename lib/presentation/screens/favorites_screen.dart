import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../logic/cubit/favorites_cubit.dart';
import '../../core/constants/api_constants.dart';
import 'movie_details_screen.dart';
import '../../core/theme/app_theme.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  final List<String> _filters = ['All Favorites', 'Sci-Fi', 'Action', 'Drama'];
  int _selectedFilterIndex = 0;

  @override
  void initState() {
    super.initState();
    context.read<FavoritesCubit>().loadFavorites();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FavoritesCubit, FavoritesState>(
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Text(
                'My Favorites',
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                'Your curated collection of cinematic masterpieces.',
                style: TextStyle(color: Colors.white70, fontSize: 14),
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              height: 40,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                itemCount: _filters.length,
                itemBuilder: (context, index) {
                  final isSelected = index == _selectedFilterIndex;
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedFilterIndex = index;
                      });
                    },
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 4.0),
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                      decoration: BoxDecoration(
                        color: isSelected ? AppTheme.primaryColor : Colors.transparent,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: isSelected ? AppTheme.primaryColor : Colors.white30,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          _filters[index],
                          style: TextStyle(
                            color: isSelected ? Colors.black : Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: _buildGrid(state),
            ),
          ],
        );
      },
    );
  }

  Widget _buildGrid(FavoritesState state) {
    if (state is FavoritesLoading) {
      return const Center(child: CircularProgressIndicator(color: AppTheme.primaryColor));
    } else if (state is FavoritesLoaded) {
      if (state.favorites.isEmpty) {
        return const Center(child: Text("No favorite movies yet.", style: TextStyle(color: Colors.white70)));
      }
      return GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.65,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
        ),
        itemCount: state.favorites.length,
        itemBuilder: (context, index) {
          final movie = state.favorites[index];
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => MovieDetailsScreen(movie: movie)),
              );
            },
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  if (movie.posterPath != null)
                    CachedNetworkImage(
                      imageUrl: '${ApiConstants.imageBaseUrl}${movie.posterPath}',
                      fit: BoxFit.cover,
                    )
                  else
                    Container(color: AppTheme.surfaceColor, child: const Icon(Icons.movie, size: 50, color: Colors.white54)),
                  
                  Positioned(
                    top: 12,
                    right: 12,
                    child: GestureDetector(
                      onTap: () {
                        context.read<FavoritesCubit>().removeFavorite(movie.id);
                      },
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.5),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.favorite, color: AppTheme.primaryColor, size: 18),
                      ),
                    ),
                  ),

                  Positioned(
                    bottom: 0, left: 0, right: 0,
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                          colors: [Colors.black.withOpacity(0.9), Colors.transparent],
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.7),
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(color: AppTheme.primaryColor.withOpacity(0.5)),
                            ),
                            child: Text(
                              movie.voteAverage.toStringAsFixed(1),
                              style: const TextStyle(color: AppTheme.primaryColor, fontSize: 10, fontWeight: FontWeight.bold),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            movie.title,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${movie.releaseDate.split('-').first} • ${movie.genres.isNotEmpty ? movie.genres.first : 'Unknown'}',
                            style: const TextStyle(color: Colors.white70, fontSize: 12),
                          )
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          );
        },
      );
    } else if (state is FavoritesError) {
      return Center(child: Text(state.message, style: const TextStyle(color: Colors.red)));
    }
    return const SizedBox();
  }
}

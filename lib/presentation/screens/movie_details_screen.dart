import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../data/models/movie.dart';
import '../../logic/cubit/favorites_cubit.dart';
import '../../core/constants/api_constants.dart';
import '../../core/theme/app_theme.dart';

class MovieDetailsScreen extends StatefulWidget {
  final Movie movie;

  const MovieDetailsScreen({super.key, required this.movie});

  @override
  State<MovieDetailsScreen> createState() => _MovieDetailsScreenState();
}

class _MovieDetailsScreenState extends State<MovieDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'MOVIE EXPLORER',
          style: TextStyle(color: AppTheme.primaryColor, fontSize: 16),
        ),
        actions: [
          IconButton(icon: const Icon(Icons.share_outlined), onPressed: () {}),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: size.height * 0.45,
              child: Stack(
                children: [
                  Positioned.fill(
                    bottom: 40,
                    child: widget.movie.backdropPath != null
                        ? CachedNetworkImage(
                            imageUrl:
                                '${ApiConstants.imageOriginalUrl}${widget.movie.backdropPath}',
                            fit: BoxFit.cover,
                          )
                        : Container(color: AppTheme.surfaceColor),
                  ),
                  Positioned.fill(
                    bottom: 40,
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                          colors: [
                            AppTheme.backgroundColor,
                            AppTheme.backgroundColor.withOpacity(0.0),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 24,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: widget.movie.posterPath != null
                          ? CachedNetworkImage(
                              imageUrl:
                                  '${ApiConstants.imageBaseUrl}${widget.movie.posterPath}',
                              width: 120,
                              height: 180,
                              fit: BoxFit.cover,
                            )
                          : Container(
                              width: 120,
                              height: 180,
                              color: AppTheme.surfaceColor,
                            ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: size.width * 0.6,
                    child: Text(
                      widget.movie.title,
                      style: const TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        height: 1.2,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Text(
                        widget.movie.releaseDate.split('-').first,
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Text('•', style: TextStyle(color: Colors.white70)),
                      const SizedBox(width: 8),
                      const Text(
                        '2h 15m',
                        style: TextStyle(color: Colors.white70, fontSize: 12),
                      ), // Mock duration
                      const SizedBox(width: 8),
                      const Text('•', style: TextStyle(color: Colors.white70)),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.5),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: AppTheme.primaryColor.withOpacity(0.5),
                          ),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.star_outline,
                              color: AppTheme.primaryColor,
                              size: 12,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '${widget.movie.voteAverage.toStringAsFixed(1)}/10',
                              style: const TextStyle(
                                color: AppTheme.primaryColor,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: widget.movie.genres
                        .map(
                          (genre) => Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 11,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.white30),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Text(
                              genre,
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.white70,
                              ),
                            ),
                          ),
                        )
                        .toList(),
                  ),

                  const SizedBox(height: 32),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.primaryColor,
                            foregroundColor: Colors.black,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: const EdgeInsets.symmetric(
                              vertical: 12,
                            ), // Good practice to define vertical padding
                          ),
                          // 1. WRAP THE ROW IN A FITTEDBOX
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                Icon(Icons.confirmation_num_outlined, size: 20),
                                SizedBox(
                                  width: 4,
                                ), // 2. Reduced from 8 to 4 to save space
                                Text('Book Tickets'),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.surfaceColor,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                          // 1. WRAP THE ROW IN A FITTEDBOX
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                Icon(Icons.play_circle_outline, size: 20),
                                SizedBox(
                                  width: 4,
                                ), // 2. Reduced from 8 to 4 to save space
                                Text('Play Trailer'),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                  const Text(
                    'Synopsis',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12), 
                  Text(
                    widget.movie.overview,
                    style: const TextStyle(color: Colors.white70, height: 1.6),
                  ),
                  const SizedBox(height: 32),
                  const Text(
                    'Top Cast',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    height: 140,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: widget.movie.topCast.length,
                      itemBuilder: (context, index) {
                        final cast = widget.movie.topCast[index];
                        return Container(
                          width: 100,
                          margin: const EdgeInsets.only(right: 16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: CachedNetworkImage(
                                  imageUrl: cast['image']!,
                                  height: 100,
                                  width: 100,
                                  fit: BoxFit.cover,
                                  placeholder: (context, url) =>
                                      Container(color: AppTheme.surfaceColor),
                                  errorWidget: (context, url, error) =>
                                      Container(
                                        color: AppTheme.surfaceColor,
                                        child: const Icon(Icons.person),
                                      ),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                cast['name']!,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(
                                'as ${cast['role']}',
                                style: const TextStyle(
                                  color: Colors.white54,
                                  fontSize: 10,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 100), // Space for FAB
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: BlocBuilder<FavoritesCubit, FavoritesState>(
        builder: (context, state) {
          bool isFav = false;
          if (state is FavoritesLoaded) {
            isFav = state.favorites.any((m) => m.id == widget.movie.id);
          }
          return FloatingActionButton(
            backgroundColor: AppTheme.primaryColor,
            onPressed: () {
              if (isFav) {
                context.read<FavoritesCubit>().removeFavorite(widget.movie.id);
              } else {
                context.read<FavoritesCubit>().addFavorite(widget.movie);
              }
            },
            child: Icon(
              isFav ? Icons.favorite : Icons.favorite_border,
              color: Colors.black,
            ),
          );
        },
      ),
    );
  }
}

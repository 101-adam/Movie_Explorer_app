import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../logic/cubit/search_cubit.dart';
import '../../core/constants/api_constants.dart';
import 'movie_details_screen.dart';
import '../../core/theme/app_theme.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Clear search on init
    context.read<SearchCubit>().searchMovies('');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _searchController,
          autofocus: true,
          style: const TextStyle(color: Colors.white),
          decoration: const InputDecoration(
            hintText: 'Search movies...',
            border: InputBorder.none,
            enabledBorder: InputBorder.none,
            focusedBorder: InputBorder.none,
            filled: false,
            hintStyle: TextStyle(color: Colors.white54),
          ),
          onChanged: (value) {
            // In a real app, we'd add debouncing here
            context.read<SearchCubit>().searchMovies(value);
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.clear),
            onPressed: () {
              _searchController.clear();
              context.read<SearchCubit>().searchMovies('');
            },
          )
        ],
      ),
      body: BlocBuilder<SearchCubit, SearchState>(
        builder: (context, state) {
          if (state is SearchLoading) {
            return const Center(child: CircularProgressIndicator(color: AppTheme.primaryColor));
          } else if (state is SearchLoaded) {
            if (state.movies.isEmpty && _searchController.text.isNotEmpty) {
              return const Center(child: Text('No results found.'));
            } else if (_searchController.text.isEmpty) {
              return const Center(child: Text('Type to start searching...'));
            }
            return GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.65,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              itemCount: state.movies.length,
              itemBuilder: (context, index) {
                final movie = state.movies[index];
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
                                Row(
                                  children: [
                                    const Icon(Icons.star_outline, color: AppTheme.primaryColor, size: 14),
                                    const SizedBox(width: 4),
                                    Text(
                                      movie.voteAverage.toStringAsFixed(1),
                                      style: const TextStyle(color: AppTheme.primaryColor, fontSize: 12, fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  movie.title,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.white),
                                ),
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
          } else if (state is SearchError) {
            return Center(child: Text(state.message, style: const TextStyle(color: Colors.red)));
          }
          return const Center(child: Text('Type to start searching...'));
        },
      ),
    );
  }
}

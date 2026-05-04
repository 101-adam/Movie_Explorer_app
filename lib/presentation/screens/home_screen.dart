import 'package:firebase_app/presentation/screens/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';
import '../../logic/cubit/home_cubit.dart';
import '../../core/constants/api_constants.dart';
import '../../data/models/movie.dart';
import 'movie_details_screen.dart';
import 'favorites_screen.dart';
import 'search_screen.dart';
import '../../core/theme/app_theme.dart';

class HomeScreen extends StatefulWidget {
  final String email;
  const HomeScreen({super.key, required this.email});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    context.read<HomeCubit>().loadHomeData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const Icon(Icons.movie, color: AppTheme.primaryColor),
        title: const Text('MOVIE EXPLORER'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SearchScreen()),
              ); 
            },
          ),
        ],
      ),
      body: [
        _buildHomeBody(), // 0: شاشة الهوم
        const FavoritesScreen(), // 1: شاشة المفضلة
        FeildText(email: widget.email), // 2: شاشة البروفايل
      ][_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'HOME',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.star_border),
            activeIcon: Icon(Icons.star),
            label: 'FAVORITES',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_2_outlined),
            activeIcon: Icon(Icons.person),
            label: 'profile',
          ),
        ],
      ),
    );
  }

  Widget _buildHomeBody() {
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        if (state is HomeLoading || state is HomeInitial) {
          return const Center(
            child: CircularProgressIndicator(color: AppTheme.primaryColor),
          );
        } else if (state is HomeLoaded) {
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 8.0,
                  ),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const SearchScreen()),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: AppTheme.surfaceColor,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: const [
                          Icon(Icons.search, color: Colors.white54),
                          SizedBox(width: 8),
                          Text(
                            'Search movies, genres, theaters...',
                            style: TextStyle(color: Colors.white54),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                _buildSectionTitle('Trending Now'),
                _buildHorizontalList(state.trendingMovies),
                const SizedBox(height: 24),
                _buildSectionTitle('Popular Movies'),
                _buildHorizontalList(state.popularMovies),
                const SizedBox(height: 24),
              ],
            ),
          );
        } else if (state is HomeError) {
          return Center(
            child: Text(
              state.message,
              style: const TextStyle(color: Colors.red),
            ),
          );
        }
        return const SizedBox();
      },
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const Text(
            'See All',
            style: TextStyle(
              color: AppTheme.primaryColor,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHorizontalList(List<Movie> movies) {
    return SizedBox(
      height: 280,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        itemCount: movies.length,
        itemBuilder: (context, index) {
          final movie = movies[index];
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => MovieDetailsScreen(movie: movie),
                ),
              );
            },
            child: Container(
              width: 160,
              margin: const EdgeInsets.symmetric(horizontal: 4.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: movie.posterPath != null
                              ? CachedNetworkImage(
                                  imageUrl:
                                      '${ApiConstants.imageBaseUrl}${movie.posterPath}',
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                  height: double.infinity,
                                  placeholder: (context, url) =>
                                      Shimmer.fromColors(
                                        baseColor: Colors.grey[900]!,
                                        highlightColor: Colors.grey[800]!,
                                        child: Container(color: Colors.white),
                                      ),
                                  errorWidget: (context, url, error) =>
                                      const Icon(Icons.error),
                                )
                              : Container(
                                  color: AppTheme.surfaceColor,
                                  child: const Center(
                                    child: Icon(
                                      Icons.movie,
                                      color: Colors.white54,
                                    ),
                                  ),
                                ),
                        ),
                        Positioned(
                          bottom: 12,
                          left: 12,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.7),
                              borderRadius: BorderRadius.circular(8),
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
                                  movie.voteAverage.toStringAsFixed(1),
                                  style: const TextStyle(
                                    color: AppTheme.primaryColor,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    movie.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

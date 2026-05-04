class Movie {
  final int id;
  final String title;
  final String overview;
  final String? posterPath;
  final String? backdropPath;
  final double voteAverage;
  final String releaseDate;
  
  // Mock fields to support the UI designs (Genres and Cast)
  final List<String> genres;
  final List<Map<String, String>> topCast;

  Movie({
    required this.id,
    required this.title,
    required this.overview,
    this.posterPath,
    this.backdropPath,
    required this.voteAverage,
    required this.releaseDate,
    this.genres = const ['Sci-Fi', 'Action', 'Thriller'], // Default mock data
    this.topCast = const [
      {'name': 'Elias Vance', 'role': 'Det. Kaelen', 'image': 'https://i.pravatar.cc/150?u=elias'},
      {'name': 'Lyra Nova', 'role': 'Cipher', 'image': 'https://i.pravatar.cc/150?u=lyra'},
    ], // Default mock data
  });

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      overview: json['overview'] ?? '',
      posterPath: json['poster_path'],
      backdropPath: json['backdrop_path'],
      voteAverage: (json['vote_average'] ?? 0).toDouble(),
      releaseDate: json['release_date'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'overview': overview,
      'poster_path': posterPath,
      'backdrop_path': backdropPath,
      'vote_average': voteAverage,
      'release_date': releaseDate,
    };
  }

  factory Movie.fromMap(Map<String, dynamic> map) {
    return Movie(
      id: map['id'],
      title: map['title'],
      overview: map['overview'],
      posterPath: map['poster_path'],
      backdropPath: map['backdrop_path'],
      voteAverage: map['vote_average'],
      releaseDate: map['release_date'],
    );
  }
}

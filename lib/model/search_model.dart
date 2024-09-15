class Movie {
  final int id;
  final String title;
  final String overview;
  final String releaseDate;

  Movie({
    required this.id,
    required this.title,
    required this.overview,
    required this.releaseDate,
  });

  // Factory constructor to create a Movie instance from a map
  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      id: json['id'] ?? 0, // Default to 0 if id is null
      title: json['title'] ?? '', // Default to empty string if title is null
      overview: json['overview'] ?? '', // Default to empty string if overview is null
      releaseDate: json['release_date'] ?? '', // Default to empty string if releaseDate is null
    );
  }

  // Method to convert a Movie instance to a map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'overview': overview,
      'release_date': releaseDate,
    };
  }
}

class MovieSearchResponse {
  final List<Movie> results;
  final int totalPages;
  final int totalResults;

  MovieSearchResponse({
    required this.results,
    required this.totalPages,
    required this.totalResults,
  });

  // Factory constructor to create a MovieSearchResponse instance from a map
  factory MovieSearchResponse.fromJson(Map<String, dynamic> json) {
    return MovieSearchResponse(
      results: (json['results'] as List?)
          ?.map((item) => Movie.fromJson(item as Map<String, dynamic>))
          .toList() ?? [], // Default to an empty list if results is null
      totalPages: json['total_pages'] ?? 0, // Default to 0 if totalPages is null
      totalResults: json['total_results'] ?? 0, // Default to 0 if totalResults is null
    );
  }

  // Method to convert a MovieSearchResponse instance to a map
  Map<String, dynamic> toJson() {
    return {
      'results': results.map((movie) => movie.toJson()).toList(),
      'total_pages': totalPages,
      'total_results': totalResults,
    };
  }
}

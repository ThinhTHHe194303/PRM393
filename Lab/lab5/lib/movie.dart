// Step 2 - Define Data Model
// Movie class with fields required by the lab, plus a Trailer sub-model.

class Trailer {
  final String title;
  final String thumbnailUrl;

  const Trailer({required this.title, required this.thumbnailUrl});
}

class Movie {
  final String id;
  final String title;
  final String posterUrl;
  final String overview;
  final List<String> genres;
  final double rating;
  final List<Trailer> trailers;
  final bool isFavorite;

  const Movie({
    required this.id,
    required this.title,
    required this.posterUrl,
    required this.overview,
    required this.genres,
    required this.rating,
    required this.trailers,
    this.isFavorite = false,
  });

  // Used by the Favorite toggle (optional enhancement) to produce
  // a new Movie with isFavorite flipped, since Movie is immutable.
  Movie copyWith({bool? isFavorite}) {
    return Movie(
      id: id,
      title: title,
      posterUrl: posterUrl,
      overview: overview,
      genres: genres,
      rating: rating,
      trailers: trailers,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }
}
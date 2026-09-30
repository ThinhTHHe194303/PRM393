class Movie {
  final String title;
  final int year;
  final List<String> genres;
  final String posterUrl;
  final double rating;

  const Movie({
    required this.title,
    required this.year,
    required this.genres,
    required this.posterUrl,
    required this.rating,
  });
}

const List<Movie> allMovies = [
  Movie(
    title: 'Inception',
    year: 2010,
    genres: ['Action', 'Drama'],
    posterUrl: 'https://upload.wikimedia.org/wikipedia/vi/1/11/Inception_poster_1.jpg?utm_source=vi.wikipedia.org&utm_campaign=parser&utm_content=thumbnail_unscaled',
    rating: 8.8,
  ),
  Movie(
    title: 'The Dark Knight',
    year: 2008,
    genres: ['Action', 'Drama'],
    posterUrl: 'https://upload.wikimedia.org/wikipedia/en/1/1c/The_Dark_Knight_%282008_film%29.jpg?utm_source=en.wikipedia.org&utm_campaign=parser&utm_content=thumbnail_unscaled',
    rating: 9.0,
  ),
  Movie(
    title: 'The Hangover',
    year: 2009,
    genres: ['Comedy'],
    posterUrl: 'https://upload.wikimedia.org/wikipedia/en/b/b9/Hangoverposter09.jpg?utm_source=en.wikipedia.org&utm_campaign=parser&utm_content=thumbnail_unscaled',
    rating: 7.7,
  ),
  Movie(
    title: 'Interstellar',
    year: 2014,
    genres: ['Drama', 'Sci-Fi'],
    posterUrl: 'https://upload.wikimedia.org/wikipedia/vi/4/46/Interstellar_poster.jpg?utm_source=vi.wikipedia.org&utm_campaign=parser&utm_content=thumbnail_unscaled',
    rating: 8.7,
  ),
  Movie(
    title: 'Avengers',
    year: 2012,
    genres: ['Action', 'Sci-Fi'],
    posterUrl: 'https://upload.wikimedia.org/wikipedia/vi/f/f9/TheAvengers2012Poster.jpg?utm_source=vi.wikipedia.org&utm_campaign=parser&utm_content=thumbnail_unscaled',
    rating: 8.0,
  ),
  Movie(
    title: 'Toy Story',
    year: 1995,
    genres: ['Comedy', 'Animation'],
    posterUrl: 'https://upload.wikimedia.org/wikipedia/en/thumb/1/13/Toy_Story.jpg/960px-Toy_Story.jpg',
    rating: 8.3,
  ),
];

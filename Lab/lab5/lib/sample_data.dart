// Step 2 - Sample static data (no API calls, per lab requirement).

import 'movie.dart';

final List<Movie> sampleMovies = [
  const Movie(
    id: 'm1',
    title: 'Inception',
    posterUrl: 'https://picsum.photos/seed/inception/400/600',
    overview:
    'A skilled thief who steals corporate secrets through dream-sharing '
        'technology is given the inverse task of planting an idea into the '
        'mind of a C.E.O.',
    genres: ['Sci-Fi', 'Thriller', 'Action'],
    rating: 8.8,
    trailers: [
      Trailer(
        title: 'Official Trailer',
        thumbnailUrl: 'https://picsum.photos/seed/inception-t1/300/170',
      ),
      Trailer(
        title: 'Behind the Scenes',
        thumbnailUrl: 'https://picsum.photos/seed/inception-t2/300/170',
      ),
    ],
  ),
  const Movie(
    id: 'm2',
    title: 'Interstellar',
    posterUrl: 'https://picsum.photos/seed/interstellar/400/600',
    overview:
    'A team of explorers travel through a wormhole in space in an '
        'attempt to ensure humanity\'s survival.',
    genres: ['Sci-Fi', 'Drama', 'Adventure'],
    rating: 8.6,
    trailers: [
      Trailer(
        title: 'Official Trailer',
        thumbnailUrl: 'https://picsum.photos/seed/interstellar-t1/300/170',
      ),
    ],
  ),
  const Movie(
    id: 'm3',
    title: 'Dune',
    posterUrl: 'https://picsum.photos/seed/dune/400/600',
    overview:
    'Feature adaptation of Frank Herbert\'s science fiction novel about '
        'the son of a noble family entrusted with the protection of a vital '
        'resource on a hostile desert planet.',
    genres: ['Sci-Fi', 'Adventure'],
    rating: 8.0,
    trailers: [
      Trailer(
        title: 'Official Trailer',
        thumbnailUrl: 'https://picsum.photos/seed/dune-t1/300/170',
      ),
      Trailer(
        title: 'Teaser',
        thumbnailUrl: 'https://picsum.photos/seed/dune-t2/300/170',
      ),
    ],
  ),
];
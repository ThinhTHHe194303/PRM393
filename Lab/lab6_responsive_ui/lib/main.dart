import 'package:flutter/material.dart';

import 'movie.dart';

void main() {
  runApp(const ResponsiveMovieApp());
}

class ResponsiveMovieApp extends StatelessWidget {
  const ResponsiveMovieApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const GenreScreen(),
    );
  }
}

class GenreScreen extends StatefulWidget {
  const GenreScreen({super.key});

  @override
  State<GenreScreen> createState() => _GenreScreenState();
}

class _GenreScreenState extends State<GenreScreen> {
  String searchQuery = '';

  final List<String> genres = [
    'Action',
    'Drama',
    'Comedy',
    'Sci-Fi',
    'Animation',
  ];

  final Set<String> selectedGenres = {};

  String selectedSort = 'A-Z';

  Widget buildMovieCard(Movie movie) {
    return Card(
      child: LayoutBuilder(
        builder: (context, constraints) {
          final posterWidth = constraints.maxWidth < 300 ? 90.0 : 120.0;

          final posterHeight = posterWidth * 1.45;

          return Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              children: [
                Image.network(
                  movie.posterUrl,
                  width: posterWidth,
                  height: posterHeight,
                  fit: BoxFit.cover,
                ),

                const SizedBox(width: 12),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        movie.title,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 8),

                      Text('Year: ${movie.year}'),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    List<Movie> visibleMovies = allMovies.where((movie) {
      final matchesSearch = movie.title.toLowerCase().contains(
        searchQuery.toLowerCase(),
      );

      final matchesGenre =
          selectedGenres.isEmpty ||
          movie.genres.any((genre) => selectedGenres.contains(genre));

      return matchesSearch && matchesGenre;
    }).toList();

    visibleMovies.sort((a, b) {
      switch (selectedSort) {
        case 'A-Z':
          return a.title.compareTo(b.title);

        case 'Z-A':
          return b.title.compareTo(a.title);

        case 'Year':
          return b.year.compareTo(a.year);

        case 'Rating':
          return b.rating.compareTo(a.rating);

        default:
          return 0;
      }
    });

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Find a Movie',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 16),

              // Search Bar - Step 4
              Container(
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: TextField(
                  decoration: const InputDecoration(
                    hintText: 'Search movies...',
                    prefixIcon: Icon(Icons.search),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                  ),
                  onChanged: (value) {
                    setState(() {
                      searchQuery = value;
                    });
                  },
                ),
              ),
              // Genre Chips - Step 5
              const SizedBox(height: 16),

              const Text(
                'Genres',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 8),

              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: genres.map((genre) {
                  final isSelected = selectedGenres.contains(genre);

                  return FilterChip(
                    label: Text(genre),
                    selected: isSelected,
                    onSelected: (selected) {
                      setState(() {
                        if (selected) {
                          selectedGenres.add(genre);
                        } else {
                          selectedGenres.remove(genre);
                        }
                      });
                    },
                  );
                }).toList(),
              ),
              // Sort Bar - Step 6
              const SizedBox(height: 16),

              Row(
                children: [
                  const Text(
                    'Sort:',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(width: 12),

                  DropdownButton<String>(
                    value: selectedSort,
                    items: const [
                      DropdownMenuItem(value: 'A-Z', child: Text('A-Z')),
                      DropdownMenuItem(value: 'Z-A', child: Text('Z-A')),
                      DropdownMenuItem(value: 'Year', child: Text('Year')),
                      DropdownMenuItem(value: 'Rating', child: Text('Rating')),
                    ],
                    onChanged: (value) {
                      if (value == null) return;

                      setState(() {
                        selectedSort = value;
                      });
                    },
                  ),
                ],
              ),
              // Movie List - Step 8
              const SizedBox(height: 16),

              Expanded(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    if (constraints.maxWidth < 800) {
                      return ListView.builder(
                        itemCount: visibleMovies.length,
                        itemBuilder: (context, index) {
                          return buildMovieCard(visibleMovies[index]);
                        },
                      );
                    }

                    return GridView.count(
                      crossAxisCount: 2,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: 2.2,
                      children: visibleMovies.map(buildMovieCard).toList(),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

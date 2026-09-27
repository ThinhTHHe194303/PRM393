// Step 4 - Build Movie Detail Screen
// Composed progressively as 6 sub-steps (see comments below).
// To screenshot each sub-step separately: comment out the widgets
// belonging to later sub-steps inside build(), run, screenshot,
// then uncomment the next one and repeat.

import 'package:flutter/material.dart';
import 'movie.dart';

class MovieDetailScreen extends StatefulWidget {
  final Movie movie;

  const MovieDetailScreen({super.key, required this.movie});

  @override
  State<MovieDetailScreen> createState() => _MovieDetailScreenState();
}

class _MovieDetailScreenState extends State<MovieDetailScreen> {
  late bool isFavorite;

  @override
  void initState() {
    super.initState();
    isFavorite = widget.movie.isFavorite;
  }

  void _toggleFavorite() {
    setState(() => isFavorite = !isFavorite);
  }

  void _showSnack(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), duration: const Duration(seconds: 1)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final movie = widget.movie;

    return Scaffold(
      // ---------------------------------------------------------
      // Sub-step 1: Blank Scaffold + AppBar
      // ---------------------------------------------------------
      appBar: AppBar(title: Text(movie.title)),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // -------------------------------------------------
            // Sub-step 2: Hero Banner (Stack + Image.network + gradient)
            // -------------------------------------------------
            Stack(
              children: [
                Hero(
                  tag: 'poster-${movie.id}',
                  child: Image.network(
                    movie.posterUrl,
                    width: double.infinity,
                    height: 260,
                    fit: BoxFit.cover,
                    errorBuilder: (c, e, s) => Container(
                      width: double.infinity,
                      height: 260,
                      color: Colors.grey.shade400,
                    ),
                  ),
                ),
                Container(
                  height: 260,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Colors.transparent, Colors.black87],
                    ),
                  ),
                ),
                Positioned(
                  left: 16,
                  bottom: 12,
                  right: 16,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        movie.title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Row(
                        children: [
                          const Icon(Icons.star, color: Colors.amber, size: 18),
                          const SizedBox(width: 4),
                          Text(
                            movie.rating.toStringAsFixed(1),
                            style: const TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),

            // -------------------------------------------------
            // Sub-step 3: Title & Genres (Column + Wrap + Chip)
            // -------------------------------------------------
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: movie.genres
                    .map((g) => Chip(label: Text(g)))
                    .toList(),
              ),
            ),

            // -------------------------------------------------
            // Sub-step 4: Overview text with Padding
            // -------------------------------------------------
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                movie.overview,
                style: const TextStyle(fontSize: 15, height: 1.4),
              ),
            ),

            // -------------------------------------------------
            // Sub-step 5: Row of IconButtons (Favorite / Rate / Share)
            // -------------------------------------------------
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    children: [
                      IconButton(
                        icon: Icon(
                          isFavorite ? Icons.favorite : Icons.favorite_border,
                          color: isFavorite ? Colors.red : null,
                        ),
                        onPressed: _toggleFavorite,
                      ),
                      const Text('Favorite'),
                    ],
                  ),
                  Column(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.star_rate),
                        onPressed: () => _showSnack('Rate tapped'),
                      ),
                      const Text('Rate'),
                    ],
                  ),
                  Column(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.share),
                        onPressed: () => _showSnack('Share tapped'),
                      ),
                      const Text('Share'),
                    ],
                  ),
                ],
              ),
            ),

            const Divider(height: 32),

            // -------------------------------------------------
            // Sub-step 6: Trailer list using ListView.builder
            // -------------------------------------------------
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'Trailers',
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            SizedBox(
              height: 140,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                itemCount: movie.trailers.length,
                itemBuilder: (context, index) {
                  final trailer = movie.trailers[index];
                  return Padding(
                    padding: const EdgeInsets.only(right: 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            trailer.thumbnailUrl,
                            width: 160,
                            height: 90,
                            fit: BoxFit.cover,
                            errorBuilder: (c, e, s) => Container(
                              width: 160,
                              height: 90,
                              color: Colors.grey.shade300,
                              child: const Icon(Icons.play_circle_outline),
                            ),
                          ),
                        ),
                        const SizedBox(height: 4),
                        SizedBox(
                          width: 160,
                          child: Text(
                            trailer.title,
                            style: const TextStyle(fontSize: 12),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
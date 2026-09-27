import 'package:flutter/material.dart';

// Exercise 3 - Layout Basics: Column, Row, Padding, ListView
// Sectioned UI layout similar to a real app Home screen.

class LayoutBasicsDemo extends StatelessWidget {
  const LayoutBasicsDemo({super.key});

  final List<String> movies = const [
    'Inception',
    'Interstellar',
    'The Dark Knight',
    'Dune',
    'Oppenheimer',
    'Parasite',
    'Avatar',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section 1: Header / greeting
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text(
                  'Welcome back!',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                Icon(Icons.account_circle, size: 32),
              ],
            ),
          ),

          const SizedBox(height: 8),

          // Section 2: Quick actions row
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: const [
                _QuickAction(icon: Icons.search, label: 'Search'),
                _QuickAction(icon: Icons.favorite, label: 'Favorites'),
                _QuickAction(icon: Icons.download, label: 'Downloads'),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Section 3: List title
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'Popular Movies',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ),

          const SizedBox(height: 8),

          // Section 4: Scrollable list — Expanded so ListView gets
          // bounded height inside the Column (see Exercise 5 fix #1).
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: movies.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Card(
                    child: ListTile(
                      leading: const Icon(Icons.movie),
                      title: Text(movies[index]),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _QuickAction extends StatelessWidget {
  final IconData icon;
  final String label;

  const _QuickAction({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(child: Icon(icon)),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(fontSize: 12)),
      ],
    );
  }
}
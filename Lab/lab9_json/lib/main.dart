
import 'package:flutter/material.dart';

import 'screens/products_screen.dart';
import 'screens/storage_screen.dart';
import 'screens/crud_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Lab 9 - JSON Storage',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
        ),
        useMaterial3: true,
      ),
      home: const LabMenuScreen(),
    );
  }
}

class LabMenuScreen extends StatelessWidget {
  const LabMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lab 9 - JSON Storage'),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildLabCard(
            context: context,
            title: 'Lab 9.1',
            subtitle: 'Read JSON From Assets',
            icon: Icons.folder_open,
            screen: const ProductsScreen(),
          ),
          _buildLabCard(
            context: context,
            title: 'Lab 9.2',
            subtitle: 'Save & Load JSON From Device Storage',
            icon: Icons.save,
            screen: const StorageScreen(),
          ),
          _buildLabCard(
            context: context,
            title: 'Lab 9.3',
            subtitle: 'JSON CRUD Mini Database',
            icon: Icons.storage,
            screen: const CrudScreen(),
          ),
        ],
      ),
    );
  }

  Widget _buildLabCard({
    required BuildContext context,
    required String title,
    required String subtitle,
    required IconData icon,
    required Widget screen,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: CircleAvatar(
          child: Icon(icon),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Text(subtitle),
        ),
        trailing: const Icon(Icons.arrow_forward_ios),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => screen,
            ),
          );
        },
      ),
    );
  }
}

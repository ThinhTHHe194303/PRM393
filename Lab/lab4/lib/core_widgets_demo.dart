import 'dart:io';

import 'package:flutter/material.dart';

class CoreWidgetsDemo extends StatelessWidget {
  const CoreWidgetsDemo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Core Widget Demo")),
      body: Padding(
        padding: const EdgeInsets.all(16),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //Text Widget
            const Text(
              "Flutter UI Fundamentals",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 16),

            //Icon Widget
            const Icon(Icons.flutter_dash, size: 60, color: Colors.blue),

            const SizedBox(height: 16),

            //Image Widget
            Image.network(
              'https://fhntoday.com/wp-content/uploads/2015/12/swordartonline.pdf-.jpg',
              height: 200,
              width: double.infinity,
              fit: BoxFit.cover,
            ),

            const SizedBox(height: 16),

            //Card + ListTitle
            Card(
              child: ListTile(
                leading: const Icon(Icons.movie),
                title: const Text('Sword Art Online'),
                subtitle: const Text('A simple Flutter UI example'),
                trailing: const Icon(Icons.arrow_forward),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

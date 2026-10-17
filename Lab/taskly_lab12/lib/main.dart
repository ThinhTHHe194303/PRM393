import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:taskly_lab12/providers/task_provider.dart';
import 'package:taskly_lab12/screens/task_list_screen.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Exercise 12.2 – Image & Asset Optimisation
// ─────────────────────────────────────────────────────────────────────────────
//
// • task_icon.png (128×128 px) added under assets/images/.
// • precacheImage() called in TasklyApp.didChangeDependencies() so the image
//   is loaded into the image cache before any screen that uses it is painted.
// • pubspec.yaml lists only the assets that are actually used (asset cleanup).

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => TaskProvider(),
      child: const TasklyApp(),
    ),
  );
}

class TasklyApp extends StatefulWidget {
  const TasklyApp({super.key});

  @override
  State<TasklyApp> createState() => _TasklyAppState();
}

class _TasklyAppState extends State<TasklyApp> {
  // ── Exercise 12.2: pre-cache the task icon so it renders instantly ─────────
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    precacheImage(
      const AssetImage('assets/images/task_icon.png'),
      context,
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Taskly',
      debugShowCheckedModeBanner: false, // removed in release build
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF9B59FF),
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      home: const TaskListScreen(),
    );
  }
}

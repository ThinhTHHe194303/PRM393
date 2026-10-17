import 'package:flutter/material.dart';
import 'package:taskly_lab11/repositories/task_repository.dart';
import 'package:taskly_lab11/screens/task_list_screen.dart';

void main() {
  runApp(const TasklyApp());
}

class TasklyApp extends StatelessWidget {
  const TasklyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Taskly',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF9B59FF),
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      home: TaskListScreen(repository: TaskRepository()),
    );
  }
}

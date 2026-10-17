import '../models/task.dart';

class TaskRepository {
  final List<Task> _tasks = [];

  List<Task> getTasks() => List.unmodifiable(_tasks);

  void addTask(Task task) => _tasks.add(task);

  void deleteTask(String id) => _tasks.removeWhere((t) => t.id == id);

  void updateTask(Task updated) {
    final index = _tasks.indexWhere((t) => t.id == updated.id);
    if (index != -1) _tasks[index] = updated;
  }
}
import 'package:taskly_lab12/models/task.dart';

/// In-memory repository for managing [Task] objects.
class TaskRepository {
  final List<Task> _tasks = [];

  /// Returns an unmodifiable view of all tasks.
  List<Task> get tasks => List.unmodifiable(_tasks);

  /// Adds [task] to the repository.
  void addTask(Task task) {
    _tasks.add(task);
  }

  /// Removes the task with the given [id] from the repository.
  /// Does nothing if no task with that id exists.
  void deleteTask(String id) {
    _tasks.removeWhere((t) => t.id == id);
  }

  /// Replaces the existing task that has the same [id] as [updatedTask].
  /// Throws [ArgumentError] if no matching task is found.
  void updateTask(Task updatedTask) {
    final index = _tasks.indexWhere((t) => t.id == updatedTask.id);
    if (index == -1) {
      throw ArgumentError('Task with id "${updatedTask.id}" not found.');
    }
    _tasks[index] = updatedTask;
  }

  /// Returns the task with the given [id], or `null` if not found.
  Task? findById(String id) {
    try {
      return _tasks.firstWhere((t) => t.id == id);
    } catch (_) {
      return null;
    }
  }

  /// Removes all tasks from the repository.
  void clear() => _tasks.clear();
}

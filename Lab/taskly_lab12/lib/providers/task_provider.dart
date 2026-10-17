import 'package:flutter/foundation.dart';
import 'package:taskly_lab12/models/task.dart';
import 'package:taskly_lab12/repositories/task_repository.dart';

/// [ChangeNotifier] wrapper around [TaskRepository].
///
/// Using a dedicated provider means widgets can subscribe only to the
/// slice of state they care about via [Selector], avoiding full-tree
/// rebuilds on every CRUD operation (Exercise 12.1 optimisation).
class TaskProvider extends ChangeNotifier {
  final TaskRepository _repository;

  TaskProvider({TaskRepository? repository})
      : _repository = repository ?? TaskRepository();

  // ── Public accessors ──────────────────────────────────────────────────────

  /// Unmodifiable snapshot of all tasks.
  List<Task> get tasks => _repository.tasks;

  /// Number of tasks currently stored.
  int get taskCount => _repository.tasks.length;

  // ── CRUD operations ───────────────────────────────────────────────────────

  /// Adds a new task with [title] and notifies listeners.
  void addTask(String title) {
    if (title.trim().isEmpty) return;
    final task = Task(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      title: title.trim(),
    );
    _repository.addTask(task);
    notifyListeners();
  }

  /// Toggles the [completed] flag of [task] and notifies listeners.
  ///
  /// **Why `copyWith` instead of `task.toggle()`?**
  /// `Selector` uses `DeepCollectionEquality` to compare the old and new
  /// selected value.  `DeepCollectionEquality` short-circuits via
  /// `identical(a, b)` — if the old and new list contain the *same object
  /// reference* (even with a mutated field), it considers them equal and
  /// skips the rebuild.  Creating a brand-new `Task` via `copyWith` gives a
  /// different reference, so equality fails → Selector rebuilds correctly.
  void toggleTask(Task task) {
    final toggled = task.copyWith(completed: !task.completed);
    _repository.updateTask(toggled);
    notifyListeners();
  }

  /// Deletes the task with [id] and notifies listeners.
  void deleteTask(String id) {
    _repository.deleteTask(id);
    notifyListeners();
  }

  /// Updates an existing task and notifies listeners.
  void updateTask(Task updatedTask) {
    _repository.updateTask(updatedTask);
    notifyListeners();
  }
}

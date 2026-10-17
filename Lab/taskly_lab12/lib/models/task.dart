// ignore_for_file: unnecessary_this
/// Represents a single task in the Taskly application.
class Task {
  final String id;
  String title;
  bool completed;

  Task({
    required this.id,
    required this.title,
    this.completed = false,
  });

  /// Toggles the [completed] state of this task.
  void toggle() {
    completed = !completed;
  }

  /// Returns a copy of this task with optional field overrides.
  Task copyWith({
    String? id,
    String? title,
    bool? completed,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      completed: completed ?? this.completed,
    );
  }

  @override
  String toString() => 'Task(id: $id, title: $title, completed: $completed)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Task &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          title == other.title &&
          completed == other.completed;

  @override
  int get hashCode => id.hashCode ^ title.hashCode ^ completed.hashCode;
}

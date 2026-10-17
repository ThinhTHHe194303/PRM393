import 'package:flutter/material.dart';
import 'package:taskly_lab11/models/task.dart';
import 'package:taskly_lab11/repositories/task_repository.dart';
import 'package:taskly_lab11/screens/task_detail_screen.dart';

/// Displays the list of tasks and allows adding new ones.
class TaskListScreen extends StatefulWidget {
  final TaskRepository repository;

  const TaskListScreen({super.key, required this.repository});

  @override
  State<TaskListScreen> createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  final TextEditingController _controller = TextEditingController();

  void _addTask() {
    final title = _controller.text.trim();
    if (title.isEmpty) return;

    final task = Task(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      title: title,
    );

    setState(() {
      widget.repository.addTask(task);
      _controller.clear();
    });
  }

  void _toggleTask(Task task) {
    setState(() {
      task.toggle();
    });
  }

  void _deleteTask(String id) {
    setState(() {
      widget.repository.deleteTask(id);
    });
  }

  Future<void> _openDetail(Task task) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => TaskDetailScreen(
          task: task,
          repository: widget.repository,
        ),
      ),
    );
    // Refresh UI after returning from detail screen
    setState(() {});
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tasks = widget.repository.tasks;

    return Scaffold(
      backgroundColor: const Color(0xFF0F0F1A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A1A2E),
        title: const Text(
          'Taskly',
          style: TextStyle(
            color: Color(0xFF9B59FF),
            fontWeight: FontWeight.bold,
            fontSize: 24,
            letterSpacing: 1.5,
          ),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: Column(
        children: [
          // ── Add-task input row ──────────────────────────────────────────
          Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFF1A1A2E),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFF9B59FF), width: 1),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    key: const Key('addTaskField'),
                    controller: _controller,
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                      hintText: 'New task…',
                      hintStyle: TextStyle(color: Color(0xFF666699)),
                      border: InputBorder.none,
                    ),
                    onSubmitted: (_) => _addTask(),
                  ),
                ),
                IconButton(
                  key: const Key('addTaskButton'),
                  icon: const Icon(Icons.add_circle, color: Color(0xFF9B59FF)),
                  iconSize: 32,
                  onPressed: _addTask,
                ),
              ],
            ),
          ),

          // ── Task list ────────────────────────────────────────────────────
          Expanded(
            child: tasks.isEmpty
                ? const Center(
                    child: Text(
                      'No tasks yet. Add one!',
                      key: Key('emptyStateText'),
                      style: TextStyle(color: Color(0xFF666699), fontSize: 16),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: tasks.length,
                    itemBuilder: (context, index) {
                      final task = tasks[index];
                      return _TaskTile(
                        task: task,
                        onTap: () => _openDetail(task),
                        onToggle: () => _toggleTask(task),
                        onDelete: () => _deleteTask(task.id),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

// ── Private tile widget ──────────────────────────────────────────────────────

class _TaskTile extends StatelessWidget {
  final Task task;
  final VoidCallback onTap;
  final VoidCallback onToggle;
  final VoidCallback onDelete;

  const _TaskTile({
    required this.task,
    required this.onTap,
    required this.onToggle,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: task.completed
                ? [const Color(0xFF1A1A2E), const Color(0xFF1A1A2E)]
                : [const Color(0xFF1A1A2E), const Color(0xFF25254A)],
          ),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: task.completed
                ? const Color(0xFF333366)
                : const Color(0xFF9B59FF),
            width: 0.8,
          ),
        ),
        child: Row(
          children: [
            // Checkbox
            GestureDetector(
              key: Key('toggleButton_${task.id}'),
              onTap: onToggle,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: task.completed
                      ? const Color(0xFF9B59FF)
                      : Colors.transparent,
                  border: Border.all(
                    color: task.completed
                        ? const Color(0xFF9B59FF)
                        : const Color(0xFF666699),
                    width: 2,
                  ),
                ),
                child: task.completed
                    ? const Icon(Icons.check, size: 16, color: Colors.white)
                    : null,
              ),
            ),
            const SizedBox(width: 12),
            // Title
            Expanded(
              child: Text(
                task.title,
                style: TextStyle(
                  color: task.completed
                      ? const Color(0xFF666699)
                      : Colors.white,
                  fontSize: 15,
                  decoration: task.completed
                      ? TextDecoration.lineThrough
                      : TextDecoration.none,
                ),
              ),
            ),
            // Delete
            IconButton(
              icon: const Icon(Icons.delete_outline, color: Color(0xFF666699)),
              onPressed: onDelete,
            ),
          ],
        ),
      ),
    );
  }
}

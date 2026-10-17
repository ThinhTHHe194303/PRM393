import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:taskly_lab12/models/task.dart';
import 'package:taskly_lab12/providers/task_provider.dart';
import 'package:taskly_lab12/screens/task_detail_screen.dart';
import 'package:taskly_lab12/widgets/task_tile.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Exercise 12.1 – Optimised task list screen
// ─────────────────────────────────────────────────────────────────────────────
//
// Optimisations applied:
//   1. Screen is now a *StatelessWidget* – state lives in TaskProvider.
//   2. The add-task input row uses Consumer<TaskProvider> only where needed.
//   3. The list section uses Selector<TaskProvider, List<Task>> so it rebuilds
//      ONLY when the task list itself changes (not on unrelated provider updates).
//   4. Each TaskTile is keyed with ValueKey(task.id) for stable element reuse.
//   5. All static decorations are const-constructed.

/// Displays the list of tasks and allows adding / editing / deleting them.
class TaskListScreen extends StatelessWidget {
  const TaskListScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
      body: const Column(
        children: [
          _AddTaskInput(),    // const → only rebuilds when its own state changes
          Expanded(child: _TaskList()),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Private widget: add-task input row
// ─────────────────────────────────────────────────────────────────────────────

/// Stateful only because it owns a [TextEditingController].
/// The rest of the screen is not rebuilt when the user types here.
class _AddTaskInput extends StatefulWidget {
  const _AddTaskInput();

  @override
  State<_AddTaskInput> createState() => _AddTaskInputState();
}

class _AddTaskInputState extends State<_AddTaskInput> {
  final TextEditingController _controller = TextEditingController();

  void _addTask() {
    context.read<TaskProvider>().addTask(_controller.text);
    _controller.clear();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
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
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Private widget: task list
// ─────────────────────────────────────────────────────────────────────────────

/// Uses [Selector] so it rebuilds ONLY when the task list changes.
/// Unchanged parts of the widget tree (e.g. the AppBar) are not touched.
class _TaskList extends StatelessWidget {
  const _TaskList();

  Future<void> _openDetail(BuildContext context, Task task) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ChangeNotifierProvider.value(
          value: context.read<TaskProvider>(),
          child: TaskDetailScreen(task: task),
        ),
      ),
    );
    // No manual setState needed — provider notifies listeners automatically.
  }

  @override
  Widget build(BuildContext context) {
    // Selector<T, S> – rebuilds only when List<Task> instance changes.
    return Selector<TaskProvider, List<Task>>(
      selector: (_, provider) => provider.tasks,
      builder: (context, tasks, _) {
        if (tasks.isEmpty) {
          return const Center(
            child: Text(
              'No tasks yet. Add one!',
              key: Key('emptyStateText'),
              style: TextStyle(color: Color(0xFF666699), fontSize: 16),
            ),
          );
        }
        return ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemCount: tasks.length,
          itemBuilder: (context, index) {
            final task = tasks[index];
            return TaskTile(
              key: ValueKey(task.id), // ← stable key prevents unnecessary rebuilds
              task: task,
              onTap: () => _openDetail(context, task),
              onToggle: () => context.read<TaskProvider>().toggleTask(task),
              onDelete: () => context.read<TaskProvider>().deleteTask(task.id),
            );
          },
        );
      },
    );
  }
}

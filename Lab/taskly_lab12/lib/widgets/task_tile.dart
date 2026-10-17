import 'package:flutter/material.dart';
import 'package:taskly_lab12/models/task.dart';

/// A standalone, extracted widget that renders a single task row.
///
/// **Exercise 12.1 – Optimisation notes:**
/// • Extracted from the private `_TaskTile` inside `task_list_screen.dart`
///   into a *public* top-level widget so Flutter's element-recycling works
///   correctly across hot-reloads and tree reconciliation.
/// • Used with `ValueKey(task.id)` by the parent `ListView.builder`, so the
///   framework reuses existing elements instead of rebuilding them from scratch
///   when the list order changes.
/// • All decoration constants are `const`-constructed to avoid allocating new
///   objects on every build pass.
/// • **FIX:** No wrapping GestureDetector around the whole card.  Nested
///   GestureDetectors that both recognise `onTap` compete in Flutter's gesture
///   arena and the outer one can absorb the tap before the inner toggle fires.
///   Instead, each hit-test zone (toggle circle, title, delete button) is
///   independent, so there is no arena conflict.
class TaskTile extends StatelessWidget {
  final Task task;
  final VoidCallback onTap;       // tap on the title → open detail
  final VoidCallback onToggle;    // tap on the circle → toggle completion
  final VoidCallback onDelete;    // tap on the trash icon → delete

  const TaskTile({
    super.key,
    required this.task,
    required this.onTap,
    required this.onToggle,
    required this.onDelete,
  });

  // ── Colour constants (avoids object allocation on every build) ────────────
  static const _purple    = Color(0xFF9B59FF);
  static const _dimPurple = Color(0xFF666699);
  static const _darkBg    = Color(0xFF1A1A2E);
  static const _darkBg2   = Color(0xFF25254A);
  static const _dimBorder = Color(0xFF333366);

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: task.completed
              ? const [_darkBg, _darkBg]
              : const [_darkBg, _darkBg2],
        ),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: task.completed ? _dimBorder : _purple,
          width: 0.8,
        ),
      ),
      child: Row(
        children: [
          // ── Toggle circle ─────────────────────────────────────────────────
          // Independent GestureDetector — no parent competing for the same tap.
          GestureDetector(
            key: Key('toggleButton_${task.id}'),
            onTap: onToggle,
            behavior: HitTestBehavior.opaque, // ensures the tap is claimed here
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: task.completed ? _purple : Colors.transparent,
                border: Border.all(
                  color: task.completed ? _purple : _dimPurple,
                  width: 2,
                ),
              ),
              child: task.completed
                  ? const Icon(Icons.check, size: 16, color: Colors.white)
                  : null,
            ),
          ),

          const SizedBox(width: 12),

          // ── Task title (tap to open detail) ───────────────────────────────
          Expanded(
            child: GestureDetector(
              key: Key('titleButton_${task.id}'),
              onTap: onTap,
              behavior: HitTestBehavior.opaque,
              child: Text(
                task.title,
                style: TextStyle(
                  color: task.completed ? _dimPurple : Colors.white,
                  fontSize: 15,
                  decoration: task.completed
                      ? TextDecoration.lineThrough
                      : TextDecoration.none,
                ),
              ),
            ),
          ),

          // ── Delete button (IconButton owns its own tap zone) ──────────────
          IconButton(
            key: Key('deleteButton_${task.id}'),
            icon: const Icon(Icons.delete_outline, color: _dimPurple),
            onPressed: onDelete,
          ),
        ],
      ),
    );
  }
}

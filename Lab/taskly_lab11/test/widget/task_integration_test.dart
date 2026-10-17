// test/widget/task_integration_test.dart
// LAB 11.4 — Integration Testing: Full Flow
//
// Simulates an end-to-end user flow:
//   1. Add "Original title"
//   2. Tap task → open TaskDetailScreen
//   3. Edit title → "Updated title"
//   4. Save → return to list
//   5. Verify updated title appears in list

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:taskly_lab11/repositories/task_repository.dart';
import 'package:taskly_lab11/screens/task_list_screen.dart';

/// Wraps [TaskListScreen] inside [MaterialApp] for full navigation support.
Widget buildTestApp(TaskRepository repository) {
  return MaterialApp(
    home: TaskListScreen(repository: repository),
  );
}

void main() {
  group('Integration Tests — Full Task Flow', () {
    // ─────────────────────────────────────────────────────────────
    // Core end-to-end flow
    // ─────────────────────────────────────────────────────────────

    testWidgets(
        'Full flow: add → open detail → edit → save → verify in list',
        (WidgetTester tester) async {
      // ── Arrange ──────────────────────────────────────────────
      final repo = TaskRepository();
      await tester.pumpWidget(buildTestApp(repo));

      // ── Step 1: Add a task ──────────────────────────────────
      await tester.enterText(
          find.byKey(const Key('addTaskField')), 'Original title');
      await tester.tap(find.byKey(const Key('addTaskButton')));
      await tester.pump();

      // Verify task appears in list
      expect(find.text('Original title'), findsOneWidget);

      // ── Step 2: Tap task to open detail screen ───────────────
      await tester.tap(find.text('Original title'));
      await tester.pumpAndSettle();

      // Verify we are on detail screen
      expect(find.text('Task Detail'), findsOneWidget);
      expect(find.byKey(const Key('detailTitleField')), findsOneWidget);

      // ── Step 3: Clear and type new title ────────────────────
      await tester.tap(find.byKey(const Key('detailTitleField')));
      await tester.pump();

      // Clear the current text and enter new title
      await tester.enterText(
          find.byKey(const Key('detailTitleField')), 'Updated title');

      // ── Step 4: Save ─────────────────────────────────────────
      await tester.tap(find.byKey(const Key('saveButtonLarge')));
      await tester.pumpAndSettle();

      // ── Step 5 (Assert): Verify updated title in list ────────
      expect(find.text('Updated title'), findsOneWidget);
      expect(find.text('Original title'), findsNothing);
    });

    // ─────────────────────────────────────────────────────────────
    // Cancel flow — navigating back without saving
    // ─────────────────────────────────────────────────────────────

    testWidgets(
        'Cancel flow: edit title but navigate back without saving keeps original',
        (WidgetTester tester) async {
      // Arrange
      final repo = TaskRepository();
      await tester.pumpWidget(buildTestApp(repo));

      // Add task
      await tester.enterText(
          find.byKey(const Key('addTaskField')), 'Stable title');
      await tester.tap(find.byKey(const Key('addTaskButton')));
      await tester.pump();

      // Navigate to detail
      await tester.tap(find.text('Stable title'));
      await tester.pumpAndSettle();

      // Edit without saving
      await tester.enterText(
          find.byKey(const Key('detailTitleField')), 'Unsaved change');

      // Press back
      final NavigatorState navigator = tester.state(find.byType(Navigator));
      navigator.pop();
      await tester.pumpAndSettle();

      // Assert — original title still in the repository
      expect(repo.tasks.first.title, equals('Stable title'));
    });

    // ─────────────────────────────────────────────────────────────
    // Multiple edits
    // ─────────────────────────────────────────────────────────────

    testWidgets('Can edit a task title multiple times sequentially',
        (WidgetTester tester) async {
      // Arrange
      final repo = TaskRepository();
      await tester.pumpWidget(buildTestApp(repo));

      // Add task
      await tester.enterText(
          find.byKey(const Key('addTaskField')), 'Version 1');
      await tester.tap(find.byKey(const Key('addTaskButton')));
      await tester.pump();

      Future<void> editTask(String newTitle) async {
        await tester.tap(find.text(newTitle.contains('Version')
            ? repo.tasks.first.title
            : newTitle));
        await tester.pumpAndSettle();
        await tester.enterText(
            find.byKey(const Key('detailTitleField')), newTitle);
        await tester.tap(find.byKey(const Key('saveButtonLarge')));
        await tester.pumpAndSettle();
      }

      // Act — first edit
      await tester.tap(find.text('Version 1'));
      await tester.pumpAndSettle();
      await tester.enterText(
          find.byKey(const Key('detailTitleField')), 'Version 2');
      await tester.tap(find.byKey(const Key('saveButtonLarge')));
      await tester.pumpAndSettle();

      expect(find.text('Version 2'), findsOneWidget);

      // Act — second edit
      await tester.tap(find.text('Version 2'));
      await tester.pumpAndSettle();
      await tester.enterText(
          find.byKey(const Key('detailTitleField')), 'Version 3');
      await tester.tap(find.byKey(const Key('saveButtonLarge')));
      await tester.pumpAndSettle();

      // Assert
      expect(find.text('Version 3'), findsOneWidget);
      expect(find.text('Version 1'), findsNothing);
      expect(find.text('Version 2'), findsNothing);

      // Suppress unused variable warning
      editTask; // referenced above
    });

    // ─────────────────────────────────────────────────────────────
    // Delete flow
    // ─────────────────────────────────────────────────────────────

    testWidgets('Deleting a task removes it from the list',
        (WidgetTester tester) async {
      // Arrange
      final repo = TaskRepository();
      await tester.pumpWidget(buildTestApp(repo));

      // Add task
      await tester.enterText(
          find.byKey(const Key('addTaskField')), 'Delete me');
      await tester.tap(find.byKey(const Key('addTaskButton')));
      await tester.pump();
      expect(find.text('Delete me'), findsOneWidget);

      // Act — tap delete icon button
      await tester.tap(find.byIcon(Icons.delete_outline));
      await tester.pump();

      // Assert
      expect(find.text('Delete me'), findsNothing);
      expect(find.text('No tasks yet. Add one!'), findsOneWidget);
    });

    // ─────────────────────────────────────────────────────────────
    // Complete-task toggle flow
    // ─────────────────────────────────────────────────────────────

    testWidgets('Toggling task marks it as completed in repository',
        (WidgetTester tester) async {
      // Arrange
      final repo = TaskRepository();
      await tester.pumpWidget(buildTestApp(repo));

      // Add task
      await tester.enterText(
          find.byKey(const Key('addTaskField')), 'Toggle task');
      await tester.tap(find.byKey(const Key('addTaskButton')));
      await tester.pump();

      // Pre-condition: not completed
      expect(repo.tasks.first.completed, isFalse);

      // Act — tap the toggle circle using its keyed GestureDetector
      final taskId = repo.tasks.first.id;
      await tester.tap(find.byKey(Key('toggleButton_$taskId')));
      await tester.pump();

      // Assert — task is now completed
      expect(repo.tasks.first.completed, isTrue);
    });
  });
}

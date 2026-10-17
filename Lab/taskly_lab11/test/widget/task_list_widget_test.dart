// test/widget/task_list_widget_test.dart
// LAB 11.2 — Widget Testing: Task List UI
//
// Tests UI rendering and task addition in TaskListScreen.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:taskly_lab11/models/task.dart';
import 'package:taskly_lab11/repositories/task_repository.dart';
import 'package:taskly_lab11/screens/task_list_screen.dart';

/// Helper: wraps [TaskListScreen] inside a [MaterialApp] so that
/// navigation and theme lookups work correctly.
Widget buildTestApp(TaskRepository repository) {
  return MaterialApp(
    home: TaskListScreen(repository: repository),
  );
}

void main() {
  group('TaskListScreen — Widget Tests', () {
    // ─────────────────────────────────────────────────────────────
    // Empty state
    // ─────────────────────────────────────────────────────────────

    testWidgets('Shows empty-state message when no tasks exist',
        (WidgetTester tester) async {
      // Arrange
      final repo = TaskRepository();

      // Act
      await tester.pumpWidget(buildTestApp(repo));

      // Assert
      expect(find.text('No tasks yet. Add one!'), findsOneWidget);
    });

    testWidgets('Does not show task list when repository is empty',
        (WidgetTester tester) async {
      // Arrange
      final repo = TaskRepository();

      // Act
      await tester.pumpWidget(buildTestApp(repo));

      // Assert
      expect(find.byType(ListView), findsNothing);
    });

    // ─────────────────────────────────────────────────────────────
    // Add task
    // ─────────────────────────────────────────────────────────────

    testWidgets('Add task: entering text and tapping add shows task in list',
        (WidgetTester tester) async {
      // Arrange
      final repo = TaskRepository();
      await tester.pumpWidget(buildTestApp(repo));

      // Act — type into the text field
      await tester.enterText(find.byKey(const Key('addTaskField')), 'Buy milk');

      // Act — tap the add button
      await tester.tap(find.byKey(const Key('addTaskButton')));
      await tester.pump();

      // Assert — task title appears in the list
      expect(find.text('Buy milk'), findsOneWidget);
    });

    testWidgets('Add task: empty-state text disappears after adding a task',
        (WidgetTester tester) async {
      // Arrange
      final repo = TaskRepository();
      await tester.pumpWidget(buildTestApp(repo));
      expect(find.text('No tasks yet. Add one!'), findsOneWidget);

      // Act
      await tester.enterText(find.byKey(const Key('addTaskField')), 'Walk dog');
      await tester.tap(find.byKey(const Key('addTaskButton')));
      await tester.pump();

      // Assert
      expect(find.text('No tasks yet. Add one!'), findsNothing);
    });

    testWidgets('Add task: text field is cleared after adding',
        (WidgetTester tester) async {
      // Arrange
      final repo = TaskRepository();
      await tester.pumpWidget(buildTestApp(repo));

      // Act
      await tester.enterText(
          find.byKey(const Key('addTaskField')), 'Read book');
      await tester.tap(find.byKey(const Key('addTaskButton')));
      await tester.pump();

      // Assert — field should be empty
      final field = tester.widget<TextField>(
        find.byKey(const Key('addTaskField')),
      );
      expect(field.controller?.text, isEmpty);
    });

    testWidgets('Add task: pressing Enter on keyboard also adds task',
        (WidgetTester tester) async {
      // Arrange
      final repo = TaskRepository();
      await tester.pumpWidget(buildTestApp(repo));

      // Act
      await tester.enterText(
          find.byKey(const Key('addTaskField')), 'Study Dart');
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pump();

      // Assert
      expect(find.text('Study Dart'), findsOneWidget);
    });

    testWidgets('Add task: blank input does not add a task',
        (WidgetTester tester) async {
      // Arrange
      final repo = TaskRepository();
      await tester.pumpWidget(buildTestApp(repo));

      // Act — tap add without typing anything
      await tester.tap(find.byKey(const Key('addTaskButton')));
      await tester.pump();

      // Assert — empty state still visible
      expect(find.text('No tasks yet. Add one!'), findsOneWidget);
    });

    // ─────────────────────────────────────────────────────────────
    // Multiple tasks
    // ─────────────────────────────────────────────────────────────

    testWidgets('Multiple tasks: adding two tasks shows both in list',
        (WidgetTester tester) async {
      // Arrange
      final repo = TaskRepository();
      await tester.pumpWidget(buildTestApp(repo));

      // Act — add first task
      await tester.enterText(find.byKey(const Key('addTaskField')), 'Task One');
      await tester.tap(find.byKey(const Key('addTaskButton')));
      await tester.pump();

      // Act — add second task
      await tester.enterText(find.byKey(const Key('addTaskField')), 'Task Two');
      await tester.tap(find.byKey(const Key('addTaskButton')));
      await tester.pump();

      // Assert — both tasks visible
      expect(find.text('Task One'), findsOneWidget);
      expect(find.text('Task Two'), findsOneWidget);
    });

    testWidgets('Multiple tasks: list count reflects number of added tasks',
        (WidgetTester tester) async {
      // Arrange
      final repo = TaskRepository();
      await tester.pumpWidget(buildTestApp(repo));

      // Act
      for (int i = 1; i <= 3; i++) {
        await tester.enterText(
            find.byKey(const Key('addTaskField')), 'Task $i');
        await tester.tap(find.byKey(const Key('addTaskButton')));
        await tester.pump();
      }

      // Assert
      expect(repo.tasks.length, equals(3));
      expect(find.text('Task 1'), findsOneWidget);
      expect(find.text('Task 2'), findsOneWidget);
      expect(find.text('Task 3'), findsOneWidget);
    });

    // ─────────────────────────────────────────────────────────────
    // Pre-seeded tasks render correctly
    // ─────────────────────────────────────────────────────────────

    testWidgets('Pre-seeded task is displayed on screen',
        (WidgetTester tester) async {
      // Arrange
      final repo = TaskRepository();
      repo.addTask(Task(id: 'seed-1', title: 'Seeded Task'));

      // Act
      await tester.pumpWidget(buildTestApp(repo));

      // Assert
      expect(find.text('Seeded Task'), findsOneWidget);
    });
  });
}

// test/widget/task_navigation_test.dart
// LAB 11.3 — Navigation Testing: Task List → Task Detail
//
// Tests that tapping a task in the list navigates to TaskDetailScreen
// and validates the AppBar title and the detailTitleField key.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:taskly_lab11/models/task.dart';
import 'package:taskly_lab11/repositories/task_repository.dart';
import 'package:taskly_lab11/screens/task_list_screen.dart';

/// Wraps [TaskListScreen] in a full [MaterialApp] for navigation support.
Widget buildTestApp(TaskRepository repository) {
  return MaterialApp(
    home: TaskListScreen(repository: repository),
  );
}

void main() {
  group('Navigation Tests — TaskListScreen → TaskDetailScreen', () {
    // ─────────────────────────────────────────────────────────────
    // Basic navigation
    // ─────────────────────────────────────────────────────────────

    testWidgets(
        'Tapping a task navigates to TaskDetailScreen with "Task Detail" AppBar',
        (WidgetTester tester) async {
      // Arrange — seed repository with one task
      final repo = TaskRepository();
      repo.addTask(Task(id: 'nav-1', title: 'Navigate to me'));

      await tester.pumpWidget(buildTestApp(repo));

      // Pre-condition: task is visible in list
      expect(find.text('Navigate to me'), findsOneWidget);

      // Act — tap the task tile
      await tester.tap(find.text('Navigate to me'));
      await tester.pumpAndSettle();

      // Assert — AppBar title is "Task Detail"
      expect(find.text('Task Detail'), findsOneWidget);
    });

    testWidgets(
        'TaskDetailScreen contains a TextField with key "detailTitleField"',
        (WidgetTester tester) async {
      // Arrange
      final repo = TaskRepository();
      repo.addTask(Task(id: 'nav-2', title: 'Check field'));

      await tester.pumpWidget(buildTestApp(repo));

      // Act — navigate to detail
      await tester.tap(find.text('Check field'));
      await tester.pumpAndSettle();

      // Assert — detailTitleField key is present
      expect(find.byKey(const Key('detailTitleField')), findsOneWidget);
    });

    testWidgets('Detail screen pre-populates title from the tapped task',
        (WidgetTester tester) async {
      // Arrange
      final repo = TaskRepository();
      repo.addTask(Task(id: 'nav-3', title: 'Pre-populated title'));

      await tester.pumpWidget(buildTestApp(repo));

      // Act
      await tester.tap(find.text('Pre-populated title'));
      await tester.pumpAndSettle();

      // Assert — field contains the task title
      final textField = tester.widget<TextField>(
        find.byKey(const Key('detailTitleField')),
      );
      expect(textField.controller?.text, equals('Pre-populated title'));
    });

    // ─────────────────────────────────────────────────────────────
    // Back navigation
    // ─────────────────────────────────────────────────────────────

    testWidgets('Back navigation returns to TaskListScreen',
        (WidgetTester tester) async {
      // Arrange
      final repo = TaskRepository();
      repo.addTask(Task(id: 'nav-4', title: 'Back task'));

      await tester.pumpWidget(buildTestApp(repo));

      // Act — navigate to detail
      await tester.tap(find.text('Back task'));
      await tester.pumpAndSettle();

      // Act — press back
      final NavigatorState navigator = tester.state(find.byType(Navigator));
      navigator.pop();
      await tester.pumpAndSettle();

      // Assert — back on list screen
      expect(find.text('Back task'), findsOneWidget);
    });

    // ─────────────────────────────────────────────────────────────
    // Multiple tasks — navigate to the correct one
    // ─────────────────────────────────────────────────────────────

    testWidgets('Navigates to the correct task when multiple tasks exist',
        (WidgetTester tester) async {
      // Arrange
      final repo = TaskRepository();
      repo.addTask(Task(id: 'nav-5a', title: 'First Task'));
      repo.addTask(Task(id: 'nav-5b', title: 'Second Task'));

      await tester.pumpWidget(buildTestApp(repo));

      // Act — tap the second task
      await tester.tap(find.text('Second Task'));
      await tester.pumpAndSettle();

      // Assert — detail field shows the second task's title
      final textField = tester.widget<TextField>(
        find.byKey(const Key('detailTitleField')),
      );
      expect(textField.controller?.text, equals('Second Task'));
    });
  });
}

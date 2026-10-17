// test/unit/task_model_test.dart
// LAB 11.1 — Unit Testing: Task Model
//
// Tests the Task model's default values and toggle() behavior
// using the AAA (Arrange → Act → Assert) pattern.

import 'package:flutter_test/flutter_test.dart';
import 'package:taskly_lab11/models/task.dart';

void main() {
  group('Task Model', () {
    // ─────────────────────────────────────────────────────────────
    // Default value tests
    // ─────────────────────────────────────────────────────────────

    test('Default completed value is false', () {
      // Arrange
      final task = Task(id: '1', title: 'Test Task');

      // Act  — (no action needed, testing default)

      // Assert
      expect(task.completed, isFalse);
    });

    test('Task stores the correct title and id', () {
      // Arrange & Act
      final task = Task(id: 'abc', title: 'Buy groceries');

      // Assert
      expect(task.id, equals('abc'));
      expect(task.title, equals('Buy groceries'));
    });

    test('Task can be created with completed = true explicitly', () {
      // Arrange & Act
      final task = Task(id: '2', title: 'Done', completed: true);

      // Assert
      expect(task.completed, isTrue);
    });

    // ─────────────────────────────────────────────────────────────
    // toggle() tests
    // ─────────────────────────────────────────────────────────────

    test('toggle() switches completed from false to true', () {
      // Arrange
      final task = Task(id: '3', title: 'Toggle me');
      expect(task.completed, isFalse); // pre-condition

      // Act
      task.toggle();

      // Assert
      expect(task.completed, isTrue);
    });

    test('toggle() switches completed from true to false', () {
      // Arrange
      final task = Task(id: '4', title: 'Already done', completed: true);
      expect(task.completed, isTrue); // pre-condition

      // Act
      task.toggle();

      // Assert
      expect(task.completed, isFalse);
    });

    test('toggle() twice returns to original state', () {
      // Arrange
      final task = Task(id: '5', title: 'Double toggle');

      // Act
      task.toggle();
      task.toggle();

      // Assert
      expect(task.completed, isFalse);
    });

    // ─────────────────────────────────────────────────────────────
    // copyWith() tests
    // ─────────────────────────────────────────────────────────────

    test('copyWith() creates a new task with updated title', () {
      // Arrange
      final original = Task(id: '6', title: 'Original');

      // Act
      final copy = original.copyWith(title: 'Updated');

      // Assert
      expect(copy.title, equals('Updated'));
      expect(copy.id, equals('6'));
      expect(copy.completed, isFalse);
    });

    test('copyWith() does not mutate the original task', () {
      // Arrange
      final original = Task(id: '7', title: 'Keep me');

      // Act
      original.copyWith(title: 'Changed');

      // Assert
      expect(original.title, equals('Keep me'));
    });

    test('copyWith() updates completed state', () {
      // Arrange
      final original = Task(id: '8', title: 'Not done');

      // Act
      final completed = original.copyWith(completed: true);

      // Assert
      expect(completed.completed, isTrue);
    });
  });
}

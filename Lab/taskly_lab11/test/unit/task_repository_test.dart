// test/unit/task_repository_test.dart
// LAB 11.1 — Unit Testing: TaskRepository
//
// Tests addTask(), deleteTask(), and updateTask() using the
// AAA (Arrange → Act → Assert) pattern.

import 'package:flutter_test/flutter_test.dart';
import 'package:taskly_lab11/models/task.dart';
import 'package:taskly_lab11/repositories/task_repository.dart';

void main() {
  late TaskRepository repository;

  // Create a fresh repository before every test
  setUp(() {
    repository = TaskRepository();
  });

  group('TaskRepository', () {
    // ─────────────────────────────────────────────────────────────
    // addTask() tests
    // ─────────────────────────────────────────────────────────────

    group('addTask()', () {
      test('adds a task so that tasks list has one item', () {
        // Arrange
        final task = Task(id: '1', title: 'New Task');

        // Act
        repository.addTask(task);

        // Assert
        expect(repository.tasks.length, equals(1));
      });

      test('the added task matches the original task', () {
        // Arrange
        final task = Task(id: '2', title: 'Shopping');

        // Act
        repository.addTask(task);

        // Assert
        expect(repository.tasks.first.id, equals('2'));
        expect(repository.tasks.first.title, equals('Shopping'));
      });

      test('adding multiple tasks increases the count', () {
        // Arrange
        final task1 = Task(id: 'a', title: 'Task A');
        final task2 = Task(id: 'b', title: 'Task B');
        final task3 = Task(id: 'c', title: 'Task C');

        // Act
        repository.addTask(task1);
        repository.addTask(task2);
        repository.addTask(task3);

        // Assert
        expect(repository.tasks.length, equals(3));
      });

      test('tasks list is empty before any task is added', () {
        // Arrange — fresh repository from setUp

        // Act — (nothing)

        // Assert
        expect(repository.tasks, isEmpty);
      });
    });

    // ─────────────────────────────────────────────────────────────
    // deleteTask() tests
    // ─────────────────────────────────────────────────────────────

    group('deleteTask()', () {
      test('removes a task by id', () {
        // Arrange
        final task = Task(id: 'del-1', title: 'Delete me');
        repository.addTask(task);
        expect(repository.tasks.length, equals(1)); // pre-condition

        // Act
        repository.deleteTask('del-1');

        // Assert
        expect(repository.tasks, isEmpty);
      });

      test('only removes the task with the matching id', () {
        // Arrange
        final keep = Task(id: 'keep', title: 'Keep');
        final remove = Task(id: 'remove', title: 'Remove');
        repository.addTask(keep);
        repository.addTask(remove);

        // Act
        repository.deleteTask('remove');

        // Assert
        expect(repository.tasks.length, equals(1));
        expect(repository.tasks.first.id, equals('keep'));
      });

      test('does nothing when id does not exist', () {
        // Arrange
        final task = Task(id: 'existing', title: 'Existing');
        repository.addTask(task);

        // Act
        repository.deleteTask('non-existent-id');

        // Assert
        expect(repository.tasks.length, equals(1));
      });
    });

    // ─────────────────────────────────────────────────────────────
    // updateTask() tests
    // ─────────────────────────────────────────────────────────────

    group('updateTask()', () {
      test('updates the title of an existing task', () {
        // Arrange
        final original = Task(id: 'upd-1', title: 'Old title');
        repository.addTask(original);

        // Act
        final updated = original.copyWith(title: 'New title');
        repository.updateTask(updated);

        // Assert
        expect(repository.tasks.first.title, equals('New title'));
      });

      test('updates the completed state of an existing task', () {
        // Arrange
        final task = Task(id: 'upd-2', title: 'Do laundry');
        repository.addTask(task);

        // Act
        final completed = task.copyWith(completed: true);
        repository.updateTask(completed);

        // Assert
        expect(repository.tasks.first.completed, isTrue);
      });

      test('does not change the number of tasks after update', () {
        // Arrange
        final task = Task(id: 'upd-3', title: 'Count me');
        repository.addTask(task);

        // Act
        repository.updateTask(task.copyWith(title: 'Still count me'));

        // Assert
        expect(repository.tasks.length, equals(1));
      });

      test('updateTask() throws ArgumentError for unknown id', () {
        // Arrange
        final ghost = Task(id: 'ghost', title: 'Not in repo');

        // Act & Assert
        expect(
          () => repository.updateTask(ghost),
          throwsArgumentError,
        );
      });
    });

    // ─────────────────────────────────────────────────────────────
    // findById() tests
    // ─────────────────────────────────────────────────────────────

    group('findById()', () {
      test('returns the correct task for an existing id', () {
        // Arrange
        final task = Task(id: 'find-1', title: 'Find me');
        repository.addTask(task);

        // Act
        final found = repository.findById('find-1');

        // Assert
        expect(found, isNotNull);
        expect(found!.title, equals('Find me'));
      });

      test('returns null for a non-existent id', () {
        // Arrange — empty repo

        // Act
        final found = repository.findById('unknown');

        // Assert
        expect(found, isNull);
      });
    });
  });
}

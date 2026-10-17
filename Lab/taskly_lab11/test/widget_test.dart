// test/widget_test.dart
// Smoke test — kept for backward compatibility.
// Full test suite lives in test/unit/ and test/widget/.

import 'package:flutter_test/flutter_test.dart';
import 'package:taskly_lab11/main.dart';
import 'package:taskly_lab11/models/task.dart';
import 'package:taskly_lab11/repositories/task_repository.dart';

void main() {
  testWidgets('Taskly app smoke test — app starts without crashing',
      (WidgetTester tester) async {
    await tester.pumpWidget(const TasklyApp());
    expect(find.text('Taskly'), findsOneWidget);
  });

  test('Smoke: Task model and repository are importable', () {
    final repo = TaskRepository();
    final task = Task(id: '0', title: 'Smoke');
    repo.addTask(task);
    expect(repo.tasks.length, equals(1));
  });
}

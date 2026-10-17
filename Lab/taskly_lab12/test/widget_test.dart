// Basic smoke test for Taskly Lab 12.
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:taskly_lab12/providers/task_provider.dart';
import 'package:taskly_lab12/screens/task_list_screen.dart';

void main() {
  testWidgets('TaskListScreen shows empty state initially',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (_) => TaskProvider(),
        child: const MaterialApp(home: TaskListScreen()),
      ),
    );

    expect(find.byKey(const Key('emptyStateText')), findsOneWidget);
  });
}

import 'package:flutter/material.dart';

import '../models/todo.dart';

class TaskCard extends StatelessWidget {
  final Todo todo;
  final Function(String) toggleStatus;
  final Function(String) deleteTodo;
  final ColorScheme colorScheme;
  final bool isCompleted;

  const TaskCard({
    super.key,
    required this.todo,
    required this.toggleStatus,
    required this.deleteTodo,
    required this.colorScheme,
    required this.isCompleted,
  });

  @override
  Widget build(BuildContext context) {
    // Move the TaskCard implementation here from todo_screen.dart
    return Dismissible(
      key: Key(todo.id),
      direction: DismissDirection.endToStart,
      onDismissed: (_) => deleteTodo(todo.id),
      child: Container(
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    );
  }
}

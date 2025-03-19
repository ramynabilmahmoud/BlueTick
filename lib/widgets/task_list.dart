import 'package:flutter/material.dart';

import '../models/todo.dart';

class TaskList extends StatelessWidget {
  final List<Todo> todos;
  final Function(String) toggleTodoStatus;
  final Function(String) deleteTodo;
  final String title;
  final bool isCompletedSection;

  const TaskList({
    super.key,
    required this.todos,
    required this.toggleTodoStatus,
    required this.deleteTodo,
    required this.title,
    this.isCompletedSection = false,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    if (todos.isEmpty) {
      return const SliverToBoxAdapter(child: SizedBox.shrink());
    }

    return SliverList(
      delegate: SliverChildListDelegate([
        // Section Label
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 8),
          child: Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: colorScheme.primary,
            ),
          ),
        ),
      ]),
    );
  }
}

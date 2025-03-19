import 'package:flutter/material.dart';

import '../models/todo.dart';
import 'task_card.dart';

class PendingTasksSection extends StatelessWidget {
  final List<Todo> tasks;
  final Function(String) toggleStatus;
  final Function(String) deleteTodo;

  const PendingTasksSection({
    super.key,
    required this.tasks,
    required this.toggleStatus,
    required this.deleteTodo,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    if (tasks.isEmpty) {
      return const SliverToBoxAdapter(child: SizedBox.shrink());
    }

    return SliverList(
      delegate: SliverChildBuilderDelegate((context, index) {
        final todo = tasks[index];
        return TaskCard(
          todo: todo,
          toggleStatus: toggleStatus,
          deleteTodo: deleteTodo,
          colorScheme: colorScheme,
          isCompleted: false,
        );
      }, childCount: tasks.length),
    );
  }
}

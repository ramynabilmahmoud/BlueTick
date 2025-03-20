import 'package:flutter/material.dart';

import '../models/todo.dart';
import '../widgets/task_card.dart';

class CompletedTasksSection extends StatelessWidget {
  final List<Todo> completedTodos;
  final Function(String) toggleTodoStatus;
  final Function(String) deleteTodo;
  final Function(String, Priority) updatePriority;
  final Function(String, String, Priority) updateTodo;
  final ColorScheme colorScheme;
  final ThemeData theme;

  const CompletedTasksSection({
    super.key,
    required this.completedTodos,
    required this.toggleTodoStatus,
    required this.deleteTodo,
    required this.updatePriority,
    required this.updateTodo,
    required this.colorScheme,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          if (index == 0) {
            // Section header
            return Padding(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Completed',
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: colorScheme.tertiary,
                    ),
                  ),
                  Text(
                    '${completedTodos.length}',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurface.withAlpha(153),
                    ),
                  ),
                ],
              ),
            );
          }

          final todo = completedTodos[index - 1];
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: TaskCard(
              todo: todo,
              toggleStatus: toggleTodoStatus,
              deleteTodo: deleteTodo,
              onPriorityChanged: updatePriority,
              onUpdateTask: updateTodo,
            ),
          );
        },
        childCount: completedTodos.length + 1, // +1 for the header
      ),
    );
  }
}

import 'package:bluetick/models/todo.dart';
import 'package:bluetick/widgets/task_card.dart';
import 'package:flutter/material.dart';

class ActiveTasksSection extends StatelessWidget {
  final List<Todo> incompleteTodos;
  final Function(String) toggleTodoStatus;
  final Function(String) deleteTodo;
  final Function(String, Priority) updatePriority;
  final Function(String, String, Priority) updateTodo;

  const ActiveTasksSection({
    super.key,
    required this.incompleteTodos,
    required this.toggleTodoStatus,
    required this.deleteTodo,
    required this.updatePriority,
    required this.updateTodo,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

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
                    'Active Tasks',
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: colorScheme.primary,
                    ),
                  ),
                ],
              ),
            );
          }

          final todo = incompleteTodos[index - 1];
          return Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 4.0,
            ),
            child: TaskCard(
              todo: todo,
              toggleStatus: toggleTodoStatus,
              deleteTodo: deleteTodo,
              onPriorityChanged: updatePriority,
              onUpdateTask: updateTodo,
            ),
          );
        },
        childCount: incompleteTodos.length + 1, // +1 for the header
      ),
    );
  }
}

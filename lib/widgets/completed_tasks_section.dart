import 'package:bluetick/models/todo.dart';
import 'package:bluetick/widgets/task_card.dart';
import 'package:flutter/material.dart';

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
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Section header
        Padding(
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
        ),

        // Task items
        ...completedTodos.map(
          (todo) => Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: TaskCard(
              todo: todo,
              toggleStatus: toggleTodoStatus,
              deleteTodo: deleteTodo,
              onPriorityChanged: updatePriority,
              onUpdateTask: updateTodo,
            ),
          ),
        ),
      ],
    );
  }
}

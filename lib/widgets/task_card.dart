import 'package:flutter/material.dart';

import '../models/todo.dart';
import '../widgets/add_task_dialog.dart';

class TaskCard extends StatelessWidget {
  final Todo todo;
  final Function(String) toggleStatus;
  final Function(String) deleteTodo;
  final Function(Priority)? onPriorityChanged;
  final Function(String, String, Priority)? onUpdateTask;

  const TaskCard({
    super.key,
    required this.todo,
    required this.toggleStatus,
    required this.deleteTodo,
    this.onPriorityChanged,
    this.onUpdateTask,
  });

  Color getPriorityColor() {
    switch (todo.priority) {
      case Priority.high:
        return Colors.red.shade300;
      case Priority.medium:
        return Colors.orange.shade300;
      case Priority.low:
        return Colors.green.shade300;
    }
  }

  String getPriorityText() {
    switch (todo.priority) {
      case Priority.high:
        return 'High';
      case Priority.medium:
        return 'Medium';
      case Priority.low:
        return 'Low';
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      decoration: BoxDecoration(
        color:
            todo.isCompleted
                ? colorScheme.surfaceContainerLow.withAlpha(179)
                : colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(8),
            blurRadius: 10,
            spreadRadius: 0,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(
          color:
              todo.isCompleted
                  ? Colors.transparent
                  : getPriorityColor().withAlpha(31),
          width: 1,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Dismissible(
          key: Key(todo.id),
          direction: DismissDirection.endToStart,
          background: Container(
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.only(right: 24.0),
            color: Colors.red.withAlpha(204),
            child: const Icon(
              Icons.delete_outline_rounded,
              color: Colors.white,
              size: 28,
            ),
          ),
          onDismissed: (_) => deleteTodo(todo.id),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () => toggleStatus(todo.id),
              splashColor: getPriorityColor().withAlpha(25),
              highlightColor: getPriorityColor().withAlpha(13),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Priority indicator
                    Container(
                      width: 6,
                      height: 36,
                      decoration: BoxDecoration(
                        color:
                            todo.isCompleted
                                ? getPriorityColor().withAlpha(76)
                                : getPriorityColor(),
                        borderRadius: BorderRadius.circular(3),
                      ),
                    ),
                    const SizedBox(width: 12),
                    // Checkbox
                    Padding(
                      padding: const EdgeInsets.only(top: 4.0),
                      child: SizedBox(
                        width: 24,
                        height: 24,
                        child: Checkbox(
                          value: todo.isCompleted,
                          activeColor: colorScheme.primary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4),
                          ),
                          side: BorderSide(
                            color:
                                todo.isCompleted
                                    ? colorScheme.primary
                                    : colorScheme.outline.withAlpha(51),
                          ),
                          onChanged: (_) => toggleStatus(todo.id),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    // Task content
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Task title
                          Text(
                            todo.title,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight:
                                  todo.isCompleted
                                      ? FontWeight.normal
                                      : FontWeight.w600,
                              decoration:
                                  todo.isCompleted
                                      ? TextDecoration.lineThrough
                                      : TextDecoration.none,
                              color:
                                  todo.isCompleted
                                      ? colorScheme.onSurface.withAlpha(153)
                                      : colorScheme.onSurface,
                              letterSpacing: 0.1,
                            ),
                          ),
                          const SizedBox(height: 6),
                          // Task priority
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 3,
                                ),
                                decoration: BoxDecoration(
                                  color: getPriorityColor().withAlpha(31),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.flag_rounded,
                                      size: 12,
                                      color: getPriorityColor(),
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      getPriorityText(),
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                        color: getPriorityColor(),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    // Action buttons
                    if (onPriorityChanged != null)
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(
                              Icons.edit_outlined,
                              size: 20,
                              color: colorScheme.onSurface.withAlpha(102),
                            ),
                            splashRadius: 20,
                            onPressed: () => _showEditDialog(context),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showEditDialog(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (context) {
        return AddTaskDialog(
          todoToEdit: todo,
          onAddTask: (_, __) {}, // Not used in edit mode
          onUpdateTask: onUpdateTask,
        );
      },
    );
  }
}

import 'package:bluetick/models/todo.dart';
import 'package:bluetick/widgets/task_card.dart';
import 'package:flutter/material.dart';

class CompletedTasksScreen extends StatefulWidget {
  final List<Todo> completedTodos;
  final bool isDarkMode;
  final Function(String) toggleTodoStatus;
  final Function(String) deleteTodo;

  const CompletedTasksScreen({
    super.key,
    required this.completedTodos,
    required this.isDarkMode,
    required this.toggleTodoStatus,
    required this.deleteTodo,
  });

  @override
  State<CompletedTasksScreen> createState() => _CompletedTasksScreenState();
}

class _CompletedTasksScreenState extends State<CompletedTasksScreen> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        backgroundColor: colorScheme.surface,
        elevation: 0,
        title: Text(
          'Completed Tasks',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body:
          widget.completedTodos.isEmpty
              ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.check_circle_outline,
                      size: 80,
                      color: Colors.grey,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'No completed tasks yet',
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: colorScheme.onSurface.withAlpha(153),
                      ),
                    ),
                  ],
                ),
              )
              : ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: widget.completedTodos.length,
                itemBuilder: (context, index) {
                  final todo = widget.completedTodos[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: TaskCard(
                      todo: todo,
                      toggleStatus: widget.toggleTodoStatus,
                      deleteTodo: widget.deleteTodo,
                    ),
                  );
                },
              ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../models/todo.dart';
import '../widgets/task_card.dart';

class ScheduledTasksScreen extends StatefulWidget {
  final List<Todo> pendingTodos;
  final bool isDarkMode;
  final Function(String) toggleTodoStatus;
  final Function(String) deleteTodo;
  final Function(String, Priority) updatePriority;

  const ScheduledTasksScreen({
    super.key,
    required this.pendingTodos,
    required this.isDarkMode,
    required this.toggleTodoStatus,
    required this.deleteTodo,
    required this.updatePriority,
  });

  @override
  State<ScheduledTasksScreen> createState() => _ScheduledTasksScreenState();
}

class _ScheduledTasksScreenState extends State<ScheduledTasksScreen> {
  String searchQuery = '';

  List<Todo> get _filteredTodos {
    if (searchQuery.isEmpty) {
      return widget.pendingTodos;
    }

    return widget.pendingTodos
        .where(
          (todo) =>
              todo.title.toLowerCase().contains(searchQuery.toLowerCase()),
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // Sort tasks by priority (high first)
    final sortedTodos = List<Todo>.from(_filteredTodos)
      ..sort((a, b) => a.priority.index.compareTo(b.priority.index));

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        backgroundColor: colorScheme.surface,
        elevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness:
              widget.isDarkMode ? Brightness.light : Brightness.dark,
        ),
        title: Text(
          'Scheduled Tasks',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search tasks...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: colorScheme.surfaceContainerHighest.withAlpha(128),
                contentPadding: const EdgeInsets.symmetric(vertical: 12),
              ),
              onChanged: (value) {
                setState(() {
                  searchQuery = value;
                });
              },
            ),
          ),

          // Task list
          Expanded(
            child:
                sortedTodos.isEmpty
                    ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.schedule,
                            size: 80,
                            color: Colors.grey,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            searchQuery.isEmpty
                                ? 'No scheduled tasks'
                                : 'No tasks matching "$searchQuery"',
                            style: theme.textTheme.titleMedium?.copyWith(
                              color: colorScheme.onSurface.withAlpha(153),
                            ),
                          ),
                        ],
                      ),
                    )
                    : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: sortedTodos.length,
                      itemBuilder: (context, index) {
                        final todo = sortedTodos[index];
                        return TaskCard(
                          todo: todo,
                          toggleStatus: widget.toggleTodoStatus,
                          deleteTodo: widget.deleteTodo,
                          onPriorityChanged: (newPriority) {
                            widget.updatePriority(todo.id, newPriority);
                          },
                        );
                      },
                    ),
          ),
        ],
      ),
    );
  }
}

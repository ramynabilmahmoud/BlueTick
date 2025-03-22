import 'package:bluetick/models/todo.dart';
import 'package:bluetick/widgets/active_tasks_section.dart';
import 'package:bluetick/widgets/add_task_dialog.dart';
import 'package:bluetick/widgets/completed_tasks_section.dart';
import 'package:bluetick/widgets/empty_state_widget.dart';
import 'package:bluetick/widgets/todo_drawer.dart';
import 'package:bluetick/widgets/todo_header.dart';
import 'package:bluetick/widgets/todo_search_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TodoScreen extends StatefulWidget {
  final List<Todo> todos;
  final bool isDarkMode;
  final VoidCallback toggleTheme;
  final Function(String, Priority) addTodo;
  final Function(String) toggleTodoStatus;
  final Function(String) deleteTodo;
  final Function(String, Priority) updatePriority;
  final Function(String) setSearchQuery;
  final Function(String, String, Priority) updateTodo;
  final Function(BuildContext) navigateToScheduledTasks;
  final Function(BuildContext) navigateToCompletedTasks;

  const TodoScreen({
    super.key,
    required this.todos,
    required this.isDarkMode,
    required this.toggleTheme,
    required this.addTodo,
    required this.toggleTodoStatus,
    required this.deleteTodo,
    required this.updatePriority,
    required this.setSearchQuery,
    required this.updateTodo,
    required this.navigateToScheduledTasks,
    required this.navigateToCompletedTasks,
  });

  @override
  State<TodoScreen> createState() => _TodoScreenState();
}

class _TodoScreenState extends State<TodoScreen> {
  final controller = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // Sort todos by priority (high first)
    final incompleteTodos =
        widget.todos.where((todo) => !todo.isCompleted).toList()
          ..sort((a, b) => a.priority.index.compareTo(b.priority.index));

    final completedTodos =
        widget.todos.where((todo) => todo.isCompleted).toList();

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: _buildAppBar(colorScheme),
      drawer: TodoDrawer(
        isDarkMode: widget.isDarkMode,
        toggleTheme: widget.toggleTheme,
        navigateToScheduledTasks: widget.navigateToScheduledTasks,
        navigateToCompletedTasks: widget.navigateToCompletedTasks,
      ),
      floatingActionButton: _buildAddTaskButton(context, colorScheme),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // App Header
            TodoHeader(
              incompleteTodosCount: incompleteTodos.length,
              isDarkMode: widget.isDarkMode,
              toggleTheme: widget.toggleTheme,
            ),

            // Search Bar
            TodoSearchBar(
              controller: controller,
              colorScheme: colorScheme,
              onChanged: widget.setSearchQuery,
            ),

            // Active Tasks Section
            if (incompleteTodos.isNotEmpty)
              ActiveTasksSection(
                incompleteTodos: incompleteTodos,
                toggleTodoStatus: widget.toggleTodoStatus,
                deleteTodo: widget.deleteTodo,
                updatePriority: widget.updatePriority,
                updateTodo: widget.updateTodo,
              ),

            // Empty State
            if (widget.todos.isEmpty)
              EmptyStateWidget(theme: theme, colorScheme: colorScheme),

            // Completed Tasks Section
            if (completedTodos.isNotEmpty)
              CompletedTasksSection(
                completedTodos: completedTodos,
                toggleTodoStatus: widget.toggleTodoStatus,
                deleteTodo: widget.deleteTodo,
                updatePriority: widget.updatePriority,
                updateTodo: widget.updateTodo,
                colorScheme: colorScheme,
                theme: theme,
              ),

            // Bottom Space for FAB
            const SliverToBoxAdapter(child: SizedBox(height: 80)),
          ],
        ),
      ),
    );
  }

  PreferredSize _buildAppBar(ColorScheme colorScheme) {
    return PreferredSize(
      preferredSize: const Size.fromHeight(0),
      child: AppBar(
        backgroundColor: colorScheme.surface,
        elevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness:
              widget.isDarkMode ? Brightness.light : Brightness.dark,
        ),
      ),
    );
  }

  Widget _buildAddTaskButton(BuildContext context, ColorScheme colorScheme) {
    return FloatingActionButton.extended(
      onPressed: () {
        showDialog<void>(
          context: context,
          builder: (context) {
            return AddTaskDialog(
              onAddTask: (title, priority) {
                widget.addTodo(title, priority);
              },
            );
          },
        );
      },
      backgroundColor: colorScheme.primaryContainer,
      foregroundColor: colorScheme.onPrimaryContainer,
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      icon: const Icon(Icons.add),
      label: const Text('Add Task'),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../models/todo.dart';

class TodoScreen extends StatefulWidget {
  final List<Todo> todos;
  final bool isDarkMode;
  final VoidCallback toggleTheme;
  final Function(String) addTodo;
  final Function(String) toggleTodoStatus;
  final Function(String) deleteTodo;

  const TodoScreen({
    super.key,
    required this.todos,
    required this.isDarkMode,
    required this.toggleTheme,
    required this.addTodo,
    required this.toggleTodoStatus,
    required this.deleteTodo,
  });

  @override
  State<TodoScreen> createState() => _TodoScreenState();
}

class _TodoScreenState extends State<TodoScreen>
    with SingleTickerProviderStateMixin {
  final _controller = TextEditingController();
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    // Sort todos to show incomplete ones first
    final incompleteTodos =
        widget.todos.where((todo) => !todo.isCompleted).toList();
    final completedTodos =
        widget.todos.where((todo) => todo.isCompleted).toList();

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: PreferredSize(
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
      ),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // App Header
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'My Tasks',
                          style: theme.textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '${incompleteTodos.length} remaining',
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: colorScheme.onSurface.withAlpha(153),
                          ),
                        ),
                      ],
                    ),
                    IconButton(
                      icon: Icon(
                        widget.isDarkMode ? Icons.light_mode : Icons.dark_mode,
                        size: 28,
                      ),
                      onPressed: widget.toggleTheme,
                      tooltip:
                          widget.isDarkMode
                              ? 'Switch to light mode'
                              : 'Switch to dark mode',
                    ),
                  ],
                ),
              ),
            ),

            // Search Bar
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 24, 24, 8),
                child: TextField(
                  controller: _controller,
                  decoration: InputDecoration(
                    hintText: 'Add a new task...',
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.add_circle),
                      onPressed: () {
                        if (_controller.text.isNotEmpty) {
                          widget.addTodo(_controller.text);
                          _controller.clear();
                        }
                      },
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: colorScheme.surfaceContainerHighest.withAlpha(
                      128,
                    ),
                    contentPadding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  onSubmitted: (value) {
                    if (value.isNotEmpty) {
                      widget.addTodo(value);
                      _controller.clear();
                    }
                  },
                ),
              ),
            ),

            // Section Label - Active Tasks
            if (incompleteTodos.isNotEmpty)
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(24, 24, 24, 8),
                  child: Text(
                    'Active Tasks',
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: colorScheme.primary,
                    ),
                  ),
                ),
              ),

            // Active Tasks List
            if (incompleteTodos.isNotEmpty)
              SliverList(
                delegate: SliverChildBuilderDelegate((context, index) {
                  final todo = incompleteTodos[index];
                  return FadeTransition(
                    opacity: _animation,
                    child: SlideTransition(
                      position: Tween<Offset>(
                        begin: const Offset(0.5, 0),
                        end: Offset.zero,
                      ).animate(_animation),
                      child: TaskCard(
                        todo: todo,
                        toggleStatus: widget.toggleTodoStatus,
                        deleteTodo: widget.deleteTodo,
                        colorScheme: colorScheme,
                      ),
                    ),
                  );
                }, childCount: incompleteTodos.length),
              ),

            // Empty State
            if (widget.todos.isEmpty)
              SliverFillRemaining(
                hasScrollBody: false,
                child: Center(
                  child: FadeTransition(
                    opacity: _animation,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset(
                          'assets/images/empty_state.svg',
                          width: 180,
                          height: 180,
                        ),
                        const SizedBox(height: 24),
                        Text(
                          'All Clear!',
                          style: theme.textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Add a task to get started',
                          style: theme.textTheme.bodyLarge?.copyWith(
                            color: colorScheme.onSurface.withAlpha(153),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

            // Section Label - Completed Tasks
            if (completedTodos.isNotEmpty)
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(24, 24, 24, 8),
                  child: Row(
                    children: [
                      Text(
                        'Completed',
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: colorScheme.tertiary,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: colorScheme.tertiary,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          '${completedTodos.length}',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

            // Completed Tasks List
            if (completedTodos.isNotEmpty)
              SliverList(
                delegate: SliverChildBuilderDelegate((context, index) {
                  final todo = completedTodos[index];
                  return TaskCard(
                    todo: todo,
                    toggleStatus: widget.toggleTodoStatus,
                    deleteTodo: widget.deleteTodo,
                    colorScheme: colorScheme,
                    isCompleted: true,
                  );
                }, childCount: completedTodos.length),
              ),

            // Bottom Space for FAB
            const SliverToBoxAdapter(child: SizedBox(height: 80)),
          ],
        ),
      ),
    );
  }
}

// Extracted Task Card widget for better organization
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
    this.isCompleted = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
      child: Dismissible(
        key: Key(todo.id),
        background: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(
            color: colorScheme.errorContainer,
            borderRadius: BorderRadius.circular(16),
          ),
          alignment: Alignment.centerRight,
          child: Icon(
            Icons.delete_outline,
            color: colorScheme.onErrorContainer,
            size: 28,
          ),
        ),
        direction: DismissDirection.endToStart,
        onDismissed: (_) => deleteTodo(todo.id),
        child: Container(
          decoration: BoxDecoration(
            color:
                isCompleted
                    ? colorScheme.surfaceContainerHighest.withAlpha(128)
                    : colorScheme.surface,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha(8),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 8,
            ),
            leading: InkWell(
              onTap: () => toggleStatus(todo.id),
              customBorder: const CircleBorder(),
              child: Container(
                padding: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color:
                        isCompleted
                            ? colorScheme.tertiary
                            : colorScheme.primary,
                    width: 2,
                  ),
                ),
                child:
                    isCompleted
                        ? Icon(
                          Icons.check,
                          size: 18,
                          color: colorScheme.tertiary,
                        )
                        : const SizedBox(width: 18, height: 18),
              ),
            ),
            title: Text(
              todo.title,
              style: TextStyle(
                fontWeight: isCompleted ? FontWeight.normal : FontWeight.w500,
                decoration: isCompleted ? TextDecoration.lineThrough : null,
                color:
                    isCompleted
                        ? colorScheme.onSurface.withAlpha(153)
                        : colorScheme.onSurface,
              ),
            ),
            trailing: IconButton(
              icon: Icon(
                isCompleted ? Icons.refresh : Icons.check_circle_outline,
                color: isCompleted ? colorScheme.tertiary : colorScheme.primary,
              ),
              onPressed: () => toggleStatus(todo.id),
            ),
          ),
        ),
      ),
    );
  }
}

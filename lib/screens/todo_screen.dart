import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../models/todo.dart';
import '../widgets/add_task_dialog.dart';
import '../widgets/task_card.dart';

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

class _TodoScreenState extends State<TodoScreen>
    with SingleTickerProviderStateMixin {
  final controller = TextEditingController();
  late AnimationController animationController;
  late Animation<double> animation;

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    animation = CurvedAnimation(
      parent: animationController,
      curve: Curves.easeInOut,
    );
    animationController.forward();
  }

  @override
  void dispose() {
    animationController.dispose();
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
      drawer: Drawer(
        child: Container(
          color: colorScheme.surface,
          child: SafeArea(
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 30),
                  decoration: BoxDecoration(
                    color: colorScheme.primaryContainer,
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20),
                    ),
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset(
                          'assets/images/app_logo.svg',
                          width: 64,
                          height: 64,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Task Manager',
                          style: theme.textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Manage your tasks efficiently',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: colorScheme.onPrimaryContainer.withAlpha(
                              179,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                ListTile(
                  leading: Icon(Icons.home_rounded, color: colorScheme.primary),
                  title: const Text('Home'),
                  selected: true,
                  selectedTileColor: colorScheme.primaryContainer.withAlpha(77),
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(50),
                      bottomRight: Radius.circular(50),
                    ),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  leading: Icon(
                    Icons.schedule_rounded,
                    color: colorScheme.secondary,
                  ),
                  title: const Text('Scheduled Tasks'),
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(50),
                      bottomRight: Radius.circular(50),
                    ),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    widget.navigateToScheduledTasks(context);
                  },
                ),
                ListTile(
                  leading: Icon(
                    Icons.check_circle_rounded,
                    color: colorScheme.tertiary,
                  ),
                  title: const Text('Completed Tasks'),
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(50),
                      bottomRight: Radius.circular(50),
                    ),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    widget.navigateToCompletedTasks(context);
                  },
                ),
                const Spacer(),
                const Divider(),
                ListTile(
                  leading: Icon(
                    widget.isDarkMode
                        ? Icons.light_mode_rounded
                        : Icons.dark_mode_rounded,
                    color: widget.isDarkMode ? Colors.amber : Colors.indigo,
                  ),
                  title: Text(widget.isDarkMode ? 'Light Mode' : 'Dark Mode'),
                  onTap: () {
                    Navigator.pop(context);
                    widget.toggleTheme();
                  },
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: AnimatedScale(
        duration: const Duration(milliseconds: 200),
        scale: 1.0,
        child: FloatingActionButton.extended(
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
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          icon: const Icon(Icons.add),
          label: const Text('Add Task'),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
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
                    Row(
                      children: [
                        Builder(
                          builder:
                              (context) => IconButton(
                                icon: const Icon(Icons.menu),
                                onPressed: () {
                                  Scaffold.of(context).openDrawer();
                                },
                              ),
                        ),
                        IconButton(
                          icon: Icon(
                            widget.isDarkMode
                                ? Icons.light_mode
                                : Icons.dark_mode,
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
                  ],
                ),
              ),
            ),

            // Search Bar
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 24, 24, 8),
                child: TextField(
                  controller: controller,
                  decoration: InputDecoration(
                    hintText: 'Search tasks...',
                    prefixIcon: const Icon(Icons.search),
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
                  onChanged: (value) {
                    widget.setSearchQuery(value);
                  },
                ),
              ),
            ),

            // Section Label - Active Tasks
            if (incompleteTodos.isNotEmpty)
              SliverToBoxAdapter(
                child: Padding(
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
                ),
              ),

            // Active Tasks List
            if (incompleteTodos.isNotEmpty)
              SliverList(
                delegate: SliverChildBuilderDelegate((context, index) {
                  final todo = incompleteTodos[index];
                  return FadeTransition(
                    opacity: animation,
                    child: SlideTransition(
                      position: Tween<Offset>(
                        begin: const Offset(0.5, 0),
                        end: Offset.zero,
                      ).animate(animation),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 4,
                        ),
                        child: TaskCard(
                          todo: todo,
                          toggleStatus: widget.toggleTodoStatus,
                          deleteTodo: widget.deleteTodo,
                          onPriorityChanged: (newPriority) {
                            widget.updatePriority(todo.id, newPriority);
                          },
                          onUpdateTask: widget.updateTodo,
                        ),
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
                    opacity: animation,
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
              ),

            // Completed Tasks List
            if (completedTodos.isNotEmpty)
              SliverList(
                delegate: SliverChildBuilderDelegate((context, index) {
                  final todo = completedTodos[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 4,
                    ),
                    child: TaskCard(
                      todo: todo,
                      toggleStatus: widget.toggleTodoStatus,
                      deleteTodo: widget.deleteTodo,
                      onPriorityChanged: (newPriority) {
                        widget.updatePriority(todo.id, newPriority);
                      },
                      onUpdateTask: widget.updateTodo,
                    ),
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

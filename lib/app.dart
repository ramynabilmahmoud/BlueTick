import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'models/todo.dart';
import 'screens/completed_tasks_screen.dart';
import 'screens/scheduled_tasks_screen.dart';
import 'screens/splash_screen.dart';
import 'screens/todo_screen.dart';
import 'theme/app_theme.dart';

class TodoApp extends StatefulWidget {
  const TodoApp({super.key});

  @override
  State<TodoApp> createState() => TodoAppState();
}

class TodoAppState extends State<TodoApp> {
  // Dependencies

  // State
  bool isDarkMode = false;
  List<Todo> todos = [];
  bool isLoading = true;
  bool showSplash = true;
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    _loadAppResources();
  }

  Future<void> _loadAppResources() async {
    // Load both theme and todos in parallel
    await Future.wait([_loadThemePreference(), _loadTodos()]);

    // Set loading to false once all resources are loaded
    setState(() {
      isLoading = false;
    });
  }

  Future<void> _loadThemePreference() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      isDarkMode = prefs.getBool('isDarkMode') ?? false;
    });
  }

  Future<void> toggleTheme() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      isDarkMode = !isDarkMode;
      prefs.setBool('isDarkMode', isDarkMode);
    });
  }

  Future<void> _loadTodos() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final todoList = prefs.getStringList('todos') ?? [];

      final loadedTodos = <Todo>[];

      for (final todoJson in todoList) {
        try {
          final todo = Todo.fromJson(jsonDecode(todoJson));
          loadedTodos.add(todo);
        } catch (e) {
          // Log the error but continue loading other todos
          debugPrint('Error parsing todo: $e');
          // Could also add error tracking or notification here
        }
      }

      setState(() {
        todos = loadedTodos;
      });
    } catch (e) {
      debugPrint('Error loading todos: $e');
      // Fallback to empty list if all loading fails
      setState(() {
        todos = [];
      });
      // Show error dialog to user
      if (mounted) {
        showDialog(
          context: context,
          builder:
              (context) => AlertDialog(
                title: const Text('Data Error'),
                content: const Text(
                  'There was an error loading your tasks. Some data may have been lost.',
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('OK'),
                  ),
                ],
              ),
        );
      }
    }
  }

  Future<void> _saveTodos() async {
    final prefs = await SharedPreferences.getInstance();
    final todoList = todos.map((todo) => jsonEncode(todo.toJson())).toList();
    await prefs.setStringList('todos', todoList);
  }

  void _addTodo(String title, Priority priority) {
    final newTodo = Todo(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      priority: priority,
    );
    setState(() {
      todos.add(newTodo);
    });
    _saveTodos();
  }

  void _toggleTodoStatus(String id) {
    final todoIndex = todos.indexWhere((todo) => todo.id == id);
    if (todoIndex >= 0) {
      setState(() {
        todos[todoIndex].isCompleted = !todos[todoIndex].isCompleted;
      });
      _saveTodos();
    }
  }

  void deleteTodo(String id) {
    setState(() {
      todos.removeWhere((todo) => todo.id == id);
    });
    _saveTodos();
  }

  void _updateTodoPriority(String id, Priority priority) {
    final todoIndex = todos.indexWhere((todo) => todo.id == id);
    if (todoIndex >= 0) {
      setState(() {
        todos[todoIndex].priority = priority;
      });
      _saveTodos();
    }
  }

  void _setSearchQuery(String query) {
    setState(() {
      searchQuery = query;
    });
  }

  List<Todo> get filteredTodos {
    if (searchQuery.isEmpty) {
      return todos;
    }

    return todos
        .where(
          (todo) =>
              todo.title.toLowerCase().contains(searchQuery.toLowerCase()),
        )
        .toList();
  }

  void onSplashComplete() {
    setState(() {
      showSplash = false;
    });
  }

  void navigateToScheduledTasks(BuildContext context) {
    final pendingTodos = todos.where((todo) => !todo.isCompleted).toList();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (context) => ScheduledTasksScreen(
              pendingTodos: pendingTodos,
              isDarkMode: isDarkMode,
              toggleTodoStatus: _toggleTodoStatus,
              deleteTodo: deleteTodo,
              updatePriority: _updateTodoPriority,
            ),
      ),
    );
  }

  void navigateToCompletedTasks(BuildContext context) {
    final completedTodos = todos.where((todo) => todo.isCompleted).toList();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (context) => CompletedTasksScreen(
              completedTodos: completedTodos,
              isDarkMode: isDarkMode,
              toggleTodoStatus: _toggleTodoStatus,
              deleteTodo: deleteTodo,
            ),
      ),
    );
  }

  void updateTodo(String id, String newTitle, Priority newPriority) {
    final todoIndex = todos.indexWhere((todo) => todo.id == id);
    if (todoIndex >= 0) {
      setState(() {
        todos[todoIndex].title = newTitle;
        todos[todoIndex].priority = newPriority;
      });
      _saveTodos();
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.getLightTheme(),
      darkTheme: AppTheme.getDarkTheme(),
      themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,
      home:
          showSplash
              ? SplashScreen()
              : (isLoading
                  ? Scaffold(
                    body: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SvgPicture.asset(
                            'assets/images/app_logo.svg',
                            width: 100,
                            height: 100,
                          ),
                          const SizedBox(height: 24),
                          CircularProgressIndicator(
                            color:
                                isDarkMode
                                    ? const Color(0xFF9D94FF)
                                    : const Color(0xFF5E5AFF),
                          ),
                        ],
                      ),
                    ),
                  )
                  : TodoScreen(
                    todos: filteredTodos,
                    isDarkMode: isDarkMode,
                    toggleTheme: toggleTheme,
                    addTodo: _addTodo,
                    toggleTodoStatus: _toggleTodoStatus,
                    deleteTodo: deleteTodo,
                    updatePriority: _updateTodoPriority,
                    setSearchQuery: _setSearchQuery,
                    updateTodo: updateTodo,
                    navigateToScheduledTasks: navigateToScheduledTasks,
                    navigateToCompletedTasks: navigateToCompletedTasks,
                  )),
    );
  }
}

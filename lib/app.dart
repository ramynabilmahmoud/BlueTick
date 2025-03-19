import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'models/todo.dart';
import 'repositories/theme_repository.dart';
import 'repositories/todo_repository.dart';
import 'screens/splash_screen.dart';
import 'screens/todo_screen.dart';
import 'services/todo_service.dart';
import 'theme/app_theme.dart';

class TodoApp extends StatefulWidget {
  const TodoApp({super.key});

  @override
  State<TodoApp> createState() => TodoAppState();
}

class TodoAppState extends State<TodoApp> {
  // Dependencies
  final todoRepository = TodoRepository();
  final themeRepository = ThemeRepository();
  late TodoService todoService;

  // State
  bool isDarkMode = false;
  List<Todo> todos = [];
  bool isLoading = true;
  bool showSplash = true;

  @override
  void initState() {
    super.initState();
    todoService = TodoService(todoRepository);
    loadAppResources();
  }

  Future<void> loadAppResources() async {
    // Load both theme and todos in parallel
    await Future.wait([loadThemePreference(), loadTodos()]);

    // Set loading to false once all resources are loaded
    if (mounted) {
      setState(() {
        isLoading = false;
      });
    }

    // Note: We don't dismiss the splash screen here - it will
    // complete its animation first, then show the main screen
  }

  Future<void> loadThemePreference() async {
    final prefs = await SharedPreferences.getInstance();
    if (mounted) {
      setState(() {
        isDarkMode = prefs.getBool('isDarkMode') ?? false;
      });
    }
  }

  Future<void> toggleTheme() async {
    final prefs = await SharedPreferences.getInstance();
    if (mounted) {
      setState(() {
        isDarkMode = !isDarkMode;
        prefs.setBool('isDarkMode', isDarkMode);
      });
    }
  }

  Future<void> loadTodos() async {
    final prefs = await SharedPreferences.getInstance();
    final todoList = prefs.getStringList('todos') ?? [];

    if (mounted) {
      setState(() {
        todos =
            todoList
                .map((todoJson) => Todo.fromJson(jsonDecode(todoJson)))
                .toList();
      });
    }
  }

  Future<void> saveTodos() async {
    final prefs = await SharedPreferences.getInstance();
    final todoList = todos.map((todo) => jsonEncode(todo.toJson())).toList();
    await prefs.setStringList('todos', todoList);
  }

  void addTodo(String title) {
    final newTodo = Todo(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
    );
    if (mounted) {
      setState(() {
        todos.add(newTodo);
      });
    }
    saveTodos();
  }

  void toggleTodoStatus(String id) {
    final todoIndex = todos.indexWhere((todo) => todo.id == id);
    if (todoIndex >= 0) {
      if (mounted) {
        setState(() {
          todos[todoIndex].isCompleted = !todos[todoIndex].isCompleted;
        });
      }
      saveTodos();
    }
  }

  void deleteTodo(String id) {
    if (mounted) {
      setState(() {
        todos.removeWhere((todo) => todo.id == id);
      });
    }
    saveTodos();
  }

  void onSplashComplete() {
    if (mounted) {
      setState(() {
        showSplash = false;
      });
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
              ? SplashScreen(onAnimationComplete: onSplashComplete)
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
                    todos: todos,
                    isDarkMode: isDarkMode,
                    toggleTheme: toggleTheme,
                    addTodo: addTodo,
                    toggleTodoStatus: toggleTodoStatus,
                    deleteTodo: deleteTodo,
                  )),
    );
  }
}

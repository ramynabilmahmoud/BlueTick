import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/todo.dart';

class TodoRepository {
  static const String todosKey = 'todos';

  Future<List<Todo>> loadTodos() async {
    final prefs = await SharedPreferences.getInstance();
    final todoList = prefs.getStringList(todosKey) ?? [];

    return todoList
        .map((todoJson) => Todo.fromJson(jsonDecode(todoJson)))
        .toList();
  }

  Future<void> saveTodos(List<Todo> todos) async {
    final prefs = await SharedPreferences.getInstance();
    final todoList = todos.map((todo) => jsonEncode(todo.toJson())).toList();
    await prefs.setStringList(todosKey, todoList);
  }
}

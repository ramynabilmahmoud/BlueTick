import '../models/todo.dart';
import '../repositories/todo_repository.dart';

class TodoService {
  final TodoRepository repository;

  TodoService(this.repository);

  Future<List<Todo>> loadTodos() async {
    return await repository.loadTodos();
  }

  Future<void> addTodo(String title, List<Todo> currentTodos) async {
    final newTodo = Todo(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
    );
    final updatedTodos = [...currentTodos, newTodo];
    await repository.saveTodos(updatedTodos);
  }
}

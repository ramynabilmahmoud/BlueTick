enum Priority { high, medium, low }

class Todo {
  final String id;
  String title;
  bool isCompleted;
  Priority priority;

  Todo({
    required this.id,
    required this.title,
    this.isCompleted = false,
    this.priority = Priority.medium,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'isCompleted': isCompleted,
      'priority': priority.index,
    };
  }

  factory Todo.fromJson(Map<String, dynamic> json) {
    return Todo(
      id: json['id'],
      title: json['title'],
      isCompleted: json['isCompleted'],
      priority:
          json.containsKey('priority')
              ? Priority.values[json['priority']]
              : Priority.medium,
    );
  }
}

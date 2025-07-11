//list model to manage all list more easily
class TodoItem {
  String title;
  bool isDone;

  TodoItem({required this.title, this.isDone = false});

  Map<String, dynamic> toJson() => {
    'title': title,
    'isDone': isDone,
  };

  factory TodoItem.fromJson(Map<String, dynamic> json) => TodoItem(
    title: json['title'],
    isDone: json['isDone'] ?? false,
  );
}

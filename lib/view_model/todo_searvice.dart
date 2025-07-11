import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/todo_model.dart';


class TodoService {
  static const String _key = 'todo_list';


  // This function use to get data which is store in shared preference.
  Future<List<TodoItem>> getTodoList() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getStringList(_key) ?? [];
    return data.map((item) => TodoItem.fromJson(json.decode(item))).toList();
  }


  // This function use to save data in shared preference.
  Future<void> saveTodoList(List<TodoItem> list) async {
    final prefs = await SharedPreferences.getInstance();
    final data = list.map((item) => json.encode(item.toJson())).toList();
    await prefs.setStringList(_key, data);
  }
}

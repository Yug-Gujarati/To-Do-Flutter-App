import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../model/todo_model.dart';
import '../view_model/todo_searvice.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _controller = TextEditingController();
  final TodoService _todoService = TodoService();
  List<TodoItem> _todoList = [];
  bool _isAdding = false;

  @override
  void initState() {
    super.initState();
    _loadTodoList();
  }


  //lode saved data from todo service class called method
  Future<void> _loadTodoList() async {
    final list = await _todoService.getTodoList();
    setState(() {
      _todoList = list;
    });
  }

  Future<void> _saveTodoList() async {
    await _todoService.saveTodoList(_todoList);
  }


  //this function use to add new data in list and save in shared prefrence
  Future<void> _addTodo() async {
    final text = _controller.text.trim();
    if (text.isNotEmpty) {
      setState(() {
        _todoList.add(TodoItem(title: text));
        _controller.clear();
        _isAdding = false;
      });
      await _saveTodoList();
    }
  }


  //this function use to delete any data from specific location
  Future<void> _removeTodo(int index) async {
    setState(() {
      _todoList.removeAt(index);
    });
    await _saveTodoList();
  }


  //to mark function as done
  Future<void> _toggleDone(int index, bool? value) async {
    setState(() {
      _todoList[index].isDone = value ?? false;
    });
    await _saveTodoList();
  }


  //to edit function
  Future<void> _editTask(int index) async {
    final TextEditingController editController =
    TextEditingController(text: _todoList[index].title);

    await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Edit Task'),
        content: TextField(
          controller: editController,
          decoration: const InputDecoration(labelText: 'Task'),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Cancel
            },
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _todoList[index].title = editController.text.trim();
              });
              _saveTodoList();
              Navigator.pop(context);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }


  //Text field open to add new list data
  Widget _buildTaskInput() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4),
      child: TextField(
        controller: _controller,
        autofocus: true,
        onSubmitted: (_) => _addTodo(),
        decoration: InputDecoration(
          hintText: 'Enter a new task',
          suffixIcon: IconButton(
            icon: const Icon(Icons.check, color: Colors.green),
            onPressed: _addTodo,
          ),
          border: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.black)
          ),
          enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.black)
          ),
          disabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.black)
          ),
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.black)
          ),
        ),
      ),
    );
  }



  //this widget show list of task
  Widget _buildTaskList() {
    return Expanded(
      child: ReorderableListView(
        padding: EdgeInsets.zero,
        onReorder: (oldIndex, newIndex) async {
          setState(() {
            if (newIndex > oldIndex) newIndex -= 1;
            final item = _todoList.removeAt(oldIndex);
            _todoList.insert(newIndex, item);
          });
          await _saveTodoList();
        },
        children: List.generate(_todoList.length, (index) {
          final item = _todoList[index];
          return Container(
            decoration: BoxDecoration(
                color: Color(0xFFE8EAED),
                borderRadius: BorderRadius.circular(20)
            ),
            margin: EdgeInsets.only(top: 20.h),
            padding: EdgeInsets.only(top: 10.h, bottom: 10.h),
            key: ValueKey(item.title + index.toString()),
            child: Row(
              children: [
                Checkbox(
                  checkColor: Colors.white,
                  activeColor: Colors.green,
                  value: item.isDone,
                  onChanged: (value) => _toggleDone(index, value),
                ),
                Expanded(
                  child: Text(
                    item.title,
                    style: TextStyle(
                      fontSize: 16,
                      decoration: item.isDone
                          ? TextDecoration.lineThrough
                          : TextDecoration.none,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.edit, color: Colors.black),
                  onPressed: () => _editTask(index),
                ),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () => _removeTodo(index),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFFFFFF),
      appBar: AppBar(
        title: Text('My To-Do List', style: TextStyle(color: Colors.white, fontSize: 60.sp, fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: 	Colors.black,
      ),
      body: Padding(
        padding:  EdgeInsets.only(left: 40.w, right: 40.w),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
              child: Row(
                children: [
                  const Expanded(
                    child: Text(
                      'Tasks',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.add_circle, color: Colors.black38),
                    onPressed: () {
                      setState(() {
                        _isAdding = !_isAdding;
                      });
                    },
                  ),
                ],
              ),
            ),
            if (_isAdding) _buildTaskInput(),
            const SizedBox(height: 8),
            _buildTaskList(),
          ],
        ),
      ),
    );
  }
}

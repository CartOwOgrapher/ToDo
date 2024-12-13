import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'task_model.dart';

class TaskService {
  static const String _taskKey = 'tasks';

  Future<List<Task>> getTasks() async {
    final prefs = await SharedPreferences.getInstance();
    final String? tasksString = prefs.getString(_taskKey);
    if (tasksString == null) return [];
    List<dynamic> tasksList = jsonDecode(tasksString);
    return tasksList.map((task) => Task.fromMap(task)).toList();
  }

  Future<void> saveTasks(List<Task> tasks) async {
    final prefs = await SharedPreferences.getInstance();
    List<Map<String, dynamic>> tasksMap =
        tasks.map((task) => task.toMap()).toList();
    await prefs.setString(_taskKey, jsonEncode(tasksMap));
  }

  Future<void> addTask(Task task) async {
    List<Task> tasks = await getTasks();
    tasks.add(task);
    await saveTasks(tasks);
  }

  Future<void> removeTask(int index) async {
    List<Task> tasks = await getTasks();
    tasks.removeAt(index);
    await saveTasks(tasks);
  }

  Future<void> updateTask(int index, Task task) async {
    List<Task> tasks = await getTasks();
    tasks[index] = task;
    await saveTasks(tasks);
  }
}

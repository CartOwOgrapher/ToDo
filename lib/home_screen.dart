import 'package:flutter/material.dart';
import 'task_service.dart';
import 'task_model.dart';
import 'task_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Task> tasks = [];
  bool showCompleted = false;

  @override
  void initState() {
    super.initState();
    _loadTasks();
  }

  _loadTasks() async {
    final taskService = TaskService();
    List<Task> loadedTasks = await taskService.getTasks();
    setState(() {
      tasks = loadedTasks;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Todo')),
      body: Column(
        children: [
          Row(
            children: [
              TextButton(
                onPressed: () {
                  setState(() {
                    showCompleted = false;
                  });
                },
                child: Text('Текущие'),
              ),
              TextButton(
                onPressed: () {
                  setState(() {
                    showCompleted = true;
                  });
                },
                child: Text('Выполненные'),
              ),
            ],
          ),
          Expanded(
            child: tasks.isEmpty
                ? Center(child: Text('Нет запланированных задач'))
                : ListView.builder(
                    itemCount: tasks.length,
                    itemBuilder: (context, index) {
                      final task = tasks[index];
                      if (showCompleted == task.isCompleted) {
                        return ListTile(
                          title: Text(task.title),
                          subtitle: Text(task.description),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: Icon(Icons.check,
                                    color: task.isCompleted
                                        ? Colors.green
                                        : Colors.grey),
                                onPressed: () async {
                                  final taskService = TaskService();
                                  task.isCompleted = !task.isCompleted;
                                  await taskService.updateTask(index, task);
                                  setState(() {});
                                },
                              ),
                              IconButton(
                                icon: Icon(Icons.edit),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => TaskScreen(
                                        task: task,
                                        index: index,
                                      ),
                                    ),
                                  ).then((_) => _loadTasks());
                                },
                              ),
                            ],
                          ),
                        );
                      }
                      return Container();
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => TaskScreen(),
            ),
          ).then((_) => _loadTasks());
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

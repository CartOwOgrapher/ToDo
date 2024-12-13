import 'package:flutter/material.dart';
import 'task_service.dart';
import 'task_model.dart';

class TaskScreen extends StatefulWidget {
  final Task? task;
  final int? index;

  TaskScreen({this.task, this.index});

  @override
  _TaskScreenState createState() => _TaskScreenState();
}

class _TaskScreenState extends State<TaskScreen> {
  late TextEditingController titleController;
  late TextEditingController descriptionController;

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController(text: widget.task?.title ?? '');
    descriptionController =
        TextEditingController(text: widget.task?.description ?? '');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            widget.task == null ? 'Добавить задачу' : 'Редактировать задачу'),
        actions: widget.task != null
            ? [
                IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () async {
                    final taskService = TaskService();
                    await taskService.removeTask(widget.index!);
                    Navigator.pop(context);
                  },
                ),
              ]
            : [],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: titleController,
              decoration: InputDecoration(labelText: 'Название'),
            ),
            TextField(
              controller: descriptionController,
              decoration: InputDecoration(labelText: 'Описание'),
            ),
            ElevatedButton(
              onPressed: () async {
                final taskService = TaskService();
                final task = Task(
                  title: titleController.text,
                  description: descriptionController.text,
                  isCompleted: widget.task?.isCompleted ?? false,
                );
                if (widget.task == null) {
                  await taskService.addTask(task);
                } else {
                  await taskService.updateTask(widget.index!, task);
                }
                Navigator.pop(context);
              },
              child: Text('Сохранить'),
            ),
          ],
        ),
      ),
    );
  }
}

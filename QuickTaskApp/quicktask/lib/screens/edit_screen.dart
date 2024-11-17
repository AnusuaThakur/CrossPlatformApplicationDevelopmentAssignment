import 'package:flutter/material.dart';
import '../services/task_service.dart';
import '../models/task_model.dart';

class EditTaskScreen extends StatefulWidget {
  final Task task;  // Task to be edited

  EditTaskScreen({required this.task});

  @override
  _EditTaskScreenState createState() => _EditTaskScreenState();
}

class _EditTaskScreenState extends State<EditTaskScreen> {
  final TextEditingController _titleController = TextEditingController();
  DateTime? _dueDate;
  bool _isCompleted = false;

  @override
  void initState() {
    super.initState();
    // Pre-populate fields with the existing task data
    _titleController.text = widget.task.title ?? '';
    _dueDate = widget.task.dueDate;
    _isCompleted = widget.task.isCompleted;
  }

  void _saveTask() async {
    final task = Task(
      title: _titleController.text,
      dueDate: _dueDate,
      isCompleted: _isCompleted,
    );

    try {
      // Update the task using the TaskService
      await TaskService().updateTask(
        widget.task.objectId.toString(),
        task.isCompleted,
        task.title ?? '',
        task.dueDate,
      );
      // Pop the screen and return the updated task
      Navigator.pop(context, task);
    } catch (e) {
      // Show error message if something goes wrong
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error updating task: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Edit Task")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Task Title
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                labelText: "Task Title",
              ),
            ),
            SizedBox(height: 20),

            // Due Date Selection
            Row(
              children: [
                Text(_dueDate == null
                    ? "Select Due Date"
                    : "Due: ${_dueDate?.toLocal().toString().split(' ')[0]}"),
                IconButton(
                  icon: Icon(Icons.calendar_today),
                  onPressed: () async {
                    // Show date picker for due date
                    DateTime? selectedDate = await showDatePicker(
                      context: context,
                      initialDate: _dueDate ?? DateTime.now(),
                      firstDate: DateTime(2020),
                      lastDate: DateTime(2100),
                    );
                    if (selectedDate != null) {
                      setState(() {
                        _dueDate = selectedDate;
                      });
                    }
                  },
                ),
              ],
            ),
            SizedBox(height: 20),

            // Task Completion Checkbox
            Row(
              children: [
                Checkbox(
                  value: _isCompleted,
                  onChanged: (value) {
                    setState(() {
                      _isCompleted = value ?? false;
                    });
                  },
                ),
                Text('Completed'),
              ],
            ),
            SizedBox(height: 20),

            // Save Button
            ElevatedButton(
              onPressed: _saveTask,
              child: Text("Save Changes"),
            ),
          ],
        ),
      ),
    );
  }
}

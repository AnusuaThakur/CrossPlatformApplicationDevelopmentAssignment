import 'package:flutter/material.dart';
import '../services/task_service.dart';
import '../models/task_model.dart';

class AddTaskScreen extends StatefulWidget {
  @override
  _AddTaskScreenState createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final TextEditingController _titleController = TextEditingController();
  DateTime? _dueDate;

  void _saveTask() async {
    DateTime dueDateUtc = _dueDate!.toUtc(); 
 

    final task = Task(
      title: _titleController.text,
      dueDate: dueDateUtc,
      isCompleted: false,
    );
    
    await TaskService().addTask(task.title.toString(),task.dueDate);
    Navigator.pop(context);  // Go back to the home screen
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Add Task")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(labelText: "Task Title"),
            ),
            SizedBox(height: 20),
            Row(
              children: [
                Text(_dueDate == null
                    ? "Select Due Date"
                    : "Due: ${_dueDate?.toLocal().toString().split(' ')[0]}"),
                IconButton(
                  icon: Icon(Icons.calendar_today),
                  onPressed: () async {
                    DateTime? selectedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
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
            ElevatedButton(
              onPressed: _saveTask,
              child: Text("Save Task"),
            ),
          ],
        ),
      ),
    );
  }
}

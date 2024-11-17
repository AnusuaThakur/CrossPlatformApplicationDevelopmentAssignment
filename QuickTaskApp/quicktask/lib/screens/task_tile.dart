import 'package:flutter/material.dart';
import '../models/task_model.dart';  // Assuming Task is your model for tasks

class TaskTile extends StatelessWidget {
  final Task task;
  final Function onStatusChanged;
  final Function onDelete;
  final Function onEdit;

  TaskTile({required this.task, required this.onStatusChanged, required this.onDelete, required this.onEdit});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(task.title ?? "Untitled Task"),
      subtitle: Text('Due: ${task.dueDate?.toLocal().toString().split(' ')[0]}'),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
        Checkbox(
        value: task.isCompleted,
        onChanged: (bool? value) {
          if (value != null) {
            onStatusChanged();  // Trigger task completion toggle
          }
        },
      ),
      IconButton(
            icon: Icon(Icons.edit, color: Colors.blue),  
            onPressed: () => onEdit(),  // Call edit function
          ),
      IconButton(
            icon: Icon(Icons.delete, color: Colors.red),  // Trash can icon
            onPressed: () => onDelete(),  // Call delete function
          ),
        ],
      ),
      onTap: () {
        
      },
    );
  }
}

import 'package:flutter/material.dart';
import '../services/task_service.dart';  // Import your task service for CRUD operations
import '../models/task_model.dart';     // Import your Task model
import 'add_task_screen.dart';         // For adding a new task
import 'login_screen.dart';            // For logging out and going back to login
import 'task_tile.dart';               // Custom widget to display individual tasks
import 'edit_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Task list variable
  List<Task> _tasks =[];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadTasks();
  }

  // Fetch tasks from backend
  Future<void> _loadTasks() async {
    try {
      // Get tasks using your TaskService (adjust as per your service)
       List<Task> tasks = await TaskService().getTasks();
       setState(() {
        _tasks=tasks;
        _isLoading = false;
    });
     if (_tasks.isEmpty) {
        _navigateToAddTaskScreen();
      }
    } catch (e) {
      print("Error loading tasks: $e");
      _tasks = [];
    }
    setState(() {
      _isLoading = false;
    });
  }

  void _navigateToAddTaskScreen() {
    Future.delayed(Duration.zero, () {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => AddTaskScreen()),
      ).then((_) {
        _loadTasks(); // Reload tasks after returning from AddTaskScreen
      });
    });
  }

  // Handle user logout
  Future<void> _logout() async {
    await TaskService().logout();  // Call your logout function
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()), // Navigate back to Login
    );
  }

   // Delete a task
  Future<void> _deleteTask(Task task) async {
    try {
      await TaskService().deleteTask(task.objectId.toString());  // Delete task from backend
      setState(() {
        _tasks.remove(task);  // Remove the task from the local list
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Task deleted successfully")),
      );
    } catch (e) {
      print("Error deleting task: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to delete task")),
      );
    }
  }

  // Handle task completion toggle
Future<void> _toggleTaskCompletion(Task task) async {
  // Toggle the completion status
  setState(() {
    task.isCompleted = !task.isCompleted;
  });
  
  // Update task completion in the backend
  await TaskService().updateTask(task.objectId.toString(), task.isCompleted,task.title.toString(),task.dueDate); 

   ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        task.isCompleted ? "Task marked as complete!" : "Task marked as incomplete.",
        style: TextStyle(color: Colors.white),  // Optional: Customize text color
      ),
      duration: Duration(seconds: 3),  // Duration for which Snackbar is visible
      backgroundColor: task.isCompleted ? Colors.green : const Color.fromARGB(255, 117, 78, 20),  // Success or warning color
    ),
  );
}

// Navigate to edit task screen
Future<void> _editTask(Task task) async {
    final updatedTask = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => EditTaskScreen(task: task)),
    ).then((_) {
            _loadTasks();  // Reload tasks to include the new task
          });

    if (updatedTask != null) {
      setState(() {
        // Update the task in the list with the new values
        int index = _tasks.indexWhere((t) => t.objectId == updatedTask.objectId);
        if (index != -1) {
          _tasks[index] = updatedTask;  // Replace the old task with the updated one
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Task Manager'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout,size: 30.0,),
            onPressed: _logout, // Logout button
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _isLoading
            ? Center(child: CircularProgressIndicator()) // Show loading indicator while fetching tasks
            : _tasks.isEmpty
                ? Center(child: Text("No tasks yet! Add your first task.")) // Empty state
                : ListView.builder(
                    itemCount: _tasks.length,
                    itemBuilder: (context, index) {
                      final task = _tasks[index];
                      return TaskTile(
                        task: task,
                        onStatusChanged: () => _toggleTaskCompletion(task), // Toggle task completion status
                        onDelete: () => _deleteTask(task),
                        onEdit: ()=> _editTask(task),
                      );
                    },
                  ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to Add Task screen
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddTaskScreen()),
          ).then((_) {
            // When returning from AddTaskScreen, reload the tasks
            _loadTasks();  // Reload tasks to include the new task
          });
        },
        child: Icon(Icons.add),
        tooltip: 'Add Task',
      ),
    );
  }
}

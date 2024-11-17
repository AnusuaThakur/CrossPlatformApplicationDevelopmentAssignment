import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';
import 'package:quicktask/models/task_model.dart';
import 'auth_service.dart';

class TaskService {
  static const String _taskClass = 'Task'; // Your class name in Back4App

  // Fetch all tasks
  Future<List<Task>> getTasks() async {
    final ParseUser? user = await AuthService().getCurrentUser();
  if (user == null) {
    print('No user is currently logged in.');
    return [];
  }
    final QueryBuilder<ParseObject> query = QueryBuilder<ParseObject>(ParseObject(_taskClass));
    query.whereEqualTo('userId', user.objectId);
    query.setLimit(100);
    query.orderByDescending('createdAt');  // Order tasks by creation date

    final ParseResponse response = await query.query();

    if (response.success) {
      List<Task> tasks = [];
    for (var parseObject in response.results!) {
      tasks.add(Task.fromParse(parseObject as ParseObject));
    } 
    return tasks;
  }
    else {
      print('Error fetching tasks: ${response.error?.message}');
      return [];
    }
  }

  // Add a task
  Future<void> addTask(String title, DateTime? dueDate) async {

    final ParseUser? user = await AuthService().getCurrentUser();
    if (user == null) {
    print('No user is currently logged in.');
    return;
  }
    final parseTask = ParseObject(_taskClass)
      ..set('title', title)
      ..set('dueDate', dueDate)
      ..set('isCompleted', false)
       ..set('userId', user.objectId);

    final ParseResponse response = await parseTask.save();
    
    if (response.success) {
      print('Task added successfully');
    } else {
      print('Error adding task: ${response.error?.message}');
    }
  }

  // Update task completion
  Future<void> updateTask(String taskId, bool isCompleted,String title, DateTime? dueDate) async {
    final parseTask = ParseObject(_taskClass)
      ..objectId = taskId // Set objectId to identify the task to update
      ..set('isCompleted', isCompleted)
      ..set('dueDate', dueDate)
      ..set('title', title);

    final ParseResponse response = await parseTask.save();

    if (response.success) {
      print('Task updated successfully');
    } else {
      print('Error updating task: ${response.error?.message}');
    }
  }

  // Delete task
  Future<void> deleteTask(String taskId) async {
    final parseTask = ParseObject(_taskClass)..objectId = taskId;

    final ParseResponse response = await parseTask.delete();

    if (response.success) {
      print('Task deleted successfully');
    } else {
      print('Error deleting task: ${response.error?.message}');
    }
  }

  Future<void> logout() async {
    try {
      ParseUser? user = await ParseUser.currentUser();
      if (user != null) {
        await user.logout();  // Log the user out
        print('User logged out successfully');
      } else {
        print('No user is currently logged in.');
      }
    } catch (e) {
      print('Error logging out: $e');
    }
  }
}

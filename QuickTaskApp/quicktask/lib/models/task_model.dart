import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';

class Task {
  String? objectId;
  String? title;
  DateTime? dueDate;
  bool isCompleted;
  String? userId;

  Task({this.objectId, required this.title, this.dueDate, required this.isCompleted,this.userId});

  factory Task.fromParse(ParseObject parseObject) {
    return Task(
      objectId: parseObject.objectId,
      title: parseObject.get<String>('title'),
      dueDate: parseObject.get<DateTime>('dueDate'),
      isCompleted: parseObject.get<bool>('isCompleted') ?? false,
      userId: parseObject.get<String>('userId'),
    );
  }
}

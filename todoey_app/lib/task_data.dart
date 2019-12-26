import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:todoey_app/task.dart';

class TaskData extends ChangeNotifier {
  List<Task> _taskList = [
    Task(task: 'Buy a bread'),
    Task(task: 'Go to gym'),
    Task(task: 'Credit Card bill payment'),
  ];

  UnmodifiableListView get taskList {
    return UnmodifiableListView(_taskList);
  }

  int getTaskCount() {
    return _taskList.length;
  }

  void addTask(String newTaskValue) {
    _taskList.add(Task(task: newTaskValue));
    notifyListeners();
  }

  void onLongPressTask(Task task) {
    _taskList.remove(task);
    notifyListeners();
  }
}

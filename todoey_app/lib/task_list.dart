import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todoey_app/task_data.dart';

class TaskList extends StatefulWidget {
  @override
  _TaskListState createState() => _TaskListState();
}

class _TaskListState extends State<TaskList> {
  @override
  Widget build(BuildContext context) {
    return Consumer<TaskData>(
      builder: (context, taskData, child) {
        return ListView.builder(
          itemCount: taskData.taskList.length,
          itemBuilder: (BuildContext context, int index) {
            final tasks = taskData.taskList[index];
            return ListTile(
              onLongPress: () {
                taskData.onLongPressTask(tasks);
              },
              title: Text(
                tasks.task,
                style: TextStyle(
                  decoration: tasks.isDone ? TextDecoration.lineThrough : null,
                  decorationStyle: TextDecorationStyle.double,
                ),
              ),
              trailing: Checkbox(
                value: tasks.isDone,
                onChanged: (newValue) {
                  setState(() {
                    tasks.toggleIsDone();
                  });
                },
              ),
            );
          },
        );
      },
    );
  }
}

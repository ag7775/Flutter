import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../task_data.dart';

class AddTask extends StatefulWidget {
  @override
  _AddTaskState createState() => _AddTaskState();
}

class _AddTaskState extends State<AddTask> {
  String newTextValue;
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xff757575),
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(40.0),
              topRight: Radius.circular(40.0),
            )),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Text(
                'New Task',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.lightBlue,
                  fontSize: 20.0,
                  letterSpacing: 1.0,
                ),
              ),
              TextField(
                textCapitalization: TextCapitalization.sentences,
                autofocus: true,
                onChanged: (newText) {
                  newTextValue = newText;
                },
              ),
              SizedBox(
                height: 20.0,
              ),
              FlatButton(
                padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                color: Colors.lightBlue,
                child: Text(
                  'Add',
                  style: TextStyle(color: Colors.white, fontSize: 20.0),
                ),
                onPressed: () {
                  if (newTextValue != null)
                    Provider.of<TaskData>(context).addTask(newTextValue);
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

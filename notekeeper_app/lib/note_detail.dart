import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:notekeeper_app/models/notes.dart';
import 'package:notekeeper_app/utils/database_helper.dart';

class NoteDetail extends StatefulWidget {
  final String title;
  final Note note;
  NoteDetail(this.note, this.title);
  @override
  State<StatefulWidget> createState() {
    return NoteDetailState(this.note, this.title);
  }
}

class NoteDetailState extends State<NoteDetail> {
  String title;
  Note note;
  DatabaseHelper helper = new DatabaseHelper();

  NoteDetailState(this.note, this.title);

  static var _priorities = ["High", "Low"];
  TextEditingController titleEditingController = new TextEditingController();
  TextEditingController descEditingController = new TextEditingController();
  @override
  Widget build(BuildContext context) {
    TextStyle textStyle = Theme.of(context).textTheme.title;
    titleEditingController.text = note.title;
    descEditingController.text = note.desc;

    return WillPopScope(
      onWillPop: () {
        moveToLastScreen();
      },
      child: new Scaffold(
        appBar: new AppBar(
          title: new Text(title),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              moveToLastScreen();
            },
          ),
        ),
        body: new Padding(
          padding: EdgeInsets.only(top: 15.0, left: 10.0, right: 10.0),
          child: new ListView(
            children: <Widget>[
              ListTile(
                title: new DropdownButton(
                  items: _priorities.map((String d) {
                    return DropdownMenuItem<String>(
                      value: d,
                      child: new Text(d),
                    );
                  }).toList(),
                  style: Theme.of(context).textTheme.title,
                  value: convertPriorityAsString(note.priority),
                  onChanged: (value) {
                    setState(() {
                      convertPriorityAsInt(value);
                    });
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                child: TextField(
                  controller: titleEditingController,
                  style: Theme.of(context).textTheme.title,
                  onChanged: (value) {
                    updateTitle();
                  },
                  textCapitalization: TextCapitalization.sentences,
                  decoration: InputDecoration(
                      labelStyle: textStyle,
                      labelText: "Title",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      )),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                child: TextField(
                  controller: descEditingController,
                  style: Theme.of(context).textTheme.title,
                  onChanged: (value) {
                    updateDescp();
                  },
                  textCapitalization: TextCapitalization.sentences,
                  decoration: InputDecoration(
                      labelStyle: textStyle,
                      labelText: "Description",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      )),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                child: new Row(
                  children: <Widget>[
                    Expanded(
                      child: new RaisedButton(
                        color: Theme.of(context).primaryColorDark,
                        textColor: Colors.white,
                        child: Text(
                          "Save",
                          textScaleFactor: 1.25,
                        ),
                        onPressed: () {
                          setState(() {
                            _save();
                          });
                        },
                      ),
                    ),
                    SizedBox(
                      width: 5.0,
                    ),
                    Expanded(
                      child: new RaisedButton(
                        textColor: Colors.white,
                        color: Theme.of(context).primaryColorDark,
                        child: Text(
                          "Delete",
                          textScaleFactor: 1.25,
                        ),
                        onPressed: () {
                          setState(() {
                            _delete();
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void convertPriorityAsInt(String value) {
    switch (value) {
      case "High":
        note.priority = 2;
        break;
      case "Low":
        note.priority = 1;
        break;
    }
  }

  String convertPriorityAsString(int value) {
    switch (value) {
      case 2:
        return "High";
        break;
      case 1:
        return "Low";
        break;
    }
    return "Low";
  }

  void updateTitle() {
    note.title = titleEditingController.text;
  }

  void updateDescp() {
    note.desc = descEditingController.text;
  }

  void _save() async {
    moveToLastScreen();
    int result;
    note.date = DateFormat.yMMMd().format(DateTime.now());
    if (note.id != null) {
      result = await helper.updateNote(note);
    } else {
      result = await helper.insertNote(note);
    }
    if (result != 0) {
      _showDialog("Status", "Notes Saved Successfully");
    } else {
      _showDialog("Status", "Problem Saving Note");
    }
  }

  void _delete() async {
    moveToLastScreen();
    if (note.id == null) {
      _showDialog("Status", "No Note Deleted");
      return;
    }
    int result = await helper.deleteNote(note.id);
    if (result != 0) {
      _showDialog("Status", "Note Deleted");
    } else {
      _showDialog("Status", "Problem Deleting Note");
    }
  }

  void _showDialog(String s, String t) {
    AlertDialog alertDialog = AlertDialog(
      title: Text(s),
      content: Text(t),
    );
    // showDialog(
    // 		context: context,
    // 		builder: (_) => alertDialog
    // );
  }

  void moveToLastScreen() {
    Navigator.pop(context, true);
  }
}

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:notekeeper_app/utils/database_helper.dart';
import 'package:sqflite/sqflite.dart';

import 'models/notes.dart';
import 'note_detail.dart';

class NoteList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return NoteListState();
  }
}

class NoteListState extends State<NoteList> {
  DatabaseHelper databaseHelper = new DatabaseHelper();
  List<Note> listNote;
  int count = 0;

  @override
  Widget build(BuildContext context) {
    if (listNote == null) {
      listNote = new List<Note>();
      updateListView();
    }
    return new Scaffold(
      appBar: new AppBar(
        backgroundColor: Colors.deepPurple,
        title: new Text("Notes"),
      ),
      body: getNoteListView(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          navigateToDetail(Note("", "", 2), "Add Note");
        },
        child: new Icon(
          Icons.add,
          color: Colors.white,
          size: 30.0,
        ),
      ),
    );
  }

  ListView getNoteListView() {
    return ListView.builder(
      itemCount: count,
      itemBuilder: (context, i) => new Card(
        elevation: 2.0,
        color: Colors.white,
        child: ListTile(
          leading: new CircleAvatar(
            backgroundColor: getPriorityColor(this.listNote[i].priority),
            child: getPriorityIcon(this.listNote[i].priority),
          ),
          title: new Text(
            this.listNote[i].title,
            style: new TextStyle(fontSize: 18.0, fontWeight: FontWeight.w400),
          ),
          subtitle: new Text(this.listNote[i].date),
          trailing: GestureDetector(
            child: new Icon(
              Icons.delete,
              color: Colors.grey,
            ),
            onTap: () {
              _delete(context, this.listNote[i]);
            },
          ),
          onTap: () {
            navigateToDetail(this.listNote[i], "Edit Note");
          },
        ),
      ),
    );
  }

  void navigateToDetail(Note note, String title) async {
    bool res =
        await Navigator.push(context, MaterialPageRoute(builder: (context) {
      return NoteDetail(note, title);
    }));
    if (res) {
      updateListView();
    }
  }

  Color getPriorityColor(int priority) {
    switch (priority) {
      case 1:
        return Colors.yellow;
        break;
      case 2:
        return Colors.red;
        break;
      default:
        return Colors.yellow;
    }
  }

  Icon getPriorityIcon(int priority) {
    switch (priority) {
      case 1:
        return Icon(
          FontAwesomeIcons.lightbulb,
          color: Colors.white,
        );
        break;
      case 2:
        return Icon(
          FontAwesomeIcons.solidLightbulb,
          color: Colors.white,
        );
        break;
      default:
        return Icon(FontAwesomeIcons.lightbulb);
    }
  }

  void _delete(BuildContext context, Note note) async {
    int result = await databaseHelper.deleteNote(note.id);
    if (result != 0) {
      _showSnackBar(context, "Note Deleted Succefully");
    }
    updateListView();
  }

  void _showSnackBar(BuildContext context, String message) {
    final snackbar = SnackBar(
      content: Text(message),
    );
    Scaffold.of(context).showSnackBar(snackbar);
  }

  void updateListView() {
    final Future<Database> futureDatabase = databaseHelper.initializeDatabase();
    futureDatabase.then((database) {
      Future<List<Note>> list = databaseHelper.getListFromMap();
      list.then((noteList) {
        setState(() {
          this.listNote = noteList;
          this.count = noteList.length;
        });
      });
    });
  }
}

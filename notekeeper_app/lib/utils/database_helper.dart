import 'dart:async';
import 'dart:io';

import 'package:notekeeper_app/models/notes.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static DatabaseHelper _helper;
  static Database _database;

  DatabaseHelper._createInstance();

  factory DatabaseHelper() {
    if (_helper == null) _helper = DatabaseHelper._createInstance();
    return _helper;
  }

  String collId = 'id';
  String table = 'noteTable';
  String collTitle = "title";
  String collDesc = 'description';
  String collPriority = 'priority';
  String collDate = 'date';
  Future<Database> initializeDatabase() async {
    Directory directory = await getApplicationDocumentsDirectory();

    String path = directory.path + 'notes.db';
    var notesDatabase = openDatabase(path, version: 1, onCreate: _createDb);
    return notesDatabase;
  }

  void _createDb(Database db, int version) async {
    await db.execute(
        'CREATE TABLE $table($collId INTEGER PRIMARY KEY AUTOINCREMENT,'
        '$collTitle TEXT, $collDesc TEXT,$collPriority INTEGER,$collDate TEXT)');
  }

  Future<Database> get database async {
    if (_database == null) {
      _database = await initializeDatabase();
    }
    return _database;
  }

  Future<List<Map<String, dynamic>>> getNoteList() async {
    Database db = await this.database;
    var result = await db.query(table, orderBy: '$collPriority ASC');
    return result;
  }

  Future<int> insertNote(Note note) async {
    Database db = await this.database;
    var result = await db.insert(table, note.toMap());
    return result;
  }

  Future<int> updateNote(Note note) async {
    Database db = await this.database;
    var result = await db
        .update(table, note.toMap(), where: '$collId=?', whereArgs: [note.id]);
    return result;
  }

  Future<int> deleteNote(int id) async {
    Database db = await this.database;
    var result = await db.rawDelete('DELETE FROM $table WHERE $collId = $id');
    return result;
  }

  Future<int> getCount() async {
    Database db = await this.database;
    List<Map<String, dynamic>> x =
        await db.rawQuery('SELECT COUNT(*) FROM $table');
    int result = Sqflite.firstIntValue(x);
    return result;
  }

  Future<List<Note>> getListFromMap() async {
    var mapList = await getNoteList();
    int count = mapList.length;
    List<Note> list = new List<Note>();
    for (int i = 0; i < count; i++) {
      list.add(Note.fromMap(mapList[i]));
    }

    return list;
  }
}

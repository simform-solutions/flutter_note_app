import 'package:notes_app/Classes/note.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class DatabaseHelper {
  String tableName = 'TableNotes';
  String id = 'ID';
  String title = 'Title';
  String desc = 'Description';
  static DatabaseHelper databaseHelper;
  static Database _database;
  DatabaseHelper._createInstance();
  factory DatabaseHelper() {
    if (databaseHelper == null) {
      databaseHelper = DatabaseHelper._createInstance();
    }
    return databaseHelper;
  }

  Future<Database> get database async {
    if (_database == null) {
      _database = await initlizeDatabase();
    }
    return _database;
  }

  Future<Database> initlizeDatabase() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = directory.path + 'notes.db';
    var noteDatabase =
        await openDatabase(path, version: 1, onCreate: _createDB);
    return noteDatabase;
  }

  void _createDB(Database db, int newVesrion) async {
    await db.execute(
        'CREATE TABLE $tableName($id INTEGER PRIMARY KEY AUTOINCREMENT, $title TEXT, $desc TEXT)');
  }

  Future<List<Map<String, dynamic>>> getNoteMapList() async {
    Database db = await this.database;
    var result = await db.query(tableName, orderBy: '$id ASC');
    return result;
  }

  Future<List<Note>> getNoteList() async {
    var noteMapList = await getNoteMapList();
    int count = noteMapList.length;

    List<Note> noteList = List<Note>();
    for (int i = 0; i < count; i++) {
      Note note = Note(
          title: noteMapList[i]['Title'], note: noteMapList[i]['Description']);
      noteList.add(note);
    }
    return noteList;
  }

  Future<int> insertNote(Note note) async {
    Database db = await this.database;
    var result = await db.insert(tableName, note.toMap());
    return result;
  }
}

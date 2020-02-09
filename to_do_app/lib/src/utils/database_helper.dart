import 'dart:io';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import '../models/quick_note_model.dart';
import '../models/list_model.dart';

class DatabaseHelper {
  static final _databaseName = "ToDoDatabase.db";
  static final _databaseVersion = 1;

  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database _database;
  Future<Database> get database async {
    if (_database != null) return _database;
    _database = await _initDatabase();
    return _database;
  }

  _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);
    return await openDatabase(path,
        version: _databaseVersion, onCreate: _onCreate);
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
          CREATE TABLE quick_notes (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            date TEXT NOT NULL,
            content TEXT NOT NULL,
            done INTEGER NOT NULL,
            priority TEXT NOT NULL
          )
          ''');
    await db.execute('''
          CREATE TABLE lists (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            date TEXT NOT NULL,
            list_name TEXT NOT NULL,
            content TEXT NOT NULL,
            done INTEGER NOT NULL
          )
          ''');
  }

  Future<List<Map<String, dynamic>>> queryAllRows(String table) async {
    Database db = await instance.database;
    return await db.query(table);
  }

  Future<int> addList(ToDoList list) async {
    var client = await instance.database;
    return client.insert('lists', list.toMapForDb(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<QuickNote>> fetchQuickNotes(String date) async {
    var client = await instance.database;
    final Future<List<Map<String, dynamic>>> futureMaps =
        client.query('quick_notes', where: 'date = ?', whereArgs: [date]);
    var maps = await futureMaps;
    if (maps.length != 0) {
      List<QuickNote> notesList = List<QuickNote>();
      for (int i = 0; i < maps.length; i++) {
        notesList.add(
          QuickNote.fromDb(maps[i]),
        );
      }
      return notesList;
    }
    return null;
  }

  Future fetchListNames(String date) async {
    var client = await instance.database;
    final Future<List<Map<String, dynamic>>> futureMaps = client.query(
      'lists',
      columns: ['list_name'],
      where: 'date = ?',
      whereArgs: [date],
      groupBy: 'list_name',
    );
    var map = await futureMaps;
    if (map.length != 0) {
      List<String> listNames = List<String>();
      for (int i = 0; i < map.length; i++) {
        listNames.add(map[i]['list_name']);
      }
      return listNames;
    }
    return null;
  }

  Future<List<ToDoList>> fetchList(String date) async {
    var client = await instance.database;
    final Future<List<Map<String, dynamic>>> futureMaps = client.query(
      'lists',
      where: 'date = ?',
      whereArgs: [date],
    );
    var maps = await futureMaps;
    if (maps.length != 0) {
      List<ToDoList> toDoList = List<ToDoList>();
      for (int i = 0; i < maps.length; i++) {
        toDoList.add(
          ToDoList.fromDb(maps[i]),
        );
      }
      return toDoList;
    }
    return null;
  }

  Future updateQuickNote(QuickNote note) async {
    var client = await instance.database;
    return client.update(
      'quick_notes',
      note.toMapForDb(),
      where: 'id = ?',
      whereArgs: [note.id],
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future addQuickNote(QuickNote note) async {
    var client = await instance.database;
    return client.insert('quick_notes', note.toMapForDb(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }
}

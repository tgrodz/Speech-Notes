import 'dart:async';
import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:speech_notes/model/note_model.dart';
import 'package:sqflite/sqflite.dart';

import 'package:path/path.dart';

class DBProvider {
  //Private named constructor
  DBProvider._();

  static final DBProvider db = DBProvider._();

  Database _database;

  Future<Database> get database async {
    if (_database != null) return _database;
    _database = await initDB();
    return _database;
  }

  initDB() async {
    /**
     * class Directory - a reference to a directory (or _folder_) on the file system.
     *
     * A Directory instance is an object holding a [path] on which operations can
     * be performed. The path to the directory can be [absolute] or relative.
     * You can get the parent directory using the getter [parent],
     * a property inherited from [FileSystemEntity].
     */
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "SpeechDB.db");
    return await openDatabase(path, version: 1, onOpen: (db) {},
        onCreate: (Database db, int version) async {
      await db.execute("CREATE TABLE Note ("
          "id INTEGER PRIMARY KEY,"
          "txt TEXT"
          ")");
    });
  }

  newNote(Note newNote) async {
    final db = await database;
    //get the biggest id in the table
    var table = await db.rawQuery("SELECT MAX(id)+1 as id FROM Note");
    int id = table.first["id"];
    //insert to the table using the new id
    var raw = await db.rawInsert(
        "INSERT Into Note (id,txt)"
        " VALUES (?,?)",
        [
          id,
          newNote.txt,
        ]);
    return raw;
  }

  updateNote(Note newNote) async {
    final db = await database;
    var res = await db.update("Note", newNote.toMap(), where: "id = ?", whereArgs: [newNote.id]);
    return res;
  }

  getNote(int id) async {
    final db = await database;
    var res = await db.query("Note", where: "id = ?", whereArgs: [id]);
    return res.isNotEmpty ? Note.fromMap(res.first) : null;
  }

  Future<List<Note>> getAllNotes() async {
    final db = await database;
    var res = await db.query("Note");
    List<Note> list = res.isNotEmpty ? res.map((c) => Note.fromMap(c)).toList() : [];
    print("-- DBProvider list length ${list.length}");
    list.forEach((element) => print("item: ${element.txt}"));
    return list;
  }

  deleteNote(int id) async {
    final db = await database;
    return db.delete("Note", where: "id = ?", whereArgs: [id]);
  }

  deleteAll() async {
    final db = await database;
    db.rawDelete("Delete * from Note");
  }
}

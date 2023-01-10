import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo/models/todo_model.dart';
import 'package:todo/utils/helpers.dart';
import 'package:uuid/uuid.dart';

class DatabaseHelper {
  static const _databaseName = "todo.db";
  static const _databaseVersion = 1;
  static const tableTodo = "todo";
  static const columnTodoUuid = "uuid";
  static const columnTodoTitle = "title";
  static const columnTodoDescription = "description";
  static const columnTodoTimestamp = "timestamp";
  static const columnTodoIsDone = "is_done";
  static const columnTodoPriority = "priority";
  static const columnTodoArchived = "is_archived";

  DatabaseHelper._privateConstructor();

  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database? _database;

  Future<Database?> get database async {
    if (_database != null) return _database;
    _database = await _initDatabase();
    return _database;
  }

  _initDatabase() async {
    String path = join(await getDatabasesPath(), _databaseName);
    return await openDatabase(path,
        version: _databaseVersion, onCreate: _onCreate);
  }

  Future _onCreate(Database db, int version) async {
    await db.execute(
        " CREATE TABLE $tableTodo ( $columnTodoUuid TEXT PRIMARY KEY DEFAULT NULL, $columnTodoTitle TEXT NULL, $columnTodoDescription TEXT NULL, $columnTodoTimestamp INTEGER NOT NULL DEFAULT 0, $columnTodoIsDone INTEGER NOT NULL DEFAULT 0, $columnTodoPriority TEXT NOT NULL, $columnTodoArchived INTEGER NOT NULL DEFAULT 0) ");
  }

  Future<String> todoInsert(TodoModel todo) async {
    Database? db = await instance.database;
    try {
      String uuid = generateUuid();
      await db!.insert(
          tableTodo,
          {
            columnTodoUuid: uuid,
            columnTodoTitle: todo.title,
            columnTodoDescription: todo.description,
            columnTodoTimestamp: todo.timestamp,
            columnTodoIsDone: todo.isDone ? 1 : 0,
            columnTodoPriority: todo.priority,
            columnTodoArchived: todo.isArchived
          },
          conflictAlgorithm: ConflictAlgorithm.fail);

      return uuid;
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return '';
    }
  }

  Future<String> todoUpdate(String uuid, TodoModel todo) async {
    Database? db = await instance.database;
    try {
      await db!.update(
          tableTodo,
          {
            columnTodoTitle: todo.title,
            columnTodoDescription: todo.description,
            columnTodoTimestamp: todo.timestamp,
            columnTodoIsDone: todo.isDone ? 1 : 0,
            columnTodoPriority: todo.priority
          },
          where: "$columnTodoUuid = ?",
          whereArgs: [uuid]);

      return uuid;
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return '';
    }
  }

  Future<List<TodoModel>> todoGetList() async {
    Database? db = await instance.database;
    final List<Map<String, dynamic>> list =
        await db!.query(tableTodo, orderBy: "$columnTodoTimestamp ASC");

    List<TodoModel> todoList = List.generate(list.length, (i) {
      return TodoModel(
        uuid: list[i][columnTodoUuid],
        title: list[i][columnTodoTitle],
        timestamp: list[i][columnTodoTimestamp],
        isDone: list[i][columnTodoIsDone] == 1,
        isArchived: list[i][columnTodoArchived] == 1,
        priority: list[i][columnTodoPriority],
        description: list[i][columnTodoDescription],
      );
    });
    return todoList;
  }

  Future<List<TodoModel>> todoGetListForStatus(String status) async {
    Database? db = await instance.database;

    String where = "";
    List<String> whereList = [];

    String currentTimestamp = DateFormat("yyyy-MM-dd HH:mm:ss").format(DateTime.now());

    switch (status) {
      case "active":
        whereList.add("$columnTodoArchived = 0");
        whereList.add("$columnTodoTimestamp > ${DateTime.now().millisecondsSinceEpoch}" );
        whereList.add("$columnTodoIsDone = 0");
        break;
      case "expired":
        whereList.add("$columnTodoTimestamp < ${DateTime.now().millisecondsSinceEpoch}" );
        break;
      case "done":
        whereList.add("$columnTodoIsDone = 1");
        break;
      case "archive":
        whereList.add("$columnTodoArchived = 1");
        break;
      default:
    }

    String whereString = "";
    if(whereList.isNotEmpty){
      whereString = whereList.join(" AND ");
    }
    print(whereString);
    final List<Map<String, dynamic>> list =
        await db!.query(tableTodo, orderBy: "$columnTodoTimestamp ASC", where: whereString.isEmpty ? null : whereString);

    List<TodoModel> todoList = List.generate(list.length, (i) {
      return TodoModel(
        uuid: list[i][columnTodoUuid],
        title: list[i][columnTodoTitle],
        timestamp: list[i][columnTodoTimestamp],
        isDone: list[i][columnTodoIsDone] == 1,
        isArchived: list[i][columnTodoArchived] == 1,
        priority: list[i][columnTodoPriority],
        description: list[i][columnTodoDescription],
      );
    });
    return todoList;
  }

  Future<TodoModel> todoGet(String uuid) async {
    Database? db = await instance.database;
    final List<Map<String, dynamic>> list = await db!
        .query(tableTodo, where: '$columnTodoUuid = ?', whereArgs: [uuid]);

    if (list.isEmpty) {
      return TodoModel(
          uuid: '',
          title: '',
          timestamp: 0,
          isDone: false,
          isArchived: false,
          priority: '',
          description: '');
    }

    List<TodoModel> todoList = List.generate(list.length, (i) {
      return TodoModel(
        uuid: list[i][columnTodoUuid],
        title: list[i][columnTodoTitle],
        timestamp: list[i][columnTodoTimestamp],
        isDone: list[i][columnTodoIsDone] == 1,
        isArchived: list[i][columnTodoArchived] == 1,
        priority: list[i][columnTodoPriority],
        description: list[i][columnTodoDescription],
      );
    });

    return todoList[0];
  }

  Future<int> todoDelete(String uuid) async {
    Database? db = await instance.database;
    try {
      return await db!
          .delete(tableTodo, where: '$columnTodoUuid = ?', whereArgs: [uuid]);
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return 0;
    }
  }

  Future<void> clearTable() async {
    Database? db = await instance.database;
    try {
      await db!.rawQuery("DELETE FROM $tableTodo");
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }
}

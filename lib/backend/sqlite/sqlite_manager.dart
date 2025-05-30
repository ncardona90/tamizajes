import 'package:flutter/foundation.dart';

import '/backend/sqlite/init.dart';
import 'queries/read.dart';
import 'queries/update.dart';

import 'package:sqflite/sqflite.dart';
export 'queries/read.dart';
export 'queries/update.dart';

class SQLiteManager {
  SQLiteManager._();

  static SQLiteManager? _instance;
  static SQLiteManager get instance => _instance ??= SQLiteManager._();

  static late Database _database;
  Database get database => _database;

  static Future initialize() async {
    if (kIsWeb) {
      return;
    }
    _database = await initializeDatabaseFromDbFile(
      'tamizajes',
      'tamizajes.db',
    );
  }

  /// START READ QUERY CALLS

  Future<List<ReadTamizajesRow>> readTamizajes() => performReadTamizajes(
        _database,
      );

  /// END READ QUERY CALLS

  /// START UPDATE QUERY CALLS

  Future createTamizaje({
    String? nombres,
    String? apellidos,
  }) =>
      performCreateTamizaje(
        _database,
        nombres: nombres,
        apellidos: apellidos,
      );

  Future updateTamizajes({
    String? nombres,
    String? apellidos,
    int? id,
  }) =>
      performUpdateTamizajes(
        _database,
        nombres: nombres,
        apellidos: apellidos,
        id: id,
      );

  Future deleteTamizajes({
    int? id,
  }) =>
      performDeleteTamizajes(
        _database,
        id: id,
      );

  /// END UPDATE QUERY CALLS
}

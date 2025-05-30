import '/backend/sqlite/queries/sqlite_row.dart';
import 'package:sqflite/sqflite.dart';

Future<List<T>> _readQuery<T>(
  Database database,
  String query,
  T Function(Map<String, dynamic>) create,
) =>
    database.rawQuery(query).then((r) => r.map((e) => create(e)).toList());

/// BEGIN READTAMIZAJES
Future<List<ReadTamizajesRow>> performReadTamizajes(
  Database database,
) {
  final query = '''
SELECT * FROM tamizajes;
''';
  return _readQuery(database, query, (d) => ReadTamizajesRow(d));
}

class ReadTamizajesRow extends SqliteRow {
  ReadTamizajesRow(Map<String, dynamic> data) : super(data);

  int get id => data['id'] as int;
  String get nombres => data['nombres'] as String;
  String get apellidos => data['apellidos'] as String;
}

/// END READTAMIZAJES

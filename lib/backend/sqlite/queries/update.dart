import 'package:sqflite/sqflite.dart';

/// BEGIN CREATETAMIZAJE
Future performCreateTamizaje(
  Database database, {
  String? nombres,
  String? apellidos,
}) {
  final query = '''
insert into  tamizajes(nombres,apellidos) values('${nombres}','${apellidos}'); 
''';
  return database.rawQuery(query);
}

/// END CREATETAMIZAJE

/// BEGIN UPDATETAMIZAJES
Future performUpdateTamizajes(
  Database database, {
  String? nombres,
  String? apellidos,
  int? id,
}) {
  final query = '''
update tamizajes set nombres='${nombres}',apellidos='${apellidos}' where id=${id} 
''';
  return database.rawQuery(query);
}

/// END UPDATETAMIZAJES

/// BEGIN DELETETAMIZAJES
Future performDeleteTamizajes(
  Database database, {
  int? id,
}) {
  final query = '''
DELETE FROM tamizajes WHERE ID = ${id};
''';
  return database.rawQuery(query);
}

/// END DELETETAMIZAJES

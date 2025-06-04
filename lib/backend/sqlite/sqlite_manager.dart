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
      'tamizaje',
      'bmt4t_db.db',
    );
  }

  /// START READ QUERY CALLS

  Future<List<LeerRow>> leer() => performLeer(
        _database,
      );

  /// END READ QUERY CALLS

  /// START UPDATE QUERY CALLS

  Future createTamizaje({
    String? fechaintervencion,
    String? lugarintervencion,
    String? entornointervencion,
    String? horainicialintervencion,
    String? horafinalintervencion,
    String? codigotamizajemanual,
    String? nombres,
    String? apellidos,
    String? tipodoc,
    int? numerodocumento,
    String? nacionalidad,
    String? fechanacimiento,
    int? edad,
    String? sexoasignadonacimiento,
    String? generoidentificado,
    String? orientacionsexual,
    String? grupoetnico,
    String? otrogrupoetnico,
    String? poblacioncondicionsituacion,
    String? poblacionmigrante,
    String? tieneseressintientes,
    String? correoelectronico,
    String? telefonocontacto,
    String? direccionresidencia,
    String? barriocorregimientovereda,
    String? comuna,
    String? eapb,
    String? tipoaseguramiento,
    String? eps,
    double? talla,
    double? peso,
    String? imc,
    String? clasificacionimc,
    int? presionsistolica,
    int? presiondiastolica,
    double? circunferenciaabdominal,
    String? actividadfisica,
    String? frecuenciafrutasverduras,
    String? medicacionhipertension,
    String? glucosaaltahistorico,
    String? antecedentesfamiliaresdiabetes,
    String? esdiabetico,
    String? tipodiabetes,
    String? fuma,
    int? puntajefindrisccalculado,
    String? riesgofindrisc,
    String? enfermedadcardiovascularrenalcolesterol,
    String? riesgocardiovascularomsporcentaje,
    String? clasificacionriesgocardiovascularoms,
    String? observaciones,
    String? fecharegistrobd,
  }) =>
      performCreateTamizaje(
        _database,
        fechaintervencion: fechaintervencion,
        lugarintervencion: lugarintervencion,
        entornointervencion: entornointervencion,
        horainicialintervencion: horainicialintervencion,
        horafinalintervencion: horafinalintervencion,
        codigotamizajemanual: codigotamizajemanual,
        nombres: nombres,
        apellidos: apellidos,
        tipodoc: tipodoc,
        numerodocumento: numerodocumento,
        nacionalidad: nacionalidad,
        fechanacimiento: fechanacimiento,
        edad: edad,
        sexoasignadonacimiento: sexoasignadonacimiento,
        generoidentificado: generoidentificado,
        orientacionsexual: orientacionsexual,
        grupoetnico: grupoetnico,
        otrogrupoetnico: otrogrupoetnico,
        poblacioncondicionsituacion: poblacioncondicionsituacion,
        poblacionmigrante: poblacionmigrante,
        tieneseressintientes: tieneseressintientes,
        correoelectronico: correoelectronico,
        telefonocontacto: telefonocontacto,
        direccionresidencia: direccionresidencia,
        barriocorregimientovereda: barriocorregimientovereda,
        comuna: comuna,
        eapb: eapb,
        tipoaseguramiento: tipoaseguramiento,
        eps: eps,
        talla: talla,
        peso: peso,
        imc: imc,
        clasificacionimc: clasificacionimc,
        presionsistolica: presionsistolica,
        presiondiastolica: presiondiastolica,
        circunferenciaabdominal: circunferenciaabdominal,
        actividadfisica: actividadfisica,
        frecuenciafrutasverduras: frecuenciafrutasverduras,
        medicacionhipertension: medicacionhipertension,
        glucosaaltahistorico: glucosaaltahistorico,
        antecedentesfamiliaresdiabetes: antecedentesfamiliaresdiabetes,
        esdiabetico: esdiabetico,
        tipodiabetes: tipodiabetes,
        fuma: fuma,
        puntajefindrisccalculado: puntajefindrisccalculado,
        riesgofindrisc: riesgofindrisc,
        enfermedadcardiovascularrenalcolesterol:
            enfermedadcardiovascularrenalcolesterol,
        riesgocardiovascularomsporcentaje: riesgocardiovascularomsporcentaje,
        clasificacionriesgocardiovascularoms:
            clasificacionriesgocardiovascularoms,
        observaciones: observaciones,
        fecharegistrobd: fecharegistrobd,
      );

  /// END UPDATE QUERY CALLS
}

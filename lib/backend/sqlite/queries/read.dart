import '/backend/sqlite/queries/sqlite_row.dart';
import 'package:sqflite/sqflite.dart';

Future<List<T>> _readQuery<T>(
  Database database,
  String query,
  T Function(Map<String, dynamic>) create,
) =>
    database.rawQuery(query).then((r) => r.map((e) => create(e)).toList());

/// BEGIN LEER
Future<List<LeerRow>> performLeer(
  Database database,
) {
  final query = '''
select * from tamizaje;
''';
  return _readQuery(database, query, (d) => LeerRow(d));
}

class LeerRow extends SqliteRow {
  LeerRow(Map<String, dynamic> data) : super(data);

  int get id => data['id'] as int;
  String? get fechaIntervencion => data['fecha_intervencion'] as String?;
  String? get lugarIntervencion => data['lugar_intervencion'] as String?;
  String? get entornoIntervencion => data['entorno_intervencion'] as String?;
  String? get horaInicialIntervencion =>
      data['hora_inicial_intervencion'] as String?;
  String? get horaFinalIntervencion =>
      data['hora_final_intervencion'] as String?;
  String? get codigoTamizajeManual => data['codigo_tamizaje_manual'] as String?;
  String get nombres => data['nombres'] as String;
  String get apellidos => data['apellidos'] as String;
  String get tipoDoc => data['tipo_doc'] as String;
  int get numeroDocumento => data['numero_documento'] as int;
  String? get nacionalidad => data['nacionalidad'] as String?;
  String get fechaNacimiento => data['fecha_nacimiento'] as String;
  int? get edad => data['edad'] as int?;
  String? get sexoAsignadoNacimiento =>
      data['sexo_asignado_nacimiento'] as String?;
  String? get generoIdentificado => data['genero_identificado'] as String?;
  String? get orientacionSexual => data['orientacion_sexual'] as String?;
  String? get grupoEtnico => data['grupo_etnico'] as String?;
  String? get otroGrupoEtnico => data['otro_grupo_etnico'] as String?;
  String? get poblacionCondicionSituacion =>
      data['poblacion_condicion_situacion'] as String?;
  String? get poblacionMigrante => data['poblacion_migrante'] as String?;
  String? get tieneSeresSintientes => data['tiene_seres_sintientes'] as String?;
  String? get correoElectronico => data['correo_electronico'] as String?;
  String? get telefonoContacto => data['telefono_contacto'] as String?;
  String? get direccionResidencia => data['direccion_residencia'] as String?;
  String? get barrioCorregimientoVereda =>
      data['barrio_corregimiento_vereda'] as String?;
  String? get comuna => data['comuna'] as String?;
  String? get eapb => data['eapb'] as String?;
  String? get tipoAseguramiento => data['tipo_aseguramiento'] as String?;
  String? get eps => data['eps'] as String?;
  double? get talla => data['talla'] as double?;
  double? get peso => data['peso'] as double?;
  double? get imc => data['imc'] as double?;
  String? get clasificacionImc => data['clasificacion_imc'] as String?;
  int? get presionSistolica => data['presion_sistolica'] as int?;
  int? get presionDiastolica => data['presion_diastolica'] as int?;
  String? get circunferenciaAbdominal =>
      data['circunferencia_abdominal'] as String?;
  String? get actividadFisica => data['actividad_fisica'] as String?;
  String? get frecuenciaFrutasVerduras =>
      data['frecuencia_frutas_verduras'] as String?;
  String? get medicacionHipertension =>
      data['medicacion_hipertension'] as String?;
  String? get glucosaAltaHistorico => data['glucosa_alta_historico'] as String?;
  String? get antecedentesFamiliaresDiabetes =>
      data['antecedentes_familiares_diabetes'] as String?;
  String? get esDiabetico => data['es_diabetico'] as String?;
  String? get tipoDiabetes => data['tipo_diabetes'] as String?;
  String? get fuma => data['fuma'] as String?;
  double? get puntajeFindriscCalculado =>
      data['puntaje_findrisc_calculado'] as double?;
  String? get riesgoFindrisc => data['riesgo_findrisc'] as String?;
  String? get enfermedadCardiovascularRenalColesterol =>
      data['enfermedad_cardiovascular_renal_colesterol'] as String?;
  String? get riesgoCardiovascularOmsPorcentaje =>
      data['riesgo_cardiovascular_oms_porcentaje'] as String?;
  String? get clasificacionRiesgoCardiovascularOms =>
      data['clasificacion_riesgo_cardiovascular_oms'] as String?;
  String? get observaciones => data['observaciones'] as String?;
  String get fechaRegistroBd => data['fecha_registro_bd'] as String;
}

/// END LEER

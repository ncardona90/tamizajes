// custom_code/sqlite_helper.dart
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart'; // ¡Esta importación es CRUCIAL!

// Modelo de datos para Tamizaje (actualizado para el formulario completo)
class Tamizaje {
  final int? id; // PK autoincremental de la BD

  // Sección 1: Información General de la Intervención
  final String? fechaIntervencion; // YYYY-MM-DD
  final String? lugarIntervencion;
  final String? entornoIntervencion; // Ya existía, se mantiene
  final String?
      horaInicialIntervencion; // HH:MM (considerar formato 24h o am/pm)
  final String? horaFinalIntervencion; // HH:MM

  // Sección 2: Datos del Participante
  final String? codigoTamizajeManual; // "Código (Solo para Tamizaje)"
  final String nombres;
  final String apellidos;
  final String tipoDoc;
  final int numeroDocumento;
  final String? nacionalidad;
  final String fechaNacimiento; // YYYY-MM-DD
  final int? edad; // Calculado
  final String? sexoAsignadoNacimiento;
  final String? generoIdentificado;
  final String? orientacionSexual;
  final String? grupoEtnico;
  final String?
      otroGrupoEtnico; // Para cuando seleccionan "Otro" en grupo_etnico
  final String?
      poblacionCondicionSituacion; // Puede ser múltiple, considerar guardar como JSON string o delimitado por comas
  final String? poblacionMigrante;
  final String? tieneSeresSintientes;
  final String? correoElectronico;
  final String?
      telefonoContacto; // Guardar como TEXT para flexibilidad con prefijos, etc.
  final String? direccionResidencia;
  final String? barrioCorregimientoVereda; // Campo unificado
  final String? comuna;
  final String? eapb; // Entidad Administradora de Planes de Beneficios
  final String? tipoAseguramiento; // C, S, SA, RE
  final String? eps;

  // Sección 3: Medidas y Resultados del Tamizaje
  final double? talla; // metros
  final double? peso; // kg
  final double? imc; // Calculado
  final String? clasificacionImc; // Calculado
  final int? presionSistolica;
  final int? presionDiastolica;
  final double? circunferenciaAbdominal; // cm

  // Sección 4: Test de Riesgo de Diabetes y Prediabetes (FINDRISC)
  final String? actividadFisica; // Sí / No
  final String? frecuenciaFrutasVerduras; // "Diario / 3-5 veces / Rara vez"
  final String? medicacionHipertension; // Sí / No
  final String? glucosaAltaHistorico; // Sí / No
  final String?
      antecedentesFamiliaresDiabetes; // "Ninguno / Pariente lejano / Padres o hermanos"
  final String? esDiabetico; // Sí / No
  final String? tipoDiabetes; // Tipo 1 / Tipo 2 / Gestacional / No aplica
  final String? fuma; // Sí / No
  final double? puntajeFindriscCalculado; // Puntaje numérico del FINDRISC
  final String?
      riesgoFindrisc; // Bajo, Moderado, Alto, Muy Alto (Texto calculado)

  // Sección 5: Riesgo Cardiovascular (OMS)
  final String? enfermedadCardiovascularRenalColesterol; // Sí / No
  final String?
      riesgoCardiovascularOmsPorcentaje; // El texto del porcentaje, ej: "<10%"
  final String?
      clasificacionRiesgoCardiovascularOms; // Bajo, Moderado, Alto, Muy Alto (Texto calculado)

  // Sección 6: Observaciones
  final String? observaciones;

  // Metadatos del registro en la BD
  final String
      fechaRegistroBd; // Fecha de creación de la fila en la BD (YYYY-MM-DD HH:MM:SS)

  Tamizaje({
    this.id,
    // Sección 1
    this.fechaIntervencion,
    this.lugarIntervencion,
    this.entornoIntervencion,
    this.horaInicialIntervencion,
    this.horaFinalIntervencion,
    // Sección 2
    this.codigoTamizajeManual,
    required this.nombres,
    required this.apellidos,
    required this.tipoDoc,
    required this.numeroDocumento,
    this.nacionalidad,
    required this.fechaNacimiento,
    this.edad,
    this.sexoAsignadoNacimiento,
    this.generoIdentificado,
    this.orientacionSexual,
    this.grupoEtnico,
    this.otroGrupoEtnico,
    this.poblacionCondicionSituacion,
    this.poblacionMigrante,
    this.tieneSeresSintientes,
    this.correoElectronico,
    this.telefonoContacto,
    this.direccionResidencia,
    this.barrioCorregimientoVereda,
    this.comuna,
    this.eapb,
    this.tipoAseguramiento,
    this.eps,
    // Sección 3
    this.talla,
    this.peso,
    this.imc,
    this.clasificacionImc,
    this.presionSistolica,
    this.presionDiastolica,
    this.circunferenciaAbdominal,
    // Sección 4
    this.actividadFisica,
    this.frecuenciaFrutasVerduras,
    this.medicacionHipertension,
    this.glucosaAltaHistorico,
    this.antecedentesFamiliaresDiabetes,
    this.esDiabetico,
    this.tipoDiabetes,
    this.fuma,
    this.puntajeFindriscCalculado,
    this.riesgoFindrisc,
    // Sección 5
    this.enfermedadCardiovascularRenalColesterol,
    this.riesgoCardiovascularOmsPorcentaje,
    this.clasificacionRiesgoCardiovascularOms,
    // Sección 6
    this.observaciones,
    required this.fechaRegistroBd,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      // Sección 1
      'fecha_intervencion': fechaIntervencion,
      'lugar_intervencion': lugarIntervencion,
      'entorno_intervencion': entornoIntervencion,
      'hora_inicial_intervencion': horaInicialIntervencion,
      'hora_final_intervencion': horaFinalIntervencion,
      // Sección 2
      'codigo_tamizaje_manual': codigoTamizajeManual,
      'nombres': nombres,
      'apellidos': apellidos,
      'tipo_doc': tipoDoc,
      'numero_documento': numeroDocumento,
      'nacionalidad': nacionalidad,
      'fecha_nacimiento': fechaNacimiento,
      'edad': edad,
      'sexo_asignado_nacimiento': sexoAsignadoNacimiento,
      'genero_identificado': generoIdentificado,
      'orientacion_sexual': orientacionSexual,
      'grupo_etnico': grupoEtnico,
      'otro_grupo_etnico': otroGrupoEtnico,
      'poblacion_condicion_situacion': poblacionCondicionSituacion,
      'poblacion_migrante': poblacionMigrante,
      'tiene_seres_sintientes': tieneSeresSintientes,
      'correo_electronico': correoElectronico,
      'telefono_contacto': telefonoContacto,
      'direccion_residencia': direccionResidencia,
      'barrio_corregimiento_vereda': barrioCorregimientoVereda,
      'comuna': comuna,
      'eapb': eapb,
      'tipo_aseguramiento': tipoAseguramiento,
      'eps': eps,
      // Sección 3
      'talla': talla,
      'peso': peso,
      'imc': imc,
      'clasificacion_imc': clasificacionImc,
      'presion_sistolica': presionSistolica,
      'presion_diastolica': presionDiastolica,
      'circunferencia_abdominal': circunferenciaAbdominal,
      // Sección 4
      'actividad_fisica': actividadFisica,
      'frecuencia_frutas_verduras': frecuenciaFrutasVerduras,
      'medicacion_hipertension': medicacionHipertension,
      'glucosa_alta_historico': glucosaAltaHistorico,
      'antecedentes_familiares_diabetes': antecedentesFamiliaresDiabetes,
      'es_diabetico': esDiabetico,
      'tipo_diabetes': tipoDiabetes,
      'fuma': fuma,
      'puntaje_findrisc_calculado': puntajeFindriscCalculado,
      'riesgo_findrisc': riesgoFindrisc,
      // Sección 5
      'enfermedad_cardiovascular_renal_colesterol':
          enfermedadCardiovascularRenalColesterol,
      'riesgo_cardiovascular_oms_porcentaje': riesgoCardiovascularOmsPorcentaje,
      'clasificacion_riesgo_cardiovascular_oms':
          clasificacionRiesgoCardiovascularOms,
      // Sección 6
      'observaciones': observaciones,
      'fecha_registro_bd': fechaRegistroBd,
    };
  }

  factory Tamizaje.fromMap(Map<String, dynamic> map) {
    return Tamizaje(
      id: map['id'] as int?,
      // Sección 1
      fechaIntervencion: map['fecha_intervencion'] as String?,
      lugarIntervencion: map['lugar_intervencion'] as String?,
      entornoIntervencion: map['entorno_intervencion'] as String?,
      horaInicialIntervencion: map['hora_inicial_intervencion'] as String?,
      horaFinalIntervencion: map['hora_final_intervencion'] as String?,
      // Sección 2
      codigoTamizajeManual: map['codigo_tamizaje_manual'] as String?,
      nombres: map['nombres'] as String,
      apellidos: map['apellidos'] as String,
      tipoDoc: map['tipo_doc'] as String,
      numeroDocumento: map['numero_documento'] as int,
      nacionalidad: map['nacionalidad'] as String?,
      fechaNacimiento: map['fecha_nacimiento'] as String,
      edad: map['edad'] as int?,
      sexoAsignadoNacimiento: map['sexo_asignado_nacimiento'] as String?,
      generoIdentificado: map['genero_identificado'] as String?,
      orientacionSexual: map['orientacion_sexual'] as String?,
      grupoEtnico: map['grupo_etnico'] as String?,
      otroGrupoEtnico: map['otro_grupo_etnico'] as String?,
      poblacionCondicionSituacion:
          map['poblacion_condicion_situacion'] as String?,
      poblacionMigrante: map['poblacion_migrante'] as String?,
      tieneSeresSintientes: map['tiene_seres_sintientes'] as String?,
      correoElectronico: map['correo_electronico'] as String?,
      telefonoContacto: map['telefono_contacto'] as String?,
      direccionResidencia: map['direccion_residencia'] as String?,
      barrioCorregimientoVereda: map['barrio_corregimiento_vereda'] as String?,
      comuna: map['comuna'] as String?,
      eapb: map['eapb'] as String?,
      tipoAseguramiento: map['tipo_aseguramiento'] as String?,
      eps: map['eps'] as String?,
      // Sección 3
      talla: (map['talla'] as num?)?.toDouble(),
      peso: (map['peso'] as num?)?.toDouble(),
      imc: (map['imc'] as num?)?.toDouble(),
      clasificacionImc: map['clasificacion_imc'] as String?,
      presionSistolica: map['presion_sistolica'] as int?,
      presionDiastolica: map['presion_diastolica'] as int?,
      circunferenciaAbdominal:
          (map['circunferencia_abdominal'] as num?)?.toDouble(),
      // Sección 4
      actividadFisica: map['actividad_fisica'] as String?,
      frecuenciaFrutasVerduras: map['frecuencia_frutas_verduras'] as String?,
      medicacionHipertension: map['medicacion_hipertension'] as String?,
      glucosaAltaHistorico: map['glucosa_alta_historico'] as String?,
      antecedentesFamiliaresDiabetes:
          map['antecedentes_familiares_diabetes'] as String?,
      esDiabetico: map['es_diabetico'] as String?,
      tipoDiabetes: map['tipo_diabetes'] as String?,
      fuma: map['fuma'] as String?,
      puntajeFindriscCalculado:
          (map['puntaje_findrisc_calculado'] as num?)?.toDouble(),
      riesgoFindrisc: map['riesgo_findrisc'] as String?,
      // Sección 5
      enfermedadCardiovascularRenalColesterol:
          map['enfermedad_cardiovascular_renal_colesterol'] as String?,
      riesgoCardiovascularOmsPorcentaje:
          map['riesgo_cardiovascular_oms_porcentaje'] as String?,
      clasificacionRiesgoCardiovascularOms:
          map['clasificacion_riesgo_cardiovascular_oms'] as String?,
      // Sección 6
      observaciones: map['observaciones'] as String?,
      fechaRegistroBd: map['fecha_registro_bd'] as String,
    );
  }
}

class SQLiteHelper {
  static Database? _database;
  static const String _tableName = 'Tamizajes';
  static const String _dbName = 'tamizajes_pic_red_oriente_v2.db';

  // Constructor de SQLiteHelper: Aquí se realiza la inicialización
  SQLiteHelper() {
    // Inicializar databaseFactoryFfi para entornos de escritorio (FFI)
    // Esto es vital para que sqflite sepa qué implementación usar.
    sqfliteFfiInit(); // Inicializa el binding FFI
    databaseFactory = sqfliteFfi
        .databaseFactoryFfi; // Asigna la fábrica FFI al driver de SQLite
  }

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, _dbName);
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS $_tableName (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        fecha_intervencion TEXT,
        lugar_intervencion TEXT,
        entorno_intervencion TEXT,
        hora_inicial_intervencion TEXT,
        hora_final_intervencion TEXT,
        codigo_tamizaje_manual TEXT,
        nombres TEXT NOT NULL,
        apellidos TEXT NOT NULL,
        tipo_doc TEXT NOT NULL,
        numero_documento INTEGER UNIQUE NOT NULL,
        nacionalidad TEXT,
        fecha_nacimiento TEXT NOT NULL,
        edad INTEGER,
        sexo_asignado_nacimiento TEXT,
        genero_identificado TEXT,
        orientacion_sexual TEXT,
        grupo_etnico TEXT,
        otro_grupo_etnico TEXT,
        poblacion_condicion_situacion TEXT,
        poblacion_migrante TEXT,
        tiene_seres_sintientes TEXT,
        correo_electronico TEXT,
        telefono_contacto TEXT,
        direccion_residencia TEXT,
        barrio_corregimiento_vereda TEXT,
        comuna TEXT,
        eapb TEXT,
        tipo_aseguramiento TEXT,
        eps TEXT,
        talla REAL,
        peso REAL,
        imc REAL,
        clasificacion_imc TEXT,
        presion_sistolica INTEGER,
        presion_diastolica INTEGER,
        circunferencia_abdominal REAL,
        actividad_fisica TEXT,
        frecuencia_frutas_verduras TEXT,
        medicacion_hipertension TEXT,
        glucosa_alta_historico TEXT,
        antecedentes_familiares_diabetes TEXT,
        es_diabetico TEXT,
        tipo_diabetes TEXT,
        fuma TEXT,
        puntaje_findrisc_calculado REAL,
        riesgo_findrisc TEXT,
        enfermedad_cardiovascular_renal_colesterol TEXT,
        riesgo_cardiovascular_oms_porcentaje TEXT,
        clasificacion_riesgo_cardiovascular_oms TEXT,
        observaciones TEXT,
        fecha_registro_bd TEXT NOT NULL
      )
    ''');
  }

  Future<int> createTamizaje(Tamizaje tamizaje) async {
    final db = await database;
    final data = tamizaje.toMap();
    data.remove('id');
    return await db.insert(_tableName, data,
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Tamizaje>> getTamizajes({String? query}) async {
    final db = await database;
    List<Map<String, dynamic>> maps;
    if (query != null && query.isNotEmpty) {
      String searchQuery = '%$query%';
      maps = await db.query(
        _tableName,
        where:
            'CAST(numero_documento AS TEXT) LIKE ? OR nombres LIKE ? OR apellidos LIKE ? OR codigo_tamizaje_manual LIKE ?',
        whereArgs: [searchQuery, searchQuery, searchQuery, searchQuery],
        orderBy: 'fecha_registro_bd DESC',
      );
    } else {
      maps = await db.query(_tableName, orderBy: 'fecha_registro_bd DESC');
    }

    return List.generate(maps.length, (i) {
      return Tamizaje.fromMap(maps[i]);
    });
  }

  Future<Tamizaje?> getTamizajeById(int id) async {
    final db = await database;
    final maps = await db.query(
      _tableName,
      where: 'id = ?',
      whereArgs: [id],
    );
    if (maps.isNotEmpty) {
      return Tamizaje.fromMap(maps.first);
    }
    return null;
  }

  Future<Tamizaje?> getTamizajeByNumeroDocumento(int numeroDocumento) async {
    final db = await database;
    final maps = await db.query(
      _tableName,
      where: 'numero_documento = ?',
      whereArgs: [numeroDocumento],
    );
    if (maps.isNotEmpty) {
      return Tamizaje.fromMap(maps.first);
    }
    return null;
  }

  Future<int> updateTamizaje(Tamizaje tamizaje) async {
    final db = await database;
    return await db.update(
      _tableName,
      tamizaje.toMap(),
      where: 'id = ?',
      whereArgs: [tamizaje.id],
    );
  }

  Future<int> deleteTamizaje(int id) async {
    final db = await database;
    return await db.delete(
      _tableName,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<List<Map<String, dynamic>>> exportAllData() async {
    final db = await database;
    return await db.query(_tableName,
        orderBy: 'fecha_intervencion ASC, id ASC');
  }

  Future<bool> checkNumeroDocumentoExists(int numeroDocumento,
      {int? currentId}) async {
    final db = await database;
    List<Map<String, dynamic>> maps;
    if (currentId != null) {
      maps = await db.query(
        _tableName,
        where: 'numero_documento = ? AND id != ?',
        whereArgs: [numeroDocumento, currentId],
      );
    } else {
      maps = await db.query(
        _tableName,
        where: 'numero_documento = ?',
        whereArgs: [numeroDocumento],
      );
    }
    return maps.isNotEmpty;
  }
}

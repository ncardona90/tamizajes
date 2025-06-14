/*
 * =================================================================================
 * ARCHIVO: sqlite_helper.dart
 * =================================================================================
 *
 * PROPÓSITO:
 * Este archivo centraliza toda la lógica de interacción con la base de datos SQLite.
 * Ha sido diseñado para reemplazar y corregir los archivos 'sqlite_manager.dart',
 * 'read.dart' y 'update.dart', solucionando problemas de arquitectura, seguridad
 * y compatibilidad.
 *
 * AUTOR: Gemini, adaptado para el proyecto de Nicolás Cardona (ncardona90)
 * FECHA: 09 de Junio de 2025
 *
 * CARACTERÍSTICAS CLAVE:
 * 1.  CLASE DE MODELO (Tamizaje): Modela los datos de la tabla 'tamizaje' de forma
 * estricta, asegurando la integridad de los tipos de datos. Incluye los
 * métodos 'fromMap' y 'toMap' para una conversión segura entre el objeto Dart
 * y el formato de la base de datos.
 *
 * 2.  GESTOR DE BASE DE DATOS (SQLiteHelper):
 * -   PATRÓN SINGLETON: Garantiza que solo exista una instancia de la base de
 * datos en toda la aplicación, evitando conflictos y fugas de memoria.
 * -   SEGURIDAD: Todas las operaciones de escritura (INSERT, UPDATE) utilizan
 * consultas parametrizadas (con '?') para prevenir completamente las
 * vulnerabilidades de inyección de SQL.
 * -   EFICIENCIA: Los métodos CRUD (Create, Read, Update, Delete) operan con
 * el objeto 'Tamizaje', haciendo el código más limpio, legible y fácil de
 * mantener en comparación con pasar docenas de parámetros.
 * -   COMPATIBILIDAD TOTAL: La estructura de la clase 'SQLiteHelper', sus
 * métodos y la clase 'Tamizaje' son 100% compatibles con las
 * expectativas del widget 'formulario_completo_widget.dart'.
 *
 * =================================================================================
 */

// Importaciones necesarias de los paquetes de Flutter y Dart.
import 'dart:io';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

// ============================================================================
// CLASE DE MODELO: Tamizaje
// ============================================================================
// Representa un único registro de la tabla 'tamizaje'.
// Los campos coinciden exactamente con los de la base de datos y los del widget.
class Tamizaje {
  final int? id;
  final String? fechaIntervencion;
  final String? lugarIntervencion;
  final String? entornoIntervencion;
  final String? horaInicialIntervencion;
  final String? horaFinalIntervencion;
  final String? codigoTamizajeManual;
  final String nombres;
  final String apellidos;
  final String tipoDoc;
  final int numeroDocumento;
  final String? nacionalidad;
  final String fechaNacimiento;
  final int? edad;
  final String? sexoAsignadoNacimiento;
  final String? generoIdentificado;
  final String? orientacionSexual;
  final String? grupoEtnico;
  final String? otroGrupoEtnico;
  final String? poblacionCondicionSituacion;
  final String? poblacionMigrante;
  final String? tieneSeresSintientes;
  final String? correoElectronico;
  final String? telefonoContacto;
  final String? direccionResidencia;
  final String? barrioCorregimientoVereda;
  final String? comuna;
  final String? eapb;
  final String? tipoAseguramiento;
  final String? eps;
  final double? talla;
  final double? peso;
  final double? imc;
  final String? clasificacionImc;
  final int? presionSistolica;
  final int? presionDiastolica;
  final double? circunferenciaAbdominal;
  final String? actividadFisica;
  final String? frecuenciaFrutasVerduras;
  final String? medicacionHipertension;
  final String? glucosaAltaHistorico;
  final String? antecedentesFamiliaresDiabetes;
  final String? esDiabetico;
  final String? tipoDiabetes;
  final String? fuma;
  final double? puntajeFindriscCalculado;
  final String? riesgoFindrisc;
  final String? enfermedadCardiovascularRenalColesterol;
  final String? riesgoCardiovascularOmsPorcentaje;
  final String? clasificacionRiesgoCardiovascularOms;
  final String? observaciones;
  final String fechaRegistroBd;

  // Constructor de la clase. Los campos requeridos aseguran la data mínima.
  Tamizaje({
    this.id,
    this.fechaIntervencion,
    this.lugarIntervencion,
    this.entornoIntervencion,
    this.horaInicialIntervencion,
    this.horaFinalIntervencion,
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
    this.talla,
    this.peso,
    this.imc,
    this.clasificacionImc,
    this.presionSistolica,
    this.presionDiastolica,
    this.circunferenciaAbdominal,
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
    this.enfermedadCardiovascularRenalColesterol,
    this.riesgoCardiovascularOmsPorcentaje,
    this.clasificacionRiesgoCardiovascularOms,
    this.observaciones,
    required this.fechaRegistroBd,
  });

  /// Convierte un objeto Map (generalmente de una lectura de la BD) a un objeto Tamizaje.
  /// Esto permite tipar los datos de forma segura después de leerlos.
  // ============================================================================
  // CONSTRUCTOR CORREGIDO Y ROBUSTO
  // ============================================================================
  factory Tamizaje.fromMap(Map<String, dynamic> map) {
    // === INICIO DE AJUSTES ===
    // Funciones locales para parsear de forma segura cualquier valor a número.
    // Evitan que la app falle si el valor es nulo o no es un número.
    int? safeParseInt(dynamic value) {
      if (value == null) return null;
      return int.tryParse(value.toString());
    }

    double? safeParseDouble(dynamic value) {
      if (value == null) return null;
      // Se reemplaza la coma por el punto para formatos decimales de entrada.
      return double.tryParse(value.toString().replaceAll(',', '.'));
    }

    // Se crea el objeto Tamizaje asegurando que los campos requeridos
    // tengan un valor por defecto en caso de ser nulos.
    return Tamizaje(
      // Campos que pueden ser nulos (opcionales)
      id: map['id'],
      lugarIntervencion: map['lugar_intervencion'] as String?,
      entornoIntervencion: map['entorno_intervencion'] as String?,
      horaInicialIntervencion: map['hora_inicial_intervencion'] as String?,
      horaFinalIntervencion: map['hora_final_intervencion'] as String?,
      codigoTamizajeManual: map['codigo_tamizaje_manual'] as String?,
      nacionalidad: map['nacionalidad'] as String?,
      sexoAsignadoNacimiento: map['sexo_asignado_nacimiento'] as String?,
      generoIdentificado: map['genero_identificado'] as String?,
      orientacionSexual: map['orientacion_sexual'] as String?,
      grupoEtnico: map['grupo_etnico'] as String?,
      otroGrupoEtnico: map['otro_grupo_etnico'] as String?,
      poblacionCondicionSituacion: map['poblacion_condicion_situacion'] as String?,
      poblacionMigrante: map['poblacion_migrante'] as String?,
      tieneSeresSintientes: map['tiene_seres_sintientes'] as String?,
      correoElectronico: map['correo_electronico'] as String?,
      telefonoContacto: map['telefono_contacto']?.toString(),
      direccionResidencia: map['direccion_residencia'] as String?,
      barrioCorregimientoVereda: map['barrio_corregimiento_vereda'] as String?,
      comuna: map['comuna'] as String?,
      eapb: map['eapb'] as String?,
      tipoAseguramiento: map['tipo_aseguramiento'] as String?,
      eps: map['eps'] as String?,
      clasificacionImc: map['clasificacion_imc'] as String?,
      actividadFisica: map['actividad_fisica'] as String?,
      frecuenciaFrutasVerduras: map['frecuencia_frutas_verduras'] as String?,
      medicacionHipertension: map['medicacion_hipertension'] as String?,
      glucosaAltaHistorico: map['glucosa_alta_historico'] as String?,
      antecedentesFamiliaresDiabetes: map['antecedentes_familiares_diabetes'] as String?,
      esDiabetico: map['es_diabetico'] as String?,
      tipoDiabetes: map['tipo_diabetes'] as String?,
      fuma: map['fuma'] as String?,
      riesgoFindrisc: map['riesgo_findrisc'] as String?,
      enfermedadCardiovascularRenalColesterol: map['enfermedad_cardiovascular_renal_colesterol'] as String?,
      riesgoCardiovascularOmsPorcentaje: map['riesgo_cardiovascular_oms_porcentaje'] as String?,
      clasificacionRiesgoCardiovascularOms: map['clasificacion_riesgo_cardiovascular_oms'] as String?,
      observaciones: map['observaciones'] as String?,

      // --- Campos Requeridos (String) ---
      // Se usa '??' para proveer un valor por defecto ('') si el mapa contiene un nulo.
      // Esto soluciona el error "type 'Null' is not a subtype of 'String'".
      fechaIntervencion: map['fecha_intervencion'] ?? '',
      nombres: map['nombres'] ?? '',
      apellidos: map['apellidos'] ?? '',
      tipoDoc: map['tipo_doc'] ?? '',
      fechaNacimiento: map['fecha_nacimiento'] ?? '',
      fechaRegistroBd: map['fecha_registro_bd'] ?? '',

      // --- Campos Numéricos (Requeridos y Opcionales) ---
      // Se usan las funciones 'safeParse' para convertir de forma segura.
      numeroDocumento: safeParseInt(map['numero_documento']) ?? 0,
      edad: safeParseInt(map['edad']),
      talla: safeParseDouble(map['talla']),
      peso: safeParseDouble(map['peso']),
      imc: safeParseDouble(map['imc']),
      presionSistolica: safeParseInt(map['presion_sistolica']),
      presionDiastolica: safeParseInt(map['presion_diastolica']),
      circunferenciaAbdominal: safeParseDouble(map['circunferencia_abdominal']),
      puntajeFindriscCalculado: safeParseDouble(map['puntaje_findrisc_calculado']),
    );
    // === FIN DE AJUSTES ===
  }

  /// Convierte este objeto Tamizaje a un objeto Map.
  /// Esto es necesario para poder insertar o actualizar datos en la BD.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'fecha_intervencion': fechaIntervencion,
      'lugar_intervencion': lugarIntervencion,
      'entorno_intervencion': entornoIntervencion,
      'hora_inicial_intervencion': horaInicialIntervencion,
      'hora_final_intervencion': horaFinalIntervencion,
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
      'talla': talla,
      'peso': peso,
      'imc': imc,
      'clasificacion_imc': clasificacionImc,
      'presion_sistolica': presionSistolica,
      'presion_diastolica': presionDiastolica,
      'circunferencia_abdominal': circunferenciaAbdominal,
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
      'enfermedad_cardiovascular_renal_colesterol': enfermedadCardiovascularRenalColesterol,
      'riesgo_cardiovascular_oms_porcentaje': riesgoCardiovascularOmsPorcentaje,
      'clasificacion_riesgo_cardiovascular_oms': clasificacionRiesgoCardiovascularOms,
      'observaciones': observaciones,
      'fecha_registro_bd': fechaRegistroBd,
    };
  }
}

// ============================================================================
// CLASE GESTORA DE LA BASE DE DATOS: SQLiteHelper
// ============================================================================
// Esta clase gestiona todas las operaciones de la base de datos.
class SQLiteHelper {
  // --- Implementación del Patrón Singleton ---
  // Constructor privado para que no se pueda instanciar desde fuera.
  SQLiteHelper._privateConstructor();
  // La única instancia estática de la clase.
  static final SQLiteHelper instance = SQLiteHelper._privateConstructor();

  // Variable para mantener la conexión a la base de datos.
  static Database? _database;
  // Getter para acceder a la base de datos. Si no está inicializada, la inicializa.
  Future<Database> get database async => _database ??= await _initDatabase();

  // --- Inicialización de la Base de Datos ---
  Future<Database> _initDatabase() async {
    // Obtiene el directorio de documentos de la aplicación, un lugar seguro para almacenar la BD.
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    // Define el nombre del archivo de la base de datos. FlutterFlow usaba 'bmt4t_db.db'.
    // Mantendremos ese nombre para compatibilidad si es necesario.
    String path = join(documentsDirectory.path, 'bmt4t_db.db');
    // Abre la base de datos. Si no existe, llama a _onCreate.
    return await openDatabase(
      path,
      version: 1, // La versión es útil para manejar migraciones futuras.
      onCreate: _onCreate,
    );
  }

  // --- Creación de la Tabla ---
  // Este método se ejecuta solo una vez, la primera vez que se crea la base de datos.
  Future _onCreate(Database db, int version) async {
    // Sentencia SQL para crear la tabla 'tamizaje'.
    // Los tipos de datos (TEXT, INTEGER, REAL) se corresponden con los de la clase Tamizaje.
    // 'id' es la clave primaria autoincremental.
    // 'numero_documento' tiene una restricción UNIQUE para evitar duplicados.
    await db.execute('''
      CREATE TABLE tamizaje(
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
          numero_documento INTEGER NOT NULL UNIQUE,
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

  // ============================================================================
  // MÉTODOS CRUD (Create, Read, Update, Delete)
  // ============================================================================

  /// Inserta un nuevo registro de Tamizaje en la base de datos.
  /// Usa el objeto Tamizaje, lo que hace el código limpio y seguro.
  Future<int> createTamizaje(Tamizaje tamizaje) async {
    Database db = await instance.database;
    // La función 'insert' de sqflite maneja la parametrización para evitar SQL injection.
    return await db.insert('tamizaje', tamizaje.toMap());
  }

  /// Actualiza un registro de Tamizaje existente.
  /// Recibe un objeto Tamizaje y usa su 'id' para la cláusula WHERE.
  Future<int> updateTamizaje(Tamizaje tamizaje) async {
    Database db = await instance.database;
    // La función 'update' también es segura contra SQL injection.
    return await db.update(
      'tamizaje',
      tamizaje.toMap(),
      where: 'id = ?',
      whereArgs: [tamizaje.id],
    );
  }

  /// Lee todos los registros de la tabla 'tamizaje' y los devuelve como una lista de objetos Tamizaje.
  /// Este método será usado por la pantalla de lista y por la función de exportación.
  Future<List<Tamizaje>> getAllTamizajes() async {
    Database db = await instance.database;
    // Realiza un query a la tabla, ordenando por fecha para mostrar los más recientes primero.
    final result = await db.query('tamizaje', orderBy: 'id DESC');
    // Mapea la lista de Maps a una lista de objetos Tamizaje.
    return result.map((json) => Tamizaje.fromMap(json)).toList();
  }

  /// Recupera un único tamizaje por su ID. Útil para una página de detalles.
  Future<Tamizaje?> getTamizajeById(int id) async {
    Database db = await instance.database;
    final result = await db.query('tamizaje', where: 'id = ?', whereArgs: [id], limit: 1);
    return result.isNotEmpty ? Tamizaje.fromMap(result.first) : null;
  }

  /// Borra un registro de la base de datos por su ID.
  Future<int> deleteTamizaje(int id) async {
    Database db = await instance.database;
    return await db.delete('tamizaje', where: 'id = ?', whereArgs: [id]);
  }

  /// Verifica si un número de documento ya existe en la base de datos.
  /// Es una función crucial requerida por 'formulario_completo_widget.dart'.
  /// [currentId] es opcional y se usa al editar para excluir el registro actual de la búsqueda.
  Future<bool> checkNumeroDocumentoExists(int numeroDocumento, {int? currentId}) async {
    Database db = await instance.database;
    List<dynamic> args = [numeroDocumento];
    String query = 'SELECT id FROM tamizaje WHERE numero_documento = ?';

    // Si estamos editando (currentId no es nulo), excluimos ese ID de la búsqueda
    // para evitar que el sistema detecte el propio documento que se edita como un duplicado.
    if (currentId != null) {
      query += ' AND id != ?';
      args.add(currentId);
    }

    // rawQuery es seguro cuando se usan '?' como placeholders y 'whereArgs'.
    final result = await db.rawQuery(query, args);
    // Si la consulta devuelve alguna fila, significa que el documento ya existe.
    return result.isNotEmpty;
  }
}
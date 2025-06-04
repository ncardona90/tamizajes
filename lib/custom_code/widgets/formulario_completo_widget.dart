// Automatic FlutterFlow imports
import '/backend/sqlite/sqlite_manager.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom widgets
import 'package:flutter/material.dart';
// Begin custom widget code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

//
// Código por Nicolás Cardona ncardona90 github
//

// Importación necesaria para DateFormat
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';

class FormularioCompletoWidget extends StatefulWidget {
  const FormularioCompletoWidget({
    super.key,
    this.width,
    this.height,
    this.initialTamizajeData,
    required this.onSaveComplete,
    this.onCancel,
  });

  final double? width;
  final double? height;
  final dynamic initialTamizajeData;
  final Future<void> Function() onSaveComplete;
  final Future<void> Function()? onCancel;

  @override
  State<FormularioCompletoWidget> createState() =>
      _FormularioCompletoWidgetState();
}

class _FormularioCompletoWidgetState extends State<FormularioCompletoWidget> {
  final _formKey = GlobalKey<FormState>();

  Map<String, dynamic> _formDataMap = {};
  bool _isEditing = false;
  // ! CORRECCIÓN: Ya no se instancia SQLiteHelper, se usa SQLiteManager.instance directamente.
  // final SQLiteHelper dbHelper = SQLiteHelper(); // ELIMINAR O COMENTAR

  // Variables para mostrar resultados de cálculos en la UI
  int? _edadCalculadaDisplay;
  double? _imcCalculadoDisplay;
  String? _clasificacionImcDisplay;
  double? _puntajeFindriscDisplay; // Para el puntaje numérico
  String? _riesgoFindriscDisplay; // Para el texto de clasificación FINDRISC
  String? _riesgoOmsPorcentajeDisplay;
  String? _clasificacionOmsDisplay;

  // Controladores para campos específicos si se necesita más control
  TextEditingController _otroGrupoEtnicoController = TextEditingController();
  // Añade más controladores si son necesarios

  // Opciones para Dropdowns
  final List<String> _opcionesEntorno = [
    'Hogar',
    'Educativo',
    'Comunitario',
    'Laboral',
    'Institucional'
  ];
  final List<String> _tiposDocumento = [
    'CC',
    'Pasaporte',
    'CE',
    'TI',
    'RC',
    'Otro'
  ];
  final List<String> _opcionesSexoAsignado = ['Hombre', 'Mujer', 'Intersexual'];
  final List<String> _opcionesGeneroIdentificado = [
    'Masculino',
    'Femenino',
    'Transgénero',
    'Transformista',
    'Travesti',
    'Transgenerista',
    'Transexual',
    'No binario',
    'Fluido',
    'Otro'
  ];
  final List<String> _opcionesOrientacionSexual = [
    'Heterosexual',
    'Homosexual',
    'Bisexual',
    'Pansexual',
    'Asexual',
    'Otra'
  ];
  final List<String> _opcionesGrupoEtnico = [
    'NARP',
    'Indígena',
    'Rrom',
    'Ninguno',
    'Otro'
  ];
  final List<String> _opcionesPoblacionCondicion = [
    'Ninguna',
    'Persona con discapacidad',
    'Víctima del conflicto armado',
    'Habitante de y en calle',
    'Persona privada de la libertad',
    'Campesino',
    'Madre Cabeza de Hogar'
  ];
  final List<String> _opcionesPoblacionMigrante = [
    'No aplica',
    'Regular',
    'Irregular'
  ];
  final List<String> _opcionesSiNo = ['Sí', 'No'];
  final List<String> _opcionesComuna =
      List.generate(22, (i) => (i + 1).toString())..add('Corregimiento');
  final List<String> _opcionesTipoAseguramiento = ['C', 'S', 'SA', 'RE'];
  final List<String> _opcionesFrecuenciaFrutasVerduras = [
    'Diario',
    '3-5 veces',
    'Rara vez'
  ];
  final List<String> _opcionesAntecedentesDiabetes = [
    'Ninguno',
    'Pariente lejano (abuelos, tíos, primos)',
    'Padres o hermanos'
  ];
  final List<String> _opcionesTipoDiabetes = [
    'No aplica',
    'Tipo 1',
    'Tipo 2',
    'Gestacional'
  ];

  // ==========================================================
  // INICIO DE LAS FUNCIONES TRASLADADAS AL WIDGET (MÉTODOS DE _FormularioCompletoWidgetState)
  // ==========================================================

  // Función: getFormattedCurrentDateTime
  String getFormattedCurrentDateTime() {
    final DateTime now = DateTime.now();
    final DateFormat formatter = DateFormat('yyyy-MM-dd HH:mm:ss');
    return formatter.format(now);
  }

  // Función: calcularEdad
  int calcularEdad(DateTime fechaNacimiento) {
    final now = DateTime.now();
    int edad = now.year - fechaNacimiento.year;
    if (now.month < fechaNacimiento.month ||
        (now.month == fechaNacimiento.month && now.day < fechaNacimiento.day)) {
      edad--;
    }
    return edad;
  }

  // Función: calcularIMC
  // **REVISA ESTA LÓGICA CON TUS REQUISITOS ESPECÍFICOS**
  double calcularIMC(double pesoKg, double tallaM) {
    if (tallaM <= 0) return 0.0; // Evitar división por cero
    return pesoKg / (tallaM * tallaM);
  }

  // Función: clasificarIMC
  // **REVISA ESTA LÓGICA CON TUS REQUISITOS ESPECÍFICOS**
  String clasificarIMC(double imc) {
    if (imc < 18.5) {
      return 'Bajo peso';
    } else if (imc >= 18.5 && imc <= 24.9) {
      return 'Peso normal';
    } else if (imc >= 25.0 && imc <= 29.9) {
      return 'Sobrepeso';
    } else if (imc >= 30.0 && imc <= 34.9) {
      return 'Obesidad Grado I';
    } else if (imc >= 35.0 && imc <= 39.9) {
      return 'Obesidad Grado II';
    } else {
      return 'Obesidad Grado III';
    }
  }

  // Función: calcularYClasificarFINDRISC
  // **REVISA ESTA LÓGICA CON TUS REQUISITOS ESPECÍFICOS. Esta es una implementación genérica.**
  String calcularYClasificarFINDRISC(
      int edad,
      double imc,
      double circunferenciaAbdominal,
      String genero, // 'Masculino', 'Femenino' o 'Hombre', 'Mujer'
      String actividadFisica, // 'Sí', 'No'
      String frecuenciaFrutasVerduras, // 'Diario', '3-5 veces', 'Rara vez'
      String medicacionHipertension, // 'Sí', 'No'
      String glucosaAltaHistorico, // 'Sí', 'No'
      String
          antecedentesFamiliaresDiabetes // 'Ninguno', 'Pariente lejano', 'Padres o hermanos'
      ) {
    int score = 0;

    // 1. Edad
    if (edad >= 45 && edad <= 54)
      score += 2;
    else if (edad >= 55 && edad <= 64)
      score += 3;
    else if (edad >= 65) score += 4;

    // 2. IMC
    if (imc >= 25.0 && imc <= 29.9)
      score += 1;
    else if (imc >= 30.0) score += 3;

    // 3. Circunferencia Abdominal (ajusta el género según tus datos 'Hombre' o 'Mujer')
    // Asumo que 'genero' contendrá 'Hombre' o 'Mujer' según sexo_asignado_nacimiento o genero_identificado
    String normalizedGender = genero.toLowerCase().contains('hombre') ||
            genero.toLowerCase().contains('masculino')
        ? 'hombre'
        : 'mujer';
    if (normalizedGender == 'hombre') {
      if (circunferenciaAbdominal >= 94 && circunferenciaAbdominal <= 102)
        score += 3;
      else if (circunferenciaAbdominal > 102) score += 4;
    } else if (normalizedGender == 'mujer') {
      if (circunferenciaAbdominal >= 80 && circunferenciaAbdominal <= 88)
        score += 3;
      else if (circunferenciaAbdominal > 88) score += 4;
    }

    // 4. Actividad física
    if (actividadFisica == 'No') score += 2;

    // 5. Frecuencia de frutas y verduras
    if (frecuenciaFrutasVerduras == 'Rara vez') score += 1;

    // 6. Historial de medicamentos para la hipertensión
    if (medicacionHipertension == 'Sí') score += 2;

    // 7. Antecedentes de glucosa alta
    if (glucosaAltaHistorico == 'Sí') score += 5;

    // 8. Antecedentes familiares de diabetes
    if (antecedentesFamiliaresDiabetes ==
        'Pariente lejano (abuelos, tíos, primos)')
      score += 3;
    else if (antecedentesFamiliaresDiabetes == 'Padres o hermanos') score += 5;

    _puntajeFindriscDisplay =
        score.toDouble(); // Actualizar el display del puntaje numérico

    // Clasificación FINDRISC
    if (score <= 7) {
      return 'Riesgo bajo (1% de probabilidad de desarrollar diabetes tipo 2 en los próximos 10 años)';
    } else if (score >= 8 && score <= 11) {
      return 'Riesgo ligeramente elevado (4% de probabilidad)';
    } else if (score >= 12 && score <= 14) {
      return 'Riesgo moderado (16% de probabilidad)';
    } else if (score >= 15 && score <= 20) {
      return 'Riesgo alto (33% de probabilidad)';
    } else {
      // score >= 21
      return 'Riesgo muy alto (50% de probabilidad)';
    }
  }

  // Función: calcularYClasificarRiesgoOMS
  // **Esta es una implementación simplificada de ejemplo.**
  // **PARA UNA IMPLEMENTACIÓN REAL Y PRECISA, DEBE USAR LAS TABLAS DE RIESGO DE LA OMS ESPECÍFICAS PARA LA REGIÓN Y GRUPO DE EDAD.**
  Map<String, String> calcularYClasificarRiesgoOMS(
      int edad,
      String genero, // Asumo 'Hombre' o 'Mujer'
      int? presionSistolica,
      String fuma, // 'Sí', 'No'
      String esDiabetico, // 'Sí', 'No'
      String
          ecvPrevia // 'Sí', 'No' (Enfermedad Cardiovascular, Renal o Colesterol)
      ) {
    double riesgoPorcentaje = 0.0;
    String clasificacionRiesgo = 'Indefinido';

    // Primer filtro: si ya tiene ECV/ERC/Hipercolesterolemia
    if (ecvPrevia == 'Sí') {
      return {
        "riesgoPorcentaje": ">30%",
        "clasificacionRiesgo":
            "Muy Alto (ECV/ERC/Hipercolesterolemia existente)"
      };
    }

    // Adaptar género a lo que espera la tabla OMS si es necesario (ej. 'Masculino' -> 'Hombre')
    String normalizedGender = genero.toLowerCase().contains('hombre') ||
            genero.toLowerCase().contains('masculino')
        ? 'hombre'
        : 'mujer';

    // Lógica simplificada basada en factores de riesgo.
    // **NOTA: Las tablas OMS reales son matriciales y más complejas.**
    if (esDiabetico == 'Sí') {
      riesgoPorcentaje += 15.0; // Alto riesgo base por diabetes
    }
    if (fuma == 'Sí') {
      riesgoPorcentaje += 10.0; // Contribución del tabaquismo
    }

    if (presionSistolica != null) {
      if (presionSistolica >= 160) {
        riesgoPorcentaje += 10.0;
      } else if (presionSistolica >= 140) {
        riesgoPorcentaje += 5.0;
      }
    }

    // Factores de edad y género (valores base)
    if (edad >= 40 && edad <= 49) {
      if (normalizedGender == 'hombre')
        riesgoPorcentaje += 1.0;
      else
        riesgoPorcentaje += 0.5;
    } else if (edad >= 50 && edad <= 59) {
      if (normalizedGender == 'hombre')
        riesgoPorcentaje += 3.0;
      else
        riesgoPorcentaje += 1.5;
    } else if (edad >= 60 && edad <= 69) {
      if (normalizedGender == 'hombre')
        riesgoPorcentaje += 6.0;
      else
        riesgoPorcentaje += 3.0;
    } else if (edad >= 70 && edad <= 79) {
      if (normalizedGender == 'hombre')
        riesgoPorcentaje += 10.0;
      else
        riesgoPorcentaje += 5.0;
    }

    // Clasificación final basada en el porcentaje acumulado
    if (riesgoPorcentaje < 1.0) {
      clasificacionRiesgo = 'Bajo (<1%)';
    } else if (riesgoPorcentaje >= 1.0 && riesgoPorcentaje < 5.0) {
      clasificacionRiesgo = 'Bajo (1-5%)';
    } else if (riesgoPorcentaje >= 5.0 && riesgoPorcentaje < 10.0) {
      clasificacionRiesgo = 'Moderado (5-10%)';
    } else if (riesgoPorcentaje >= 10.0 && riesgoPorcentaje < 20.0) {
      clasificacionRiesgo = 'Alto (10-20%)';
    } else if (riesgoPorcentaje >= 20.0 && riesgoPorcentaje < 30.0) {
      clasificacionRiesgo = 'Muy Alto (20-30%)';
    } else {
      clasificacionRiesgo = 'Muy Alto (>30%)';
    }

    return {
      "riesgoPorcentaje": "${riesgoPorcentaje.toStringAsFixed(0)}%",
      "clasificacionRiesgo": clasificacionRiesgo
    };
  }

  // ==========================================================
  // FIN DE LAS FUNCIONES TRASLADADAS AL WIDGET
  // ==========================================================

  @override
  void initState() {
    super.initState();
    _initializeFormData();
    _otroGrupoEtnicoController.addListener(() => _updateFormDataField(
        'otro_grupo_etnico', _otroGrupoEtnicoController.text));
    // Inicializa y añade listeners para otros controladores si los usas
  }

  @override
  void dispose() {
    _otroGrupoEtnicoController.dispose();
    // Desecha otros controladores
    super.dispose();
  }

  void _initializeFormData() {
    if (widget.initialTamizajeData != null) {
      Map<String, dynamic>? initialMap;
      if (widget.initialTamizajeData is Tamizaje) {
        // ! CORRECCIÓN: Usar Tamizaje
        initialMap = (widget.initialTamizajeData as Tamizaje).toMap();
        _isEditing = true;
      } else if (widget.initialTamizajeData is Map<String, dynamic>) {
        initialMap = widget.initialTamizajeData as Map<String, dynamic>;
        _isEditing = initialMap.containsKey('id') && initialMap['id'] != null;
      }

      if (initialMap != null) {
        _formDataMap = Map<String, dynamic>.from(initialMap);
        _edadCalculadaDisplay = _formDataMap['edad'] as int?;
        _imcCalculadoDisplay = (_formDataMap['imc'] as num?)?.toDouble();
        _clasificacionImcDisplay = _formDataMap['clasificacion_imc'] as String?;
        _puntajeFindriscDisplay =
            (_formDataMap['puntaje_findrisc_calculado'] as num?)?.toDouble();
        _riesgoFindriscDisplay = _formDataMap['riesgo_findrisc'] as String?;
        _riesgoOmsPorcentajeDisplay =
            _formDataMap['riesgo_cardiovascular_oms_porcentaje'] as String?;
        _clasificacionOmsDisplay =
            _formDataMap['clasificacion_riesgo_cardiovascular_oms'] as String?;
        _otroGrupoEtnicoController.text =
            _formDataMap['otro_grupo_etnico'] ?? '';
      } else {
        _setDefaultFormData();
      }
    } else {
      _isEditing = false;
      _setDefaultFormData();
    }
  }

  void _setDefaultFormData() {
    String fechaActual = DateFormat('yyyy-MM-dd').format(DateTime.now());
    String horaActual = DateFormat('HH:mm').format(DateTime.now());
    String horaMasUna = DateFormat('HH:mm')
        .format(DateTime.now().add(const Duration(hours: 1)));

    _formDataMap = {
      'fecha_intervencion': fechaActual,
      'lugar_intervencion': '',
      'entorno_intervencion': 'Hogar',
      'hora_inicial_intervencion': horaActual,
      'hora_final_intervencion': horaMasUna,
      'codigo_tamizaje_manual': null,
      'nombres': '',
      'apellidos': '',
      'tipo_doc': 'CC',
      'numero_documento': null,
      'nacionalidad': 'Colombiana',
      'fecha_nacimiento': null,
      'edad': null,
      'sexo_asignado_nacimiento': null,
      'genero_identificado': null,
      'orientacion_sexual': null,
      'grupo_etnico': null,
      'otroGrupoEtnico': null,
      'poblacion_condicion_situacion': 'Ninguna',
      'poblacion_migrante': 'No aplica',
      'tiene_seres_sintientes': 'No',
      'correo_electronico': null,
      'telefono_contacto': null,
      'direccion_residencia': null,
      'barrio_corregimiento_vereda': null,
      'comuna': null,
      'eapb': null,
      'tipo_aseguramiento': null,
      'eps': null,
      'talla': null,
      'peso': null,
      'imc': null,
      'clasificacion_imc': null,
      'presion_sistolica': null,
      'presion_diastolica': null,
      'circunferencia_abdominal': null,
      'actividad_fisica': 'No',
      'frecuencia_frutas_verduras': 'Rara vez',
      'medicacion_hipertension': 'No',
      'glucosa_alta_historico': 'No',
      'antecedentes_familiares_diabetes': 'Ninguno',
      'es_diabetico': 'No',
      'tipo_diabetes': 'No aplica',
      'fuma': 'No',
      'puntaje_findrisc_calculado': null,
      'riesgo_findrisc': null,
      'enfermedad_cardiovascular_renal_colesterol': 'No',
      'riesgo_cardiovascular_oms_porcentaje': null,
      'clasificacion_riesgo_cardiovascular_oms': null,
      'observaciones': null,
    };
    _otroGrupoEtnicoController.text = '';
  }

  void _updateFormDataField(String key, dynamic value) {
    setState(() {
      _formDataMap[key] = value;
      const fieldsThatTriggerRecalculation = [
        'peso',
        'talla',
        'fecha_nacimiento',
        'circunferencia_abdominal',
        'genero_identificado',
        'sexo_asignado_nacimiento',
        'actividad_fisica',
        'frecuencia_frutas_verduras',
        'medicacion_hipertension',
        'glucosa_alta_historico',
        'antecedentes_familiares_diabetes',
        'presion_sistolica',
        'fuma',
        'es_diabetico',
        'enfermedad_cardiovascular_renal_colesterol',
        'edad'
      ];
      if (fieldsThatTriggerRecalculation.contains(key)) {
        _recalculateAllScores();
      }
    });
  }

  void _updateFechaNacimiento(DateTime? val) {
    setState(() {
      if (val != null) {
        _formDataMap['fecha_nacimiento'] = DateFormat('yyyy-MM-dd').format(val);
        _edadCalculadaDisplay = calcularEdad(val);
        _formDataMap['edad'] = _edadCalculadaDisplay;
      } else {
        _formDataMap['fecha_nacimiento'] = null;
        _edadCalculadaDisplay = null;
        _formDataMap['edad'] = null;
      }
      _recalculateAllScores();
    });
  }

  void _recalculateAllScores() {
    final pesoRaw = _formDataMap['peso'];
    final tallaRaw = _formDataMap['talla'];
    double? peso = (pesoRaw is num)
        ? pesoRaw.toDouble()
        : (pesoRaw is String
            ? double.tryParse(pesoRaw.replaceAll(',', '.'))
            : null);
    double? talla = (tallaRaw is num)
        ? tallaRaw.toDouble()
        : (tallaRaw is String
            ? double.tryParse(tallaRaw.replaceAll(',', '.'))
            : null);

    if (peso != null && talla != null && talla > 0) {
      _imcCalculadoDisplay = calcularIMC(peso, talla);
      _formDataMap['imc'] = _imcCalculadoDisplay;
      if (_imcCalculadoDisplay != null) {
        _clasificacionImcDisplay = clasificarIMC(_imcCalculadoDisplay!);
        _formDataMap['clasificacion_imc'] = _clasificacionImcDisplay;
      }
    } else {
      _imcCalculadoDisplay = null;
      _formDataMap['imc'] = null;
      _clasificacionImcDisplay = null;
      _formDataMap['clasificacion_imc'] = null;
    }

    final edadFINDRISC = _formDataMap['edad'] as int?;
    final imcFINDRISC = _formDataMap['imc'] as double?;
    final circAbdRaw = _formDataMap['circunferencia_abdominal'];
    final generoFINDRISC = _formDataMap['genero_identificado'] as String? ??
        _formDataMap['sexo_asignado_nacimiento'] as String?;
    final actividadFisicaFINDRISC = _formDataMap['actividad_fisica'] as String?;
    final frutasVerdurasFINDRISC =
        _formDataMap['frecuencia_frutas_verduras'] as String?;
    final medHipertensionFINDRISC =
        _formDataMap['medicacion_hipertension'] as String?;
    final glucosaAltaFINDRISC =
        _formDataMap['glucosa_alta_historico'] as String?;
    final antDiabetesFINDRISC =
        _formDataMap['antecedentes_familiares_diabetes'] as String?;

    if (edadFINDRISC != null &&
        imcFINDRISC != null &&
        circAbdRaw != null &&
        generoFINDRISC != null &&
        actividadFisicaFINDRISC != null &&
        frutasVerdurasFINDRISC != null &&
        medHipertensionFINDRISC != null &&
        glucosaAltaFINDRISC != null &&
        antDiabetesFINDRISC != null) {
      double? circAbd = (circAbdRaw is num)
          ? circAbdRaw.toDouble()
          : double.tryParse(circAbdRaw.toString().replaceAll(',', '.'));
      if (circAbd != null) {
        _riesgoFindriscDisplay = calcularYClasificarFINDRISC(
          edadFINDRISC,
          imcFINDRISC,
          circAbd,
          generoFINDRISC,
          actividadFisicaFINDRISC,
          frutasVerdurasFINDRISC,
          medHipertensionFINDRISC,
          glucosaAltaFINDRISC,
          antDiabetesFINDRISC,
        );
        _formDataMap['riesgo_findrisc'] = _riesgoFindriscDisplay;
        // _puntajeFindriscDisplay = calcularPuntajeNumericoFINDRISC(...); // Necesitarías esta función
        // _formDataMap['puntaje_findrisc_calculado'] = _puntajeFindriscDisplay;
      } else {
        _riesgoFindriscDisplay = null;
        _formDataMap['riesgo_findrisc'] = null;
      }
    } else {
      _riesgoFindriscDisplay = null;
      _formDataMap['riesgo_findrisc'] = null;
    }

    final edadOMS = _formDataMap['edad'] as int?;
    final generoOMS = _formDataMap['genero_identificado'] as String? ??
        _formDataMap['sexo_asignado_nacimiento'] as String?;
    final psOMSRaw = _formDataMap['presion_sistolica'];
    final fumaOMS = _formDataMap['fuma'] as String?;
    final esDiabeticoOMS = _formDataMap['es_diabetico'] as String?;
    final ecvPreviaOMS =
        _formDataMap['enfermedad_cardiovascular_renal_colesterol'] as String?;

    if (edadOMS != null &&
        generoOMS != null &&
        psOMSRaw != null &&
        fumaOMS != null &&
        esDiabeticoOMS != null &&
        ecvPreviaOMS != null) {
      int? psOMS = (psOMSRaw is num)
          ? psOMSRaw.toInt()
          : int.tryParse(psOMSRaw.toString());
      Map<String, String> omsResult = calcularYClasificarRiesgoOMS(
          edadOMS, generoOMS, psOMS, fumaOMS, esDiabeticoOMS, ecvPreviaOMS);
      _riesgoOmsPorcentajeDisplay = omsResult["riesgoPorcentaje"];
      _clasificacionOmsDisplay = omsResult["clasificacionRiesgo"];
      _formDataMap['riesgo_cardiovascular_oms_porcentaje'] =
          _riesgoOmsPorcentajeDisplay;
      _formDataMap['clasificacion_riesgo_cardiovascular_oms'] =
          _clasificacionOmsDisplay;
    } else {
      _riesgoOmsPorcentajeDisplay = null;
      _formDataMap['riesgo_cardiovascular_oms_porcentaje'] = null;
      _clasificacionOmsDisplay = null;
      _formDataMap['clasificacion_riesgo_cardiovascular_oms'] = null;
    }
    setState(() {}); // Actualiza la UI después de recalcular
  }

  Future<void> _guardarFormulario() async {
    if (!_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content:
                const Text('Por favor, revise los campos marcados con error.'),
            backgroundColor: Colors.orange),
      );
      return;
    }

    _recalculateAllScores();
    setState(() {});

    _formDataMap['fecha_registro_bd'] = getFormattedCurrentDateTime();

    final Tamizaje tamizajeParaGardar;
    try {
      tamizajeParaGardar = Tamizaje(
        // ! CORRECCIÓN: Usar Tamizaje
        id: _isEditing ? (_formDataMap['id'] as int?) : null,
        fechaIntervencion: _formDataMap['fecha_intervencion'] as String?,
        lugarIntervencion: _formDataMap['lugar_intervencion'] as String?,
        entornoIntervencion: _formDataMap['entorno_intervencion'] as String?,
        horaInicialIntervencion:
            _formDataMap['hora_inicial_intervencion'] as String?,
        horaFinalIntervencion:
            _formDataMap['hora_final_intervencion'] as String?,
        codigoTamizajeManual: _formDataMap['codigo_tamizaje_manual'] as String?,
        nombres: _formDataMap['nombres'] as String? ?? '',
        apellidos: _formDataMap['apellidos'] as String? ?? '',
        tipoDoc: _formDataMap['tipo_doc'] as String? ?? 'CC',
        // --- COMIENZO DE CORRECCIONES TYPEERROR ---
        numeroDocumento:
            int.tryParse(_formDataMap['numero_documento']?.toString() ?? '') ??
                0,
        nacionalidad: _formDataMap['nacionalidad'] as String?,
        fechaNacimiento: _formDataMap['fecha_nacimiento'] as String? ??
            DateFormat('yyyy-MM-dd').format(DateTime(1900, 1, 1)),
        edad: _formDataMap['edad'] as int?,
        sexoAsignadoNacimiento:
            _formDataMap['sexo_asignado_nacimiento'] as String?,
        generoIdentificado: _formDataMap['genero_identificado'] as String?,
        orientacionSexual: _formDataMap['orientacion_sexual'] as String?,
        grupoEtnico: _formDataMap['grupo_etnico'] as String?,
        otroGrupoEtnico: _formDataMap['otro_grupo_etnico'] as String?,
        poblacionCondicionSituacion:
            _formDataMap['poblacion_condicion_situacion'] as String?,
        poblacionMigrante: _formDataMap['poblacion_migrante'] as String?,
        tieneSeresSintientes: _formDataMap['tiene_seres_sintientes'] as String?,
        correoElectronico: _formDataMap['correo_electronico'] as String?,
        telefonoContacto: _formDataMap['telefono_contacto']?.toString(),
        direccionResidencia: _formDataMap['direccion_residencia'] as String?,
        barrioCorregimientoVereda:
            _formDataMap['barrio_corregimiento_vereda'] as String?,
        comuna: _formDataMap['comuna'] as String?,
        eapb: _formDataMap['eapb'] as String?,
        tipoAseguramiento: _formDataMap['tipo_aseguramiento'] as String?,
        eps: _formDataMap['eps'] as String?,
        talla: double.tryParse(
            _formDataMap['talla']?.toString().replaceAll(',', '.') ?? ''),
        peso: double.tryParse(
            _formDataMap['peso']?.toString().replaceAll(',', '.') ?? ''),
        imc: (_formDataMap['imc'] as num?)
            ?.toDouble(), // IMC ya se calcula como double, así que debería estar bien.
        presionSistolica:
            int.tryParse(_formDataMap['presion_sistolica']?.toString() ?? ''),
        presionDiastolica:
            int.tryParse(_formDataMap['presion_diastolica']?.toString() ?? ''),
        circunferenciaAbdominal: double.tryParse(
            _formDataMap['circunferencia_abdominal']
                    ?.toString()
                    .replaceAll(',', '.') ??
                ''),
        actividadFisica: _formDataMap['actividad_fisica'] as String?,
        frecuenciaFrutasVerduras:
            _formDataMap['frecuencia_frutas_verduras'] as String?,
        medicacionHipertension:
            _formDataMap['medicacion_hipertension'] as String?,
        glucosaAltaHistorico: _formDataMap['glucosa_alta_historico'] as String?,
        antecedentesFamiliaresDiabetes:
            _formDataMap['antecedentes_familiares_diabetes'] as String?,
        esDiabetico: _formDataMap['es_diabetico'] as String?,
        tipoDiabetes: _formDataMap['tipo_diabetes'] as String?,
        fuma: _formDataMap['fuma'] as String?,
        puntajeFindriscCalculado:
            (_formDataMap['puntaje_findrisc_calculado'] as num?)?.toDouble(),
        riesgoFindrisc: _formDataMap['riesgo_findrisc'] as String?,
        enfermedadCardiovascularRenalColesterol:
            _formDataMap['enfermedad_cardiovascular_renal_colesterol']
                as String?,
        riesgoCardiovascularOmsPorcentaje:
            _formDataMap['riesgo_cardiovascular_oms_porcentaje'] as String?,
        clasificacionRiesgoCardiovascularOms:
            _formDataMap['clasificacion_riesgo_cardiovascular_oms'] as String?,
        observaciones: _formDataMap['observaciones'] as String?,
        fechaRegistroBd: _formDataMap['fecha_registro_bd'] as String? ??
            getFormattedCurrentDateTime(),
        // --- FIN DE CORRECCIONES TYPEERROR ---
      );
    } catch (e, s) {
      // Modificado para usar un mensaje más informativo y el stack trace.
      debugPrint(
          'Error al construir el objeto Tamizaje desde _formDataMap: $e');
      debugPrint('StackTrace: $s');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(
                'Error interno al preparar los datos: ${e.toString().split('\n').first}. Revisa la consola para detalles.'),
            backgroundColor: Colors.red),
      );
      return;
    }

    try {
      if (!_isEditing) {
        // ! CORRECCIÓN: Usar SQLiteManager.instance para llamar a checkNumeroDocumentoExists
        bool docExists = await SQLiteManager.instance
            .checkNumeroDocumentoExists(tamizajeParaGardar.numeroDocumento);
        if (docExists) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content:
                    Text('Error: El número de documento ya está registrado.'),
                backgroundColor: Colors.red),
          );
          return;
        }
        // ! CORRECCIÓN: Usar SQLiteManager.instance para llamar a createTamizaje (renombrado de createTamizajes)
        await SQLiteManager.instance.createTamizaje(tamizajeParaGardar);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Tamizaje guardado con éxito!'),
              backgroundColor: Colors.green),
        );
      } else {
        if (tamizajeParaGardar.id == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text(
                    'Error: No se puede actualizar. ID de tamizaje no encontrado.'),
                backgroundColor: Colors.red),
          );
          return;
        }
        // ! CORRECCIÓN: Usar SQLiteManager.instance para llamar a checkNumeroDocumentoExists
        bool docExists = await SQLiteManager.instance
            .checkNumeroDocumentoExists(tamizajeParaGardar.numeroDocumento,
                currentId: tamizajeParaGardar.id);
        if (docExists) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text(
                    'Error: El número de documento ya está registrado para otro paciente.'),
                backgroundColor: Colors.red),
          );
          return;
        }
        // ! CORRECCIÓN: Usar SQLiteManager.instance para llamar a updateTamizaje (renombrado de updateTamizajes)
        await SQLiteManager.instance.updateTamizaje(tamizajeParaGardar);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Tamizaje actualizado con éxito!'),
              backgroundColor: Colors.green),
        );
      }
      widget.onSaveComplete();
    } catch (e) {
      debugPrint('Error al guardar/actualizar tamizaje en la BD: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content:
                Text('Error al guardar los datos en la BD: ${e.toString()}'),
            backgroundColor: Colors.red),
      );
    }
  }

  Future<void> _selectFecha(BuildContext context, String mapKey,
      {bool isBirthDate = false, FormFieldState<DateTime>? field}) async {
    DateTime? initialDateValue = _formDataMap[mapKey] != null &&
            (_formDataMap[mapKey] as String).isNotEmpty
        ? DateFormat('yyyy-MM-dd').tryParse(_formDataMap[mapKey] as String)
        : null;

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDateValue ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      locale: const Locale('es', 'CO'), // Usar const si es posible
    );
    if (picked != null) {
      if (isBirthDate) {
        _updateFechaNacimiento(picked);
        field?.didChange(picked); // Notifica al FormField si se pasó
      } else {
        _updateFormDataField(mapKey, DateFormat('yyyy-MM-dd').format(picked));
        field?.didChange(picked); // Notifica al FormField si se pasó
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final ffTheme = FlutterFlowTheme.of(context);

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // --- SECCIÓN 1: Información General de la Intervención ---
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Text('1. Información General de la Intervención',
                    style: ffTheme.titleLarge.override(
                        fontFamily: ffTheme.titleLargeFamily,
                        letterSpacing: 0.0)),
              ),
              FormField<DateTime>(
                  initialValue: _formDataMap['fecha_intervencion'] != null &&
                          (_formDataMap['fecha_intervencion'] as String)
                              .isNotEmpty
                      ? DateFormat('yyyy-MM-dd').tryParse(
                          _formDataMap['fecha_intervencion'] as String)
                      : DateTime.now(), // Valor inicial para el picker
                  validator: (value) {
                    if (_formDataMap['fecha_intervencion'] == null ||
                        (_formDataMap['fecha_intervencion'] as String)
                            .isEmpty) {
                      return 'Campo obligatorio';
                    }
                    return null;
                  },
                  builder: (FormFieldState<DateTime> field) {
                    return InkWell(
                      onTap: () => _selectFecha(context, 'fecha_intervencion',
                          field: field),
                      child: InputDecorator(
                        decoration: InputDecoration(
                            labelText: 'Fecha Intervención (YYYY-MM-DD)*',
                            errorText: field.errorText,
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.0)),
                            filled: true,
                            fillColor: ffTheme.secondaryBackground),
                        child: Text(
                          _formDataMap['fecha_intervencion'] != null &&
                                  (_formDataMap['fecha_intervencion'] as String)
                                      .isNotEmpty
                              ? DateFormat('dd/MM/yyyy', 'es_CO').format(
                                  DateFormat('yyyy-MM-dd').parse(
                                      _formDataMap['fecha_intervencion']
                                          as String))
                              : 'Seleccionar fecha',
                          style: ffTheme.bodyMedium,
                        ),
                      ),
                    );
                  }),
              const SizedBox(height: 12),
              TextFormField(
                initialValue: _formDataMap['lugar_intervencion'] as String?,
                decoration: InputDecoration(
                    labelText: 'Lugar Intervención',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0)),
                    filled: true,
                    fillColor: ffTheme.secondaryBackground),
                style: ffTheme.bodyMedium,
                onChanged: (val) =>
                    _updateFormDataField('lugar_intervencion', val),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: _formDataMap['entorno_intervencion'] as String?,
                decoration: InputDecoration(
                    labelText: 'Entorno Intervención*',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0)),
                    filled: true,
                    fillColor: ffTheme.secondaryBackground),
                style: ffTheme.bodyMedium,
                items: _opcionesEntorno
                    .map((label) => DropdownMenuItem(
                        value: label,
                        child: Text(label, style: ffTheme.bodyMedium)))
                    .toList(),
                onChanged: (val) =>
                    _updateFormDataField('entorno_intervencion', val),
                validator: (val) =>
                    val == null ? 'Seleccione un entorno' : null,
              ),
              // TODO: Añadir campos para hora_inicial_intervencion y hora_final_intervencion (usar TimePicker o TextFormField con validación de formato)
              const SizedBox(height: 24),

              // --- SECCIÓN 2: Datos del Participante ---
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Text('2. Datos del Participante',
                    style: ffTheme.titleLarge.override(
                        fontFamily: ffTheme.titleLargeFamily,
                        letterSpacing: 0.0)),
              ),
              TextFormField(
                initialValue: _formDataMap['codigo_tamizaje_manual'] as String?,
                decoration: InputDecoration(
                    labelText: 'Código Tamizaje (Opcional)',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0)),
                    filled: true,
                    fillColor: ffTheme.secondaryBackground),
                style: ffTheme.bodyMedium,
                onChanged: (val) =>
                    _updateFormDataField('codigo_tamizaje_manual', val),
              ),
              const SizedBox(height: 12),
              TextFormField(
                initialValue: _formDataMap['nombres'] as String?,
                decoration: InputDecoration(
                    labelText: 'Nombres*',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0)),
                    filled: true,
                    fillColor: ffTheme.secondaryBackground),
                style: ffTheme.bodyMedium,
                onChanged: (val) => _updateFormDataField('nombres', val),
                validator: (val) => (val == null || val.trim().isEmpty)
                    ? 'Nombres son requeridos'
                    : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                initialValue: _formDataMap['apellidos'] as String?,
                decoration: InputDecoration(
                    labelText: 'Apellidos*',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0)),
                    filled: true,
                    fillColor: ffTheme.secondaryBackground),
                style: ffTheme.bodyMedium,
                onChanged: (val) => _updateFormDataField('apellidos', val),
                validator: (val) => (val == null || val.trim().isEmpty)
                    ? 'Apellidos son requeridos'
                    : null,
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: _formDataMap['tipo_doc'] as String?,
                decoration: InputDecoration(
                    labelText: 'Tipo de Documento*',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0)),
                    filled: true,
                    fillColor: ffTheme.secondaryBackground),
                style: ffTheme.bodyMedium,
                items: _tiposDocumento
                    .map((label) => DropdownMenuItem(
                        value: label,
                        child: Text(label, style: ffTheme.bodyMedium)))
                    .toList(),
                onChanged: (val) => _updateFormDataField('tipo_doc', val),
                validator: (val) => val == null ? 'Seleccione un tipo' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                initialValue:
                    (_formDataMap['numero_documento'] as num?)?.toString() ??
                        '',
                decoration: InputDecoration(
                    labelText: 'Número de Documento*',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0)),
                    filled: true,
                    fillColor: ffTheme.secondaryBackground),
                style: ffTheme.bodyMedium,
                keyboardType: TextInputType.number,
                onChanged:
                    (val) => // CORRECCIÓN 1: Asegura que se guarde un int?
                        _updateFormDataField(
                            'numero_documento', int.tryParse(val)),
                validator: (val) {
                  if (val == null || val.trim().isEmpty)
                    return 'Número requerido';
                  if (int.tryParse(val.trim()) == null)
                    return 'Debe ser un número';
                  return null;
                },
              ),
              const SizedBox(height: 12),
              FormField<DateTime>(
                  initialValue: _formDataMap['fecha_nacimiento'] != null &&
                          (_formDataMap['fecha_nacimiento'] as String)
                              .isNotEmpty
                      ? DateFormat('yyyy-MM-dd')
                          .tryParse(_formDataMap['fecha_nacimiento'] as String)
                      : null,
                  validator: (value) {
                    if (_formDataMap['fecha_nacimiento'] == null ||
                        (_formDataMap['fecha_nacimiento'] as String).isEmpty) {
                      return 'Fecha de nacimiento requerida';
                    }
                    return null;
                  },
                  builder: (FormFieldState<DateTime> field) {
                    return InkWell(
                      onTap: () => _selectFecha(context, 'fecha_nacimiento',
                          isBirthDate: true, field: field),
                      child: InputDecorator(
                        decoration: InputDecoration(
                            labelText: 'Fecha de Nacimiento*',
                            errorText: field.errorText,
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.0)),
                            filled: true,
                            fillColor: ffTheme.secondaryBackground),
                        child: Text(
                          _formDataMap['fecha_nacimiento'] != null &&
                                  (_formDataMap['fecha_nacimiento'] as String)
                                      .isNotEmpty
                              ? DateFormat('dd/MM/yyyy', 'es_CO').format(
                                  DateFormat('yyyy-MM-dd').parse(
                                      _formDataMap['fecha_nacimiento']
                                          as String))
                              : 'Seleccionar fecha',
                          style: ffTheme.bodyMedium,
                        ),
                      ),
                    );
                  }),
              if (_edadCalculadaDisplay != null)
                Padding(
                  padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                  child: Text('Edad (calculada): $_edadCalculadaDisplay años',
                      style: ffTheme.bodyMedium),
                ),
              const SizedBox(height: 12),
              TextFormField(
                initialValue: _formDataMap['nacionalidad'] as String?,
                decoration: InputDecoration(
                    labelText: 'Nacionalidad',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0)),
                    filled: true,
                    fillColor: ffTheme.secondaryBackground),
                style: ffTheme.bodyMedium,
                onChanged: (val) => _updateFormDataField('nacionalidad', val),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: _formDataMap['sexo_asignado_nacimiento'] as String?,
                decoration: InputDecoration(
                    labelText: 'Sexo asignado al nacer',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0)),
                    filled: true,
                    fillColor: ffTheme.secondaryBackground),
                style: ffTheme.bodyMedium,
                items: _opcionesSexoAsignado
                    .map((label) => DropdownMenuItem(
                        value: label,
                        child: Text(label, style: ffTheme.bodyMedium)))
                    .toList(),
                onChanged: (val) =>
                    _updateFormDataField('sexo_asignado_nacimiento', val),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: _formDataMap['genero_identificado'] as String?,
                decoration: InputDecoration(
                    labelText: 'Género con el que se identifica',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0)),
                    filled: true,
                    fillColor: ffTheme.secondaryBackground),
                style: ffTheme.bodyMedium,
                isExpanded: true,
                items: _opcionesGeneroIdentificado
                    .map((label) => DropdownMenuItem(
                        value: label,
                        child: Text(label,
                            style: ffTheme.bodyMedium,
                            overflow: TextOverflow.ellipsis)))
                    .toList(),
                onChanged: (val) =>
                    _updateFormDataField('genero_identificado', val),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: _formDataMap['orientacion_sexual'] as String?,
                decoration: InputDecoration(
                    labelText: 'Orientación Sexual',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0)),
                    filled: true,
                    fillColor: ffTheme.secondaryBackground),
                style: ffTheme.bodyMedium,
                items: _opcionesOrientacionSexual
                    .map((label) => DropdownMenuItem(
                        value: label,
                        child: Text(label, style: ffTheme.bodyMedium)))
                    .toList(),
                onChanged: (val) =>
                    _updateFormDataField('orientacion_sexual', val),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                  value: _formDataMap['grupo_etnico'] as String?,
                  decoration: InputDecoration(
                      labelText: 'Grupo étnico',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0)),
                      filled: true,
                      fillColor: ffTheme.secondaryBackground),
                  style: ffTheme.bodyMedium,
                  items: _opcionesGrupoEtnico
                      .map((label) => DropdownMenuItem(
                          value: label,
                          child: Text(label, style: ffTheme.bodyMedium)))
                      .toList(),
                  onChanged: (val) {
                    _updateFormDataField('grupo_etnico', val);
                    if (val != 'Otro') {
                      _otroGrupoEtnicoController.clear();
                      _updateFormDataField('otro_grupo_etnico', null);
                    }
                    setState(
                        () {}); // Para reconstruir y mostrar/ocultar el campo "otro"
                  }),
              if (_formDataMap['grupo_etnico'] == 'Otro') ...[
                const SizedBox(height: 12),
                TextFormField(
                  controller: _otroGrupoEtnicoController,
                  // initialValue: _formDataMap['otro_grupo_etnico'] as String?, // Se maneja con controller
                  decoration: InputDecoration(
                      labelText: 'Especifique otro grupo étnico',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0)),
                      filled: true,
                      fillColor: ffTheme.secondaryBackground),
                  style: ffTheme.bodyMedium,
                  onChanged: (val) => _updateFormDataField('otro_grupo_etnico',
                      val), // Alternativamente, usar el listener del controller
                ),
              ],
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: _formDataMap['poblacion_condicion_situacion'] as String?,
                decoration: InputDecoration(
                    labelText: 'Población con alguna condición o situación',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0)),
                    filled: true,
                    fillColor: ffTheme.secondaryBackground),
                style: ffTheme.bodyMedium,
                isExpanded: true,
                items: _opcionesPoblacionCondicion
                    .map((label) => DropdownMenuItem(
                        value: label,
                        child: Text(label,
                            style: ffTheme.bodyMedium,
                            overflow: TextOverflow.ellipsis)))
                    .toList(),
                onChanged: (val) =>
                    _updateFormDataField('poblacion_condicion_situacion', val),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: _formDataMap['poblacion_migrante'] as String?,
                decoration: InputDecoration(
                    labelText: 'Población migrante',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0)),
                    filled: true,
                    fillColor: ffTheme.secondaryBackground),
                style: ffTheme.bodyMedium,
                items: _opcionesPoblacionMigrante
                    .map((label) => DropdownMenuItem(
                        value: label,
                        child: Text(label, style: ffTheme.bodyMedium)))
                    .toList(),
                onChanged: (val) =>
                    _updateFormDataField('poblacion_migrante', val),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: _formDataMap['tiene_seres_sintientes'] as String?,
                decoration: InputDecoration(
                    labelText: 'Tiene seres sintientes (mascotas)',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0)),
                    filled: true,
                    fillColor: ffTheme.secondaryBackground),
                style: ffTheme.bodyMedium,
                items: _opcionesSiNo
                    .map((label) => DropdownMenuItem(
                        value: label,
                        child: Text(label, style: ffTheme.bodyMedium)))
                    .toList(),
                onChanged: (val) =>
                    _updateFormDataField('tiene_seres_sintientes', val),
              ),
              const SizedBox(height: 12),
              TextFormField(
                initialValue: _formDataMap['correo_electronico'] as String?,
                decoration: InputDecoration(
                    labelText: 'Correo Electrónico',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0)),
                    filled: true,
                    fillColor: ffTheme.secondaryBackground),
                style: ffTheme.bodyMedium,
                keyboardType: TextInputType.emailAddress,
                onChanged: (val) =>
                    _updateFormDataField('correo_electronico', val),
                validator: (val) {
                  if (val != null &&
                      val.isNotEmpty &&
                      !RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                          .hasMatch(val)) {
                    return 'Correo inválido';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                initialValue: _formDataMap['telefono_contacto'] as String?,
                decoration: InputDecoration(
                    labelText: 'Teléfono(s)',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0)),
                    filled: true,
                    fillColor: ffTheme.secondaryBackground),
                style: ffTheme.bodyMedium,
                keyboardType: TextInputType.phone,
                onChanged: (val) =>
                    _updateFormDataField('telefono_contacto', val),
              ),
              const SizedBox(height: 12),
              TextFormField(
                initialValue: _formDataMap['direccion_residencia'] as String?,
                decoration: InputDecoration(
                    labelText: 'Dirección Residencia (Tamizaje)',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0)),
                    filled: true,
                    fillColor: ffTheme.secondaryBackground),
                style: ffTheme.bodyMedium,
                onChanged: (val) =>
                    _updateFormDataField('direccion_residencia', val),
              ),
              const SizedBox(height: 12),
              TextFormField(
                initialValue:
                    _formDataMap['barrio_corregimiento_vereda'] as String?,
                decoration: InputDecoration(
                    labelText: 'Barrio/Corregimiento/Vereda',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0)),
                    filled: true,
                    fillColor: ffTheme.secondaryBackground),
                style: ffTheme.bodyMedium,
                onChanged: (val) =>
                    _updateFormDataField('barrio_corregimiento_vereda', val),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: _formDataMap['comuna'] as String?,
                decoration: InputDecoration(
                    labelText: 'Comuna',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0)),
                    filled: true,
                    fillColor: ffTheme.secondaryBackground),
                style: ffTheme.bodyMedium,
                items: _opcionesComuna
                    .map((label) => DropdownMenuItem(
                        value: label,
                        child: Text(label, style: ffTheme.bodyMedium)))
                    .toList(),
                onChanged: (val) => _updateFormDataField('comuna', val),
              ),
              const SizedBox(height: 12),
              TextFormField(
                initialValue: _formDataMap['eapb'] as String?,
                decoration: InputDecoration(
                    labelText: 'EAPB',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0)),
                    filled: true,
                    fillColor: ffTheme.secondaryBackground),
                style: ffTheme.bodyMedium,
                onChanged: (val) => _updateFormDataField('eapb', val),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: _formDataMap['tipo_aseguramiento'] as String?,
                decoration: InputDecoration(
                    labelText: 'Tipo de Aseguramiento',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0)),
                    filled: true,
                    fillColor: ffTheme.secondaryBackground),
                style: ffTheme.bodyMedium,
                items: _opcionesTipoAseguramiento
                    .map((val) => DropdownMenuItem(
                        value: val,
                        child: Text(
                            val == 'C'
                                ? 'C - Contributivo'
                                : val == 'S'
                                    ? 'S - Subsidiado'
                                    : val == 'SA'
                                        ? 'SA - Sin Aseguramiento'
                                        : 'RE - Régimen Especial',
                            style: ffTheme.bodyMedium)))
                    .toList(),
                onChanged: (val) =>
                    _updateFormDataField('tipo_aseguramiento', val),
              ),
              const SizedBox(height: 12),
              TextFormField(
                initialValue: _formDataMap['eps'] as String?,
                decoration: InputDecoration(
                    labelText: 'EPS (Tamizaje)',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0)),
                    filled: true,
                    fillColor: ffTheme.secondaryBackground),
                style: ffTheme.bodyMedium,
                onChanged: (val) => _updateFormDataField('eps', val),
              ),
              const SizedBox(height: 24),

              // --- SECCIÓN 3: Medidas e Resultados del Tamizaje ---
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Text('3. Medidas y Resultados del Tamizaje',
                    style: ffTheme.titleLarge.override(
                        fontFamily: ffTheme.titleLargeFamily,
                        letterSpacing: 0.0)),
              ),
              TextFormField(
                  initialValue:
                      _formDataMap['talla']?.toString().replaceAll('.', ','),
                  decoration: InputDecoration(
                      labelText: 'Talla (metros) Ej: 1,75',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0)),
                      filled: true,
                      fillColor: ffTheme.secondaryBackground),
                  style: ffTheme.bodyMedium,
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  onChanged: (val) => // CORRECCIÓN 2: Guarda double?
                      _updateFormDataField(
                          'talla', double.tryParse(val.replaceAll(',', '.'))),
                  validator: (val) {
                    if (val != null && val.isNotEmpty) {
                      final parsedVal =
                          double.tryParse(val.replaceAll(',', '.'));
                      if (parsedVal == null) return 'Número inválido';
                      if (parsedVal <= 0.5 || parsedVal > 2.5)
                        return 'Valor fuera de rango (0.5-2.5m)';
                    }
                    return null;
                  }),
              const SizedBox(height: 12),
              TextFormField(
                  initialValue:
                      _formDataMap['peso']?.toString().replaceAll('.', ','),
                  decoration: InputDecoration(
                      labelText: 'Peso (Kg) Ej: 70,5',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0)),
                      filled: true,
                      fillColor: ffTheme.secondaryBackground),
                  style: ffTheme.bodyMedium,
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  onChanged: (val) => // CORRECCIÓN 3: Guarda double?
                      _updateFormDataField(
                          'peso', double.tryParse(val.replaceAll(',', '.'))),
                  validator: (val) {
                    if (val != null && val.isNotEmpty) {
                      final parsedVal =
                          double.tryParse(val.replaceAll(',', '.'));
                      if (parsedVal == null) return 'Número inválido';
                      if (parsedVal <= 1 || parsedVal > 300)
                        return 'Valor fuera de rango (1-300kg)';
                    }
                    return null;
                  }),
              if (_imcCalculadoDisplay != null)
                Padding(
                  padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                  child: Text(
                      'IMC: ${_imcCalculadoDisplay?.toStringAsFixed(1)} - ${_clasificacionImcDisplay ?? ""}',
                      style: ffTheme.bodyMedium),
                ),
              const SizedBox(height: 12),
              TextFormField(
                initialValue:
                    (_formDataMap['presion_sistolica'] as num?)?.toString(),
                decoration: InputDecoration(
                    labelText: 'Presión Sistólica (mmHg)',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0)),
                    filled: true,
                    fillColor: ffTheme.secondaryBackground),
                style: ffTheme.bodyMedium,
                keyboardType: TextInputType.number,
                onChanged: (val) => // CORRECCIÓN 4: Guarda int?
                    _updateFormDataField(
                        'presion_sistolica', int.tryParse(val)),
              ),
              const SizedBox(height: 12),
              TextFormField(
                initialValue:
                    (_formDataMap['presion_diastolica'] as num?)?.toString(),
                decoration: InputDecoration(
                    labelText: 'Presión Diastólica (mmHg)',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0)),
                    filled: true,
                    fillColor: ffTheme.secondaryBackground),
                style: ffTheme.bodyMedium,
                keyboardType: TextInputType.number,
                onChanged: (val) => // CORRECCIÓN 5: Guarda int?
                    _updateFormDataField(
                        'presion_diastolica', int.tryParse(val)),
              ),
              const SizedBox(height: 12),
              TextFormField(
                initialValue: (_formDataMap['circunferencia_abdominal'] as num?)
                    ?.toString()
                    .replaceAll('.', ','),
                decoration: InputDecoration(
                    labelText: 'Circunferencia Abdominal (cm)',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0)),
                    filled: true,
                    fillColor: ffTheme.secondaryBackground),
                style: ffTheme.bodyMedium,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                onChanged: (val) => // CORRECCIÓN 6: Guarda double?
                    _updateFormDataField('circunferencia_abdominal',
                        double.tryParse(val.replaceAll(',', '.'))),
              ),
              const SizedBox(height: 24),

              // --- SECCIÓN 4: Test de Riesgo FINDRISC ---
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Text('4. Test de Riesgo FINDRISC',
                    style: ffTheme.titleLarge.override(
                        fontFamily: ffTheme.titleLargeFamily,
                        letterSpacing: 0.0)),
              ),
              DropdownButtonFormField<String>(
                value: _formDataMap['actividad_fisica'] as String?,
                decoration: InputDecoration(
                    labelText: '¿Realiza actividad física (>30min/día)?*',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0)),
                    filled: true,
                    fillColor: ffTheme.secondaryBackground),
                style: ffTheme.bodyMedium,
                items: _opcionesSiNo
                    .map((label) => DropdownMenuItem(
                        value: label,
                        child: Text(label, style: ffTheme.bodyMedium)))
                    .toList(),
                onChanged: (val) =>
                    _updateFormDataField('actividad_fisica', val),
                validator: (val) =>
                    val == null ? 'Seleccione una opción' : null,
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: _formDataMap['frecuencia_frutas_verduras'] as String?,
                decoration: InputDecoration(
                    labelText: '¿Frecuencia come frutas/verduras?*',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0)),
                    filled: true,
                    fillColor: ffTheme.secondaryBackground),
                style: ffTheme.bodyMedium,
                items: _opcionesFrecuenciaFrutasVerduras
                    .map((label) => DropdownMenuItem(
                        value: label,
                        child: Text(label, style: ffTheme.bodyMedium)))
                    .toList(),
                onChanged: (val) =>
                    _updateFormDataField('frecuencia_frutas_verduras', val),
                validator: (val) =>
                    val == null ? 'Seleccione una opción' : null,
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: _formDataMap['medicacion_hipertension'] as String?,
                decoration: InputDecoration(
                    labelText: '¿Toma medicación HTA regularmente?*',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0)),
                    filled: true,
                    fillColor: ffTheme.secondaryBackground),
                style: ffTheme.bodyMedium,
                items: _opcionesSiNo
                    .map((label) => DropdownMenuItem(
                        value: label,
                        child: Text(label, style: ffTheme.bodyMedium)))
                    .toList(),
                onChanged: (val) =>
                    _updateFormDataField('medicacion_hipertension', val),
                validator: (val) =>
                    val == null ? 'Seleccione una opción' : null,
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: _formDataMap['glucosa_alta_historico'] as String?,
                decoration: InputDecoration(
                    labelText: '¿Valores de glucosa altos antes?*',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0)),
                    filled: true,
                    fillColor: ffTheme.secondaryBackground),
                style: ffTheme.bodyMedium,
                items: _opcionesSiNo
                    .map((label) => DropdownMenuItem(
                        value: label,
                        child: Text(label, style: ffTheme.bodyMedium)))
                    .toList(),
                onChanged: (val) =>
                    _updateFormDataField('glucosa_alta_historico', val),
                validator: (val) =>
                    val == null ? 'Seleccione una opción' : null,
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value:
                    _formDataMap['antecedentes_familiares_diabetes'] as String?,
                decoration: InputDecoration(
                    labelText: '¿Diabetes en familiares?*',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0)),
                    filled: true,
                    fillColor: ffTheme.secondaryBackground),
                style: ffTheme.bodyMedium,
                isExpanded: true,
                items: _opcionesAntecedentesDiabetes
                    .map((label) => DropdownMenuItem(
                        value: label,
                        child: Text(label,
                            style: ffTheme.bodyMedium,
                            overflow: TextOverflow.ellipsis)))
                    .toList(),
                onChanged: (val) => _updateFormDataField(
                    'antecedentes_familiares_diabetes', val),
                validator: (val) =>
                    val == null ? 'Seleccione una opción' : null,
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: _formDataMap['es_diabetico'] as String?,
                decoration: InputDecoration(
                    labelText: '¿Es usted Diabético?*',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0)),
                    filled: true,
                    fillColor: ffTheme.secondaryBackground),
                style: ffTheme.bodyMedium,
                items: _opcionesSiNo
                    .map((label) => DropdownMenuItem(
                        value: label,
                        child: Text(label, style: ffTheme.bodyMedium)))
                    .toList(),
                onChanged: (val) {
                  _updateFormDataField('es_diabetico', val);
                  if (val == 'No') {
                    _updateFormDataField('tipo_diabetes', 'No aplica');
                  }
                  setState(
                      () {}); // Para reconstruir y mostrar/ocultar tipo_diabetes
                },
                validator: (val) =>
                    val == null ? 'Seleccione una opción' : null,
              ),
              if (_formDataMap['es_diabetico'] == 'Sí') ...[
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  value: _formDataMap['tipo_diabetes'] as String?,
                  decoration: InputDecoration(
                      labelText: 'Tipo de Diabetes*',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0)),
                      filled: true,
                      fillColor: ffTheme.secondaryBackground),
                  style: ffTheme.bodyMedium,
                  items: _opcionesTipoDiabetes
                      .map((label) => DropdownMenuItem(
                          value: label,
                          child: Text(label, style: ffTheme.bodyMedium)))
                      .toList(),
                  onChanged: (val) =>
                      _updateFormDataField('tipo_diabetes', val),
                  validator: (val) =>
                      (_formDataMap['es_diabetico'] == 'Sí' && val == null)
                          ? 'Seleccione un tipo'
                          : null,
                ),
              ],
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: _formDataMap['fuma'] as String?,
                decoration: InputDecoration(
                    labelText: '¿Fuma?*',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0)),
                    filled: true,
                    fillColor: ffTheme.secondaryBackground),
                style: ffTheme.bodyMedium,
                items: _opcionesSiNo
                    .map((label) => DropdownMenuItem(
                        value: label,
                        child: Text(label, style: ffTheme.bodyMedium)))
                    .toList(),
                onChanged: (val) => _updateFormDataField('fuma', val),
                validator: (val) =>
                    val == null ? 'Seleccione una opción' : null,
              ),
              if (_riesgoFindriscDisplay != null)
                Padding(
                  padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                  child: Text('Riesgo FINDRISC: $_riesgoFindriscDisplay',
                      style: ffTheme.bodyMedium),
                ),
              const SizedBox(height: 24),

              // --- SECCIÓN 5: Risco Cardiovascular OMS ---
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Text('5. Riesgo Cardiovascular (OMS)',
                    style: ffTheme.titleLarge.override(
                        fontFamily: ffTheme.titleLargeFamily,
                        letterSpacing: 0.0)),
              ),
              DropdownButtonFormField<String>(
                value:
                    _formDataMap['enfermedad_cardiovascular_renal_colesterol']
                        as String?,
                decoration: InputDecoration(
                    labelText: '¿Tiene ya ECV, ERC, Hipercolesterolemia?*',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0)),
                    filled: true,
                    fillColor: ffTheme.secondaryBackground),
                style: ffTheme.bodyMedium,
                items: _opcionesSiNo
                    .map((label) => DropdownMenuItem(
                        value: label,
                        child: Text(label, style: ffTheme.bodyMedium)))
                    .toList(),
                onChanged: (val) => _updateFormDataField(
                    'enfermedad_cardiovascular_renal_colesterol', val),
                validator: (val) =>
                    val == null ? 'Seleccione una opción' : null,
              ),
              if (_riesgoOmsPorcentajeDisplay != null)
                Padding(
                  padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                  child: Text(
                      'Riesgo OMS: $_riesgoOmsPorcentajeDisplay ($_clasificacionOmsDisplay)',
                      style: ffTheme.bodyMedium),
                ),
              const SizedBox(height: 24),

              // --- SECCIÓN 6: Observacións ---
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Text('6. Observaciones',
                    style: ffTheme.titleLarge.override(
                        fontFamily: ffTheme.titleLargeFamily,
                        letterSpacing: 0.0)),
              ),
              TextFormField(
                initialValue: _formDataMap['observaciones'] as String?,
                decoration: InputDecoration(
                  labelText: 'Observaciones',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0)),
                  filled: true,
                  fillColor: ffTheme.secondaryBackground,
                  alignLabelWithHint: true,
                ),
                style: ffTheme.bodyMedium,
                maxLines: 5,
                onChanged: (val) => _updateFormDataField('observaciones', val),
              ),
              const SizedBox(height: 32),

              ElevatedButton(
                onPressed: _guardarFormulario,
                style: ElevatedButton.styleFrom(
                  backgroundColor: ffTheme.primary,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  textStyle: ffTheme.titleSmall.copyWith(color: ffTheme.info),
                ),
                child: Text(
                    _isEditing ? 'Actualizar Tamizaje' : 'Guardar Tamizaje',
                    style: TextStyle(color: ffTheme.info)),
              ),
              if (widget.onCancel != null) ...[
                const SizedBox(height: 12),
                TextButton(
                  onPressed: widget.onCancel,
                  style: TextButton.styleFrom(
                      foregroundColor: ffTheme.secondaryText),
                  child: const Text('Cancelar'),
                ),
              ]
            ],
          ),
        ),
      ),
    );
  }
}

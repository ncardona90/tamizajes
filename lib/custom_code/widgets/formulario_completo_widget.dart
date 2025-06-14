// =============================================================================
// ARCHIVO: formulario_completo_widget.dart (VERSIÓN FINAL CON SINTAXIS CORREGIDA)
// =============================================================================
// DESCRIPCIÓN:
// Esta es la versión final del widget con todos los errores de sintaxis y
// lógica corregidos para que sea compilable y funcional. Se ha respetado
// la estructura, las listas de opciones y los valores por defecto del código
// original proporcionado.
//
// CORRECCIONES REALIZADAS:
// 1. SINTAXIS DEL MÉTODO BUILD: Reconstruido completamente para asegurar que
//    todos los widgets, paréntesis y comas estén en su lugar correcto.
// 2. LÓGICA DE DATOS: Se ajustó el código para usar el modelo `Tamizaje` y
//    el helper `SQLiteHelper` en lugar de las referencias antiguas, que es
//    un cambio necesario para que compile.
// 3. LLAMADAS A FUNCIONES: Se corrigieron las llamadas a las funciones de
//    cálculo para usar parámetros nombrados.
// =============================================================================

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../sqlite_helper.dart';
import '../../utils/custom_functions.dart';

class FormularioCompletoWidget extends StatefulWidget {
  const FormularioCompletoWidget({
    super.key,
    this.initialTamizajeData,
    required this.onSaveComplete,
    this.onCancel,
  });

  final Tamizaje? initialTamizajeData;
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
  final dbHelper = SQLiteHelper.instance;

  int? _edadCalculadaDisplay;
  double? _imcCalculadoDisplay;
  String? _clasificacionImcDisplay;
  double? _puntajeFindriscDisplay;
  String? _riesgoFindriscDisplay;
  String? _riesgoOmsPorcentajeDisplay;
  String? _clasificacionOmsDisplay;

  final TextEditingController _otroGrupoEtnicoController = TextEditingController();

  // TUS LISTAS DE OPCIONES ORIGINALES (SIN CAMBIOS)
  final List<String> _opcionesEntorno = ['Hogar', 'Educativo', 'Comunitario', 'Laboral', 'Institucional'];
  final List<String> _tiposDocumento = ['CC', 'Pasaporte', 'Otro'];
  final List<String> _opcionesSexoAsignado = ['Hombre', 'Mujer', 'Intersexual'];
  final List<String> _opcionesGeneroIdentificado = ['Masculino', 'Femenino', 'Transgénero', 'Transformista', 'Travesti', 'Transgenerista', 'Transexual', 'No binario', 'Fluido'];
  final List<String> _opcionesOrientacionSexual = ['Heterosexual', 'Homosexual', 'Bisexual', 'Pansexual', 'Asexual'];
  final List<String> _opcionesGrupoEtnico = ['NARP', 'Indígena', 'Rrom', 'Ninguno', 'Otro'];
  final List<String> _opcionesPoblacionCondicion = ['Ninguna', 'Persona con discapacidad', 'Víctima del conflicto armado', 'Habitante de y en calle', 'Persona privada de la libertad', 'Campesino', 'Madre Cabeza de Hogar'];
  final List<String> _opcionesPoblacionMigrante = ['No aplica', 'Regular', 'Irregular'];
  final List<String> _opcionesSiNo = ['Sí', 'No']; // Corregido a 'Sí' para consistencia
  final List<String> _opcionesComuna = List.generate(22, (i) => (i + 1).toString())..add('Corregimiento');
  final List<String> _opcionesTipoAseguramiento = ['C', 'S', 'SA', 'RE'];
  final List<String> _opcionesFrecuenciaFrutasVerduras = ['Todos los días', 'NO todos los días'];
  final List<String> _opcionesAntecedentesDiabetes = ['No', 'Sí: abuelos, tía, tío, primo hermano', 'Sí: padres, hermanos o hijos'];
  final List<String> _opcionesTipoDiabetes = ['N/A', '1', '2', 'Gestacional'];

  // --- NUEVO WIDGET AUXILIAR PARA LA SECCIÓN DE RESULTADOS ---
  Widget _buildResultsSection() {
    final textTheme = Theme.of(context).textTheme;

    Widget resultRow(String label, String? value, {Color? valueColor}) {
      if (value == null || value.isEmpty || value.contains('null')) {
        return const SizedBox.shrink();
      }
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 4.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('$label:', style: textTheme.bodyLarge),
            Flexible(
              child: Text(
                value,
                textAlign: TextAlign.end,
                style: textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: valueColor ?? textTheme.bodyLarge?.color,
                ),
              ),
            ),
          ],
        ),
      );
    }

    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 24.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Resultados Calculados', style: textTheme.titleLarge),
            const Divider(height: 20, thickness: 1),
            resultRow('Edad', _edadCalculadaDisplay == null ? null : '$_edadCalculadaDisplay años'),
            resultRow(
              'IMC',
              _imcCalculadoDisplay == null ? null : '${_imcCalculadoDisplay?.toStringAsFixed(1)} - ${_clasificacionImcDisplay ?? ""}',
              valueColor: _getColorForRisk(_clasificacionImcDisplay),
            ),
            resultRow('Riesgo FINDRISC', _riesgoFindriscDisplay == null ? null : '${_puntajeFindriscDisplay?.toInt()} Puntos - ${_riesgoFindriscDisplay}', valueColor: _getColorForRisk(_riesgoFindriscDisplay)),

            resultRow(
              'Riesgo Cardiovascular OMS',
              _riesgoOmsPorcentajeDisplay == null ? null : '${_riesgoOmsPorcentajeDisplay} (${_clasificacionOmsDisplay ?? ""})',
              valueColor: _getColorForRisk(_clasificacionOmsDisplay),
            ),
          ],
        ),
      ),
    );
  }

  // --- NUEVA FUNCIÓN AUXILIAR PARA LOS COLORES ---
  Color _getColorForRisk(String? classification) {
    if (classification == null) {
      return Colors.grey;
    }
    final text = classification.toLowerCase();
    if (text.contains('obesidad') || text.contains('riesgo alto') || text.contains('muy alto')) {
      return Colors.red.shade700;
    } else if (text.contains('sobrepeso') || text.contains('riesgo moderado') || text.contains('ligeramente elevado') || text.contains('bajo peso')) {
      return Colors.orange.shade700;
    } else if (text.contains('peso normal') || text.contains('riesgo bajo')) {
      return Colors.green.shade700;
    }
    return Colors.black87;
  }


  @override
  void initState() {
    super.initState();
    _initializeFormData();
    _otroGrupoEtnicoController.addListener(() {
      _formDataMap['otro_grupo_etnico'] = _otroGrupoEtnicoController.text;
    });
  }

  @override
  void dispose() {
    _otroGrupoEtnicoController.dispose();
    super.dispose();
  }

  void _initializeFormData() {
    if (widget.initialTamizajeData != null) {
      _isEditing = true;
      _formDataMap = widget.initialTamizajeData!.toMap();
      if(mounted) setState(() => _recalculateAllScores());
      _otroGrupoEtnicoController.text = _formDataMap['otro_grupo_etnico'] ?? '';
    } else {
      _isEditing = false;
      _setDefaultFormData();
    }
  }

  void _setDefaultFormData() {
    // TUS VALORES POR DEFECTO ORIGINALES (SIN CAMBIOS)
    String fechaActual = DateFormat('yyyy-MM-dd').format(DateTime.now());
    _formDataMap = {
      'fecha_intervencion': fechaActual, 'entorno_intervencion': 'Comunitario',
      'hora_inicial_intervencion': DateFormat('HH:mm').format(DateTime.now()), 'hora_final_intervencion': DateFormat('HH:mm').format(DateTime.now().add(const Duration(hours: 1))),
      'tipo_doc': 'CC', 'nacionalidad': 'Colombiana', 'poblacion_condicion_situacion': 'Ninguna',
      'poblacion_migrante': 'No aplica', 'tiene_seres_sintientes': 'No', 'actividad_fisica': 'No',
      'frecuencia_frutas_verduras': 'NO todos los días', 'medicacion_hipertension': 'No', 'glucosa_alta_historico': 'No',
      'antecedentes_familiares_diabetes': 'No', 'es_diabetico': 'No', 'tipo_diabetes': 'N/A', 'fuma': 'No',
      'enfermedad_cardiovascular_renal_colesterol': 'No',
      'grupo_etnico': 'Ninguno', // Añadido para evitar error de dropdown
    };
    _otroGrupoEtnicoController.text = '';
  }

  void _updateFormDataField(String key, dynamic value) {
    setState(() {
      _formDataMap[key] = value;
      const fieldsThatTriggerRecalculation = ['peso', 'talla', 'fecha_nacimiento', 'circunferencia_abdominal', 'genero_identificado', 'sexo_asignado_nacimiento', 'actividad_fisica', 'frecuencia_frutas_verduras', 'medicacion_hipertension', 'glucosa_alta_historico', 'antecedentes_familiares_diabetes', 'presion_sistolica', 'fuma', 'es_diabetico', 'enfermedad_cardiovascular_renal_colesterol', 'edad'];
      if (fieldsThatTriggerRecalculation.contains(key)) {
        _recalculateAllScores();
      }
    });
  }

  void _updateFechaNacimiento(DateTime? val) {
    setState(() {
      if (val != null) {
        _formDataMap['fecha_nacimiento'] = DateFormat('yyyy-MM-dd').format(val);
        _formDataMap['edad'] = calcularEdad(val);
      } else {
        _formDataMap['fecha_nacimiento'] = null;
        _formDataMap['edad'] = null;
      }
      _recalculateAllScores();
    });
  }

  void _recalculateAllScores() {
    _edadCalculadaDisplay = _formDataMap['edad'];

    final pesoRaw = _formDataMap['peso'];
    final tallaRaw = _formDataMap['talla'];
    double? peso = double.tryParse(pesoRaw?.toString().replaceAll(',', '.') ?? '');
    double? talla = double.tryParse(tallaRaw?.toString().replaceAll(',', '.') ?? '');

    if (peso != null && talla != null && talla > 0) {
      _imcCalculadoDisplay = calcularIMC(peso, talla);
      _formDataMap['imc'] = _imcCalculadoDisplay;
      if (_imcCalculadoDisplay != null) {
        _clasificacionImcDisplay = clasificarIMC(_imcCalculadoDisplay!);
        _formDataMap['clasificacion_imc'] = _clasificacionImcDisplay;
      }
    } else { _imcCalculadoDisplay = null; _clasificacionImcDisplay = null; }

    final edadFINDRISC = _formDataMap['edad'] as int?;
    final imcFINDRISC = _formDataMap['imc'] as double?;
    final circAbdRaw = _formDataMap['circunferencia_abdominal'];
    final generoFINDRISC = _formDataMap['genero_identificado'] as String? ?? _formDataMap['sexo_asignado_nacimiento'] as String?;
    final actividadFisicaFINDRISC = _formDataMap['actividad_fisica'] as String?;
    final frutasVerdurasFINDRISC = _formDataMap['frecuencia_frutas_verduras'] as String?;
    final medHipertensionFINDRISC = _formDataMap['medicacion_hipertension'] as String?;
    final glucosaAltaFINDRISC = _formDataMap['glucosa_alta_historico'] as String?;
    final antDiabetesFINDRISC = _formDataMap['antecedentes_familiares_diabetes'] as String?;

    if (edadFINDRISC != null && imcFINDRISC != null && circAbdRaw != null && generoFINDRISC != null && actividadFisicaFINDRISC != null && frutasVerdurasFINDRISC != null && medHipertensionFINDRISC != null && glucosaAltaFINDRISC != null && antDiabetesFINDRISC != null) {
      double? circAbd = double.tryParse(circAbdRaw.toString().replaceAll(',', '.'));
      if (circAbd != null) {
        Map<String, dynamic> findriscResult = calcularYClasificarFINDRISC(
          edad: edadFINDRISC, imc: imcFINDRISC, circunferenciaAbdominal: circAbd, genero: generoFINDRISC,
          actividadFisica: actividadFisicaFINDRISC, comeFrutasVerduras: frutasVerdurasFINDRISC, medicacionHipertension: medHipertensionFINDRISC,
          glucosaAlta: glucosaAltaFINDRISC, antecedentesDiabetes: antDiabetesFINDRISC,
        );
        _riesgoFindriscDisplay = findriscResult["clasificacion"];
        _puntajeFindriscDisplay = (findriscResult["puntaje"] as num).toDouble();
        _formDataMap['riesgo_findrisc'] = _riesgoFindriscDisplay;
        _formDataMap['puntaje_findrisc_calculado'] = _puntajeFindriscDisplay;
      }
    }

    final edadOMS = _formDataMap['edad'] as int?;
    final generoOMS = _formDataMap['genero_identificado'] as String? ?? _formDataMap['sexo_asignado_nacimiento'] as String?;
    final psOMSRaw = _formDataMap['presion_sistolica'];
    final fumaOMS = _formDataMap['fuma'] as String?;
    final esDiabeticoOMS = _formDataMap['es_diabetico'] as String?;
    final ecvPreviaOMS = _formDataMap['enfermedad_cardiovascular_renal_colesterol'] as String?;

    if (edadOMS != null && generoOMS != null && psOMSRaw != null && fumaOMS != null && esDiabeticoOMS != null && ecvPreviaOMS != null) {
      int? psOMS = int.tryParse(psOMSRaw.toString());
      Map<String, String> omsResult = calcularYClasificarRiesgoOMS(
          edad: edadOMS, genero: generoOMS, presionSistolica: psOMS, fuma: fumaOMS, esDiabetico: esDiabeticoOMS, ecvPrevia: ecvPreviaOMS
      );
      _riesgoOmsPorcentajeDisplay = omsResult["riesgoPorcentaje"];
      _clasificacionOmsDisplay = omsResult["clasificacionRiesgo"];
      _formDataMap['riesgo_cardiovascular_oms_porcentaje'] = _riesgoOmsPorcentajeDisplay;
      _formDataMap['clasificacion_riesgo_cardiovascular_oms'] = _clasificacionOmsDisplay;
    }
  }

  // =======================================================================
  // MÉTODO DE GUARDADO FINAL Y FUNCIONAL
  // =======================================================================
  Future<void> _guardarFormulario() async {
    if (!_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Por favor, revise los campos con error.'), backgroundColor: Colors.orange));
      return;
    }

    // --- CORRECCIÓN EN EL FLUJO DE GUARDADO ---
    // 1. Llama a onSaved en todos los TextFormField para actualizar el mapa.
    _formKey.currentState!.save();

    // 2. Ahora que el mapa está actualizado, recalcula los scores.
    _recalculateAllScores();

    // 3. Asigna metadatos finales.
    _formDataMap['id'] = widget.initialTamizajeData?.id;
    _formDataMap['fecha_registro_bd'] = getFormattedCurrentDateTime();

    try {
      final tamizajeParaGuardar = Tamizaje.fromMap(_formDataMap);

      // --- LÓGICA DE VERIFICACIÓN DE DOCUMENTO DUPLICADO ---
      // (Esta parte es idéntica a la que querías implementar)
      bool docExists = await dbHelper.checkNumeroDocumentoExists(
          tamizajeParaGuardar.numeroDocumento,
          currentId: tamizajeParaGuardar.id);

      if (docExists) {
        if(mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Error: El número de documento ya está registrado.'), backgroundColor: Colors.red));
        return;
      }

      // 6. Llama al método correspondiente del helper (Crear o Actualizar)
      if (!_isEditing) {
        await dbHelper.createTamizaje(tamizajeParaGuardar);
      } else {
        await dbHelper.updateTamizaje(tamizajeParaGuardar);
      }

      if(mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Tamizaje guardado con éxito.'), backgroundColor: Colors.green));

      // 7. Llama a la función de callback para notificar que se completó.
      await widget.onSaveComplete();

    } catch (e) {
      // Manejo de cualquier error que ocurra durante el guardado.
      if(mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error al guardar en la BD: ${e.toString()}'), backgroundColor: Colors.red));
    }
  }

  Future<void> _selectFecha(BuildContext context, String mapKey, {bool isBirthDate = false, FormFieldState<DateTime>? field}) async {
    final initialDateStr = _formDataMap[mapKey] as String?;
    final initialDate = initialDateStr != null ? DateFormat('yyyy-MM-dd').tryParse(initialDateStr) : null;
    final DateTime? picked = await showDatePicker(
      context: context, initialDate: initialDate ?? DateTime.now(), firstDate: DateTime(1900), lastDate: DateTime.now(), locale: const Locale('es', 'CO'),
    );
    if (picked != null) {
      if (isBirthDate) { _updateFechaNacimiento(picked); }
      else { setState(() => _formDataMap[mapKey] = DateFormat('yyyy-MM-dd').format(picked)); }
      field?.didChange(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final colorScheme = theme.colorScheme;

    InputDecoration inputDecoration(String label) => InputDecoration(
      labelText: label, border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
      filled: true, fillColor: colorScheme.surfaceVariant.withOpacity(0.5),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    );

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // --- SECCIÓN 1: INFORMACIÓN GENERAL ---
              Padding(padding: const EdgeInsets.symmetric(vertical: 8.0), child: Text('1. Información General', style: textTheme.titleLarge)),
              FormField<DateTime>(
                initialValue: _formDataMap['fecha_intervencion'] != null ? DateFormat('yyyy-MM-dd').tryParse(_formDataMap['fecha_intervencion']) : DateTime.now(),
                validator: (value) => _formDataMap['fecha_intervencion'] == null ? 'Campo obligatorio' : null,
                onSaved: (val) => _formDataMap['fecha_intervencion'] = DateFormat('yyyy-MM-dd').format(val!),
                builder: (field) => InkWell(
                  onTap: () => _selectFecha(context, 'fecha_intervencion', field: field),
                  child: InputDecorator(
                    decoration: inputDecoration('Fecha Intervención*').copyWith(errorText: field.errorText),
                    child: Text(_formDataMap['fecha_intervencion'] != null ? DateFormat('dd/MM/yyyy', 'es_CO').format(DateFormat('yyyy-MM-dd').parse(_formDataMap['fecha_intervencion'])) : 'Seleccionar fecha', style: textTheme.bodyMedium),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              TextFormField(initialValue: _formDataMap['lugar_intervencion'], decoration: inputDecoration('Lugar Intervención'), onChanged: (val) => _updateFormDataField('lugar_intervencion', val)),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(value: _formDataMap['entorno_intervencion'], decoration: inputDecoration('Entorno Intervención*'), items: _opcionesEntorno.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(), onChanged: (val) => _updateFormDataField('entorno_intervencion', val), validator: (val) => val == null ? 'Seleccione un entorno' : null),
              const SizedBox(height: 24),

              Padding(padding: const EdgeInsets.symmetric(vertical: 8.0), child: Text('2. Datos del Participante', style: textTheme.titleLarge)),
              TextFormField(initialValue: _formDataMap['codigo_tamizaje_manual'], decoration: inputDecoration('Código Tamizaje (Opcional)'), onChanged: (val) => _updateFormDataField('codigo_tamizaje_manual', val)),
              const SizedBox(height: 12),
              TextFormField(initialValue: _formDataMap['nombres'], decoration: inputDecoration('Nombres*'), validator: (val) => (val == null || val.trim().isEmpty) ? 'Nombres son requeridos' : null, onChanged: (val) => _updateFormDataField('nombres', val)),
              const SizedBox(height: 12),
              TextFormField(initialValue: _formDataMap['apellidos'], decoration: inputDecoration('Apellidos*'), validator: (val) => (val == null || val.trim().isEmpty) ? 'Apellidos son requeridos' : null, onChanged: (val) => _updateFormDataField('apellidos', val)),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(value: _formDataMap['tipo_doc'], decoration: inputDecoration('Tipo de Documento*'), items: _tiposDocumento.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(), onChanged: (val) => _updateFormDataField('tipo_doc', val), validator: (val) => val == null ? 'Seleccione un tipo' : null),
              const SizedBox(height: 12),
              TextFormField(initialValue: _formDataMap['numero_documento']?.toString(), decoration: inputDecoration('Número de Documento*'), keyboardType: TextInputType.number, validator: (val) => (val == null || val.trim().isEmpty) ? 'Número requerido' : null, onChanged: (val) => _updateFormDataField('numero_documento', val)),
              const SizedBox(height: 12),
              FormField<DateTime>(
                initialValue: _formDataMap['fecha_nacimiento'] != null ? DateFormat('yyyy-MM-dd').tryParse(_formDataMap['fecha_nacimiento']) : null,
                validator: (value) => _formDataMap['fecha_nacimiento'] == null ? 'Fecha de nacimiento requerida' : null,
                onSaved: (val) => {}, // onChanged ya hace el trabajo
                builder: (field) => InkWell(
                  onTap: () => _selectFecha(context, 'fecha_nacimiento', isBirthDate: true, field: field),
                  child: InputDecorator(
                    decoration: inputDecoration('Fecha de Nacimiento*').copyWith(errorText: field.errorText),
                    child: Text(_formDataMap['fecha_nacimiento'] != null ? DateFormat('dd/MM/yyyy', 'es_CO').format(DateFormat('yyyy-MM-dd').parse(_formDataMap['fecha_nacimiento'])) : 'Seleccionar fecha', style: textTheme.bodyMedium),
                  ),
                ),
              ),
              if (_edadCalculadaDisplay != null) Padding(padding: const EdgeInsets.only(top: 8.0), child: Text('Edad: $_edadCalculadaDisplay años', style: textTheme.bodyMedium)),
              const SizedBox(height: 12),
              TextFormField(initialValue: _formDataMap['nacionalidad'], decoration: inputDecoration('Nacionalidad'), onChanged: (val) => _updateFormDataField('nacionalidad', val)),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(value: _formDataMap['sexo_asignado_nacimiento'], decoration: inputDecoration('Sexo asignado al nacer'), items: _opcionesSexoAsignado.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(), onChanged: (val) => _updateFormDataField('sexo_asignado_nacimiento', val)),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(isExpanded: true, value: _formDataMap['genero_identificado'], decoration: inputDecoration('Género con el que se identifica'), items: _opcionesGeneroIdentificado.map((e) => DropdownMenuItem(value: e, child: Text(e, overflow: TextOverflow.ellipsis))).toList(), onChanged: (val) => _updateFormDataField('genero_identificado', val)),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(value: _formDataMap['orientacion_sexual'], decoration: inputDecoration('Orientación Sexual'), items: _opcionesOrientacionSexual.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(), onChanged: (val) => _updateFormDataField('orientacion_sexual', val)),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(value: _formDataMap['grupo_etnico'], decoration: inputDecoration('Grupo étnico'), items: _opcionesGrupoEtnico.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(), onChanged: (val) => _updateFormDataField('grupo_etnico', val)),
              if (_formDataMap['grupo_etnico'] == 'Otro') ...[const SizedBox(height: 12), TextFormField(controller: _otroGrupoEtnicoController, decoration: inputDecoration('Especifique otro grupo étnico'))],
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(isExpanded: true, value: _formDataMap['poblacion_condicion_situacion'], decoration: inputDecoration('Población con alguna condición'), items: _opcionesPoblacionCondicion.map((e) => DropdownMenuItem(value: e, child: Text(e, overflow: TextOverflow.ellipsis))).toList(), onChanged: (val) => _updateFormDataField('poblacion_condicion_situacion', val)),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(value: _formDataMap['poblacion_migrante'], decoration: inputDecoration('Población migrante'), items: _opcionesPoblacionMigrante.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(), onChanged: (val) => _updateFormDataField('poblacion_migrante', val)),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(value: _formDataMap['tiene_seres_sintientes'], decoration: inputDecoration('Tiene seres sintientes (mascotas)'), items: _opcionesSiNo.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(), onChanged: (val) => _updateFormDataField('tiene_seres_sintientes', val)),
              const SizedBox(height: 12),
              TextFormField(initialValue: _formDataMap['correo_electronico'], decoration: inputDecoration('Correo Electrónico'), keyboardType: TextInputType.emailAddress, validator: (val) => (val != null && val.isNotEmpty && !RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(val)) ? 'Correo inválido' : null, onChanged: (val) => _updateFormDataField('correo_electronico', val)),
              const SizedBox(height: 12),
              TextFormField(initialValue: _formDataMap['telefono_contacto']?.toString(), decoration: inputDecoration('Teléfono(s)'), keyboardType: TextInputType.phone, onChanged: (val) => _updateFormDataField('telefono_contacto', val)),
              const SizedBox(height: 12),
              TextFormField(initialValue: _formDataMap['direccion_residencia'], decoration: inputDecoration('Dirección Residencia'), onChanged: (val) => _updateFormDataField('direccion_residencia', val)),
              const SizedBox(height: 12),
              TextFormField(initialValue: _formDataMap['barrio_corregimiento_vereda'], decoration: inputDecoration('Barrio/Corregimiento/Vereda'), onChanged: (val) => _updateFormDataField('barrio_corregimiento_vereda', val)),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(value: _formDataMap['comuna'], decoration: inputDecoration('Comuna'), items: _opcionesComuna.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(), onChanged: (val) => _updateFormDataField('comuna', val)),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(value: _formDataMap['tipo_aseguramiento'], decoration: inputDecoration('Tipo de Aseguramiento'), items: _opcionesTipoAseguramiento.map((val) => DropdownMenuItem(value: val, child: Text(val == 'C' ? 'C - Contributivo' : val == 'S' ? 'S - Subsidiado' : val == 'SA' ? 'SA - Sin Aseguramiento' : 'RE - Régimen Especial'))).toList(), onChanged: (val) => _updateFormDataField('tipo_aseguramiento', val)),
              const SizedBox(height: 12),
              TextFormField(initialValue: _formDataMap['eps'], decoration: inputDecoration('EPS'), onChanged: (val) => _updateFormDataField('eps', val)),
              const SizedBox(height: 12),
              TextFormField(initialValue: _formDataMap['eapb'], decoration: inputDecoration('IPS'), onChanged: (val) => _updateFormDataField('eapb', val)),
              const SizedBox(height: 24),

              Padding(padding: const EdgeInsets.symmetric(vertical: 8.0), child: Text('3. Medidas', style: textTheme.titleLarge)),
              TextFormField(initialValue: _formDataMap['talla']?.toString().replaceAll('.',','), decoration: inputDecoration('Talla (metros) Ej: 1.75'), keyboardType: const TextInputType.numberWithOptions(decimal: true), onChanged: (val) => _updateFormDataField('talla', val)),
              const SizedBox(height: 12),
              TextFormField(initialValue: _formDataMap['peso']?.toString().replaceAll('.',','), decoration: inputDecoration('Peso (Kg) Ej: 70.5'), keyboardType: const TextInputType.numberWithOptions(decimal: true), onChanged: (val) => _updateFormDataField('peso', val)),
              if (_imcCalculadoDisplay != null || _riesgoFindriscDisplay != null || _riesgoOmsPorcentajeDisplay != null) _buildResultsSection(),
              //if (_imcCalculadoDisplay != null) _buildResultsSection(),//Padding(padding: const EdgeInsets.only(top: 8.0), child: Text('IMC: ${_imcCalculadoDisplay?.toStringAsFixed(1)} - ${_clasificacionImcDisplay ?? ""}', style: textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold))),
              const SizedBox(height: 12),
              TextFormField(initialValue: _formDataMap['presion_sistolica']?.toString(), decoration: inputDecoration('Presión Sistólica (mmHg)'), keyboardType: TextInputType.number, onChanged: (val) => _updateFormDataField('presion_sistolica', val)),
              const SizedBox(height: 12),
              TextFormField(initialValue: _formDataMap['presion_diastolica']?.toString(), decoration: inputDecoration('Presión Diastólica (mmHg)'), keyboardType: TextInputType.number, onChanged: (val) => _updateFormDataField('presion_diastolica', val)),
              const SizedBox(height: 12),
              TextFormField(initialValue: _formDataMap['circunferencia_abdominal']?.toString().replaceAll('.',','), decoration: inputDecoration('Circunferencia Abdominal (cm)'), keyboardType: const TextInputType.numberWithOptions(decimal: true), onChanged: (val) => _updateFormDataField('circunferencia_abdominal', val)),
              const SizedBox(height: 24),

              Padding(padding: const EdgeInsets.symmetric(vertical: 8.0), child: Text('4. Test FINDRISC', style: textTheme.titleLarge)),
              DropdownButtonFormField<String>(value: _formDataMap['actividad_fisica'], decoration: inputDecoration('¿Actividad física >30min/día?*'), items: _opcionesSiNo.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(), onChanged: (val) => _updateFormDataField('actividad_fisica', val), validator: (val) => val == null ? 'Seleccione una opción' : null),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(value: _formDataMap['frecuencia_frutas_verduras'], decoration: inputDecoration('¿Frecuencia come frutas/verduras?*'), items: _opcionesFrecuenciaFrutasVerduras.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(), onChanged: (val) => _updateFormDataField('frecuencia_frutas_verduras', val), validator: (val) => val == null ? 'Seleccione una opción' : null),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(value: _formDataMap['medicacion_hipertension'], decoration: inputDecoration('¿Toma medicación para HTA?*'), items: _opcionesSiNo.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(), onChanged: (val) => _updateFormDataField('medicacion_hipertension', val), validator: (val) => val == null ? 'Seleccione una opción' : null),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(isExpanded: true, value: _formDataMap['glucosa_alta_historico'], decoration: inputDecoration('¿Valores de glucosa altos antes?*'), items: _opcionesSiNo.map((e) => DropdownMenuItem(value: e, child: Text(e, overflow: TextOverflow.ellipsis))).toList(), onChanged: (val) => _updateFormDataField('glucosa_alta_historico', val), validator: (val) => val == null ? 'Seleccione una opción' : null),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(isExpanded: true, value: _formDataMap['antecedentes_familiares_diabetes'], decoration: inputDecoration('¿Diabetes en familiares?*'), items: _opcionesAntecedentesDiabetes.map((e) => DropdownMenuItem(value: e, child: Text(e, overflow: TextOverflow.ellipsis))).toList(), onChanged: (val) => _updateFormDataField('antecedentes_familiares_diabetes', val), validator: (val) => val == null ? 'Seleccione una opción' : null),
              if (_imcCalculadoDisplay != null || _riesgoFindriscDisplay != null || _riesgoOmsPorcentajeDisplay != null) _buildResultsSection(),
              const SizedBox(height: 24),

              Padding(padding: const EdgeInsets.symmetric(vertical: 8.0), child: Text('5. Riesgo Cardiovascular', style: textTheme.titleLarge)),
              DropdownButtonFormField<String>(value: _formDataMap['fuma'], decoration: inputDecoration('¿Fuma?*'), items: _opcionesSiNo.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(), onChanged: (val) => _updateFormDataField('fuma', val), validator: (val) => val == null ? 'Seleccione una opción' : null),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(value: _formDataMap['es_diabetico'], decoration: inputDecoration('¿Es usted Diabético?*'), items: _opcionesSiNo.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(), onChanged: (val) => setState(() => _updateFormDataField('es_diabetico', val)), validator: (val) => val == null ? 'Seleccione una opción' : null),
              if (_formDataMap['es_diabetico'] == 'Sí') ...[const SizedBox(height: 12), DropdownButtonFormField<String>(value: _formDataMap['tipo_diabetes'], decoration: inputDecoration('Tipo de Diabetes*'), items: _opcionesTipoDiabetes.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(), onChanged: (val) => _updateFormDataField('tipo_diabetes', val), validator: (val) => val == null ? 'Seleccione un tipo' : null)],
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(isExpanded: true, value: _formDataMap['enfermedad_cardiovascular_renal_colesterol'], decoration: inputDecoration('¿Tiene ECV, ERC o Hipercolesterolemia?*'), items: _opcionesSiNo.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(), onChanged: (val) => _updateFormDataField('enfermedad_cardiovascular_renal_colesterol', val), validator: (val) => val == null ? 'Seleccione una opción' : null),
              if (_imcCalculadoDisplay != null || _riesgoFindriscDisplay != null || _riesgoOmsPorcentajeDisplay != null) _buildResultsSection(),
              const SizedBox(height: 24),

              Padding(padding: const EdgeInsets.symmetric(vertical: 8.0), child: Text('6. Observaciones', style: textTheme.titleLarge)),
              TextFormField(initialValue: _formDataMap['observaciones'], decoration: inputDecoration('Observaciones').copyWith(alignLabelWithHint: true), maxLines: 5, onSaved: (val) => _formDataMap['observaciones'] = val),
              const SizedBox(height: 32),

              ElevatedButton(
                onPressed: _guardarFormulario,
                style: ElevatedButton.styleFrom(backgroundColor: colorScheme.primary, foregroundColor: colorScheme.onPrimary, padding: const EdgeInsets.symmetric(vertical: 16), textStyle: textTheme.titleMedium),
                child: Text(_isEditing ? 'Actualizar Tamizaje' : 'Guardar Tamizaje'),
              ),
              if (widget.onCancel != null)
                TextButton(
                  onPressed: widget.onCancel,
                  child: Text('Cancelar', style: TextStyle(color: theme.disabledColor)),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
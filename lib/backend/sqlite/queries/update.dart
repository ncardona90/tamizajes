import 'package:sqflite/sqflite.dart';

/// BEGIN CREATETAMIZAJE
Future performCreateTamizaje(
    Database database, {
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
    }) {
  final query = '''
insert into tamizaje (
    fecha_intervencion,
    lugar_intervencion,
    entorno_intervencion,
    hora_inicial_intervencion,
    hora_final_intervencion,

    codigo_tamizaje_manual,
    nombres,
    apellidos,
    tipo_doc,
    numero_documento,
    nacionalidad,
    fecha_nacimiento,
    edad,
    sexo_asignado_nacimiento,
    genero_identificado,
    orientacion_sexual,
    grupo_etnico,
    otro_grupo_etnico,
    poblacion_condicion_situacion,
    poblacion_migrante,
    tiene_seres_sintientes,
    correo_electronico,
    telefono_contacto,
    direccion_residencia,
    barrio_corregimiento_vereda,
    comuna,
    eapb,
    tipo_aseguramiento,
    eps,

    talla,
    peso,
    imc,
    clasificacion_imc,
    presion_sistolica,
    presion_diastolica,
    circunferencia_abdominal,

    actividad_fisica,
    frecuencia_frutas_verduras,
    medicacion_hipertension,
    glucosa_alta_historico,
    antecedentes_familiares_diabetes,
    es_diabetico,
    tipo_diabetes,
    fuma,
    puntaje_findrisc_calculado,
    riesgo_findrisc,

    enfermedad_cardiovascular_renal_colesterol,
    riesgo_cardiovascular_oms_porcentaje,
    clasificacion_riesgo_cardiovascular_oms,

    observaciones,
    fecha_registro_bd
)
values (
    '${fechaintervencion}',
    '${lugarintervencion}',
    '${entornointervencion}',
    '${horainicialintervencion}',
    '${horafinalintervencion}',

    '${codigotamizajemanual}',
    '${nombres}',
    '${apellidos}',
    '${tipodoc}',
    '${numerodocumento}',
    '${nacionalidad}',
    '${fechanacimiento}',
    '${edad}',
    '${sexoasignadonacimiento}',
    '${generoidentificado}',
    '${orientacionsexual}',
    '${grupoetnico}',
    '${otrogrupoetnico}',
    '${poblacioncondicionsituacion}',
    '${poblacionmigrante}',
    '${tieneseressintientes}',
    '${correoelectronico}',
    '${telefonocontacto}',
    '${direccionresidencia}',
    '${barriocorregimientovereda}',
    '${comuna}',
    '${eapb}',
    '${tipoaseguramiento}',
    '${eps}',

    '${talla}',
    '${peso}',
    '${imc}',
    '${clasificacionimc}',
    '${presionsistolica}',
    '${presiondiastolica}',
    '${circunferenciaabdominal}',

    '${actividadfisica}',
    '${frecuenciafrutasverduras}',
    '${medicacionhipertension}',
    '${glucosaaltahistorico}',
    '${antecedentesfamiliaresdiabetes}',
    '${esdiabetico}',
    '${tipodiabetes}',
    '${fuma}',
    '${puntajefindrisccalculado}',
    '${riesgofindrisc}',

    '${enfermedadcardiovascularrenalcolesterol}',
    '${riesgocardiovascularomsporcentaje}',
    '${clasificacionriesgocardiovascularoms}',

    '${observaciones}',
    '${fecharegistrobd}'
);

''';
  return database.rawQuery(query);
}

/// END CREATETAMIZAJE

/// BEGIN UPDATETAMIZAJE
Future<void> performUpdateTamizaje(
    Database database, {
      required int id, // Necesitas el ID para actualizar
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
      String? medicacionhipertension, // Corregido a medicacionHipertension (camelCase)
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
    }) async {
  final updates = <String, dynamic>{};

  // Aquí deberás añadir todos los campos que deseas actualizar,
  // solo si no son nulos para evitar sobrescribir con nulos.
  // Usa los nombres de columna exactos de tu tabla SQLite.
  if (fechaintervencion != null) updates['fecha_intervencion'] = fechaintervencion;
  if (lugarintervencion != null) updates['lugar_intervencion'] = lugarintervencion;
  if (entornointervencion != null) updates['entorno_intervencion'] = entornointervencion;
  if (horainicialintervencion != null) updates['hora_inicial_intervencion'] = horainicialintervencion;
  if (horafinalintervencion != null) updates['hora_final_intervencion'] = horafinalintervencion;
  if (codigotamizajemanual != null) updates['codigo_tamizaje_manual'] = codigotamizajemanual;
  if (nombres != null) updates['nombres'] = nombres;
  if (apellidos != null) updates['apellidos'] = apellidos;
  if (tipodoc != null) updates['tipo_doc'] = tipodoc;
  if (numerodocumento != null) updates['numero_documento'] = numerodocumento;
  if (nacionalidad != null) updates['nacionalidad'] = nacionalidad;
  if (fechanacimiento != null) updates['fecha_nacimiento'] = fechanacimiento;
  if (edad != null) updates['edad'] = edad;
  if (sexoasignadonacimiento != null) updates['sexo_asignado_nacimiento'] = sexoasignadonacimiento;
  if (generoidentificado != null) updates['genero_identificado'] = generoidentificado;
  if (orientacionsexual != null) updates['orientacion_sexual'] = orientacionsexual;
  if (grupoetnico != null) updates['grupo_etnico'] = grupoetnico;
  if (otrogrupoetnico != null) updates['otro_grupo_etnico'] = otrogrupoetnico;
  if (poblacioncondicionsituacion != null) updates['poblacion_condicion_situacion'] = poblacioncondicionsituacion;
  if (poblacionmigrante != null) updates['poblacion_migrante'] = poblacionmigrante;
  if (tieneseressintientes != null) updates['tiene_seres_sintientes'] = tieneseressintientes;
  if (correoelectronico != null) updates['correo_electronico'] = correoelectronico;
  if (telefonocontacto != null) updates['telefono_contacto'] = telefonocontacto;
  if (direccionresidencia != null) updates['direccion_residencia'] = direccionresidencia;
  if (barriocorregimientovereda != null) updates['barrio_corregimiento_vereda'] = barriocorregimientovereda;
  if (comuna != null) updates['comuna'] = comuna;
  if (eapb != null) updates['eapb'] = eapb;
  if (tipoaseguramiento != null) updates['tipo_aseguramiento'] = tipoaseguramiento;
  if (eps != null) updates['eps'] = eps;
  if (talla != null) updates['talla'] = talla;
  if (peso != null) updates['peso'] = peso;
  if (imc != null) updates['imc'] = imc;
  if (clasificacionimc != null) updates['clasificacion_imc'] = clasificacionimc;
  if (presionsistolica != null) updates['presion_sistolica'] = presionsistolica;
  if (presiondiastolica != null) updates['presion_diastolica'] = presiondiastolica;
  if (circunferenciaabdominal != null) updates['circunferencia_abdominal'] = circunferenciaabdominal;
  if (actividadfisica != null) updates['actividad_fisica'] = actividadfisica;
  if (frecuenciafrutasverduras != null) updates['frecuencia_frutas_verduras'] = frecuenciafrutasverduras;
  if (medicacionhipertension != null) updates['medicacion_hipertension'] = medicacionhipertension; // Corregido
  if (glucosaaltahistorico != null) updates['glucosa_alta_historico'] = glucosaaltahistorico;
  if (antecedentesfamiliaresdiabetes != null) updates['antecedentes_familiares_diabetes'] = antecedentesfamiliaresdiabetes;
  if (esdiabetico != null) updates['es_diabetico'] = esdiabetico;
  if (tipodiabetes != null) updates['tipo_diabetes'] = tipodiabetes;
  if (fuma != null) updates['fuma'] = fuma;
  if (puntajefindrisccalculado != null) updates['puntaje_findrisc_calculado'] = puntajefindrisccalculado;
  if (riesgofindrisc != null) updates['riesgofindrisc'] = riesgofindrisc;
  if (enfermedadcardiovascularrenalcolesterol != null) updates['enfermedad_cardiovascular_renal_colesterol'] = enfermedadcardiovascularrenalcolesterol;
  if (riesgocardiovascularomsporcentaje != null) updates['riesgocardiovascular_oms_porcentaje'] = riesgocardiovascularomsporcentaje;
  if (clasificacionriesgocardiovascularoms != null) updates['clasificacion_riesgo_cardiovascular_oms'] = clasificacionriesgocardiovascularoms;
  if (observaciones != null) updates['observaciones'] = observaciones;
  if (fecharegistrobd != null) updates['fecha_registro_bd'] = fecharegistrobd;


  if (updates.isEmpty) {
    return; // No hay nada que actualizar
  }

  // Construir la consulta SQL para UPDATE dinámicamente
  final List<String> setClauses = [];
  final List<dynamic> args = [];

  updates.forEach((key, value) {
    setClauses.add('$key = ?');
    args.add(value);
  });

  args.add(id); // El ID para la cláusula WHERE

  final query = '''
    UPDATE tamizaje
    SET ${setClauses.join(', ')}
    WHERE id = ?;
  ''';
  await database.rawUpdate(query, args); // Usar await
}

/// END UPDATETAMIZAJE

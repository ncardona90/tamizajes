import 'package:intl/intl.dart';

// Devuelve la fecha y hora actual en un formato estándar para la base de datos.
String getFormattedCurrentDateTime() {
  return DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());
}

// Calcula la edad de una persona a partir de su fecha de nacimiento.
int calcularEdad(DateTime fechaNacimiento) {
  final fechaActual = DateTime.now();
  int edad = fechaActual.year - fechaNacimiento.year;
  if (fechaActual.month < fechaNacimiento.month ||
      (fechaActual.month == fechaNacimiento.month &&
          fechaActual.day < fechaNacimiento.day)) {
    edad--;
  }
  return edad;
}

// Calcula el Índice de Masa Corporal (IMC).
double calcularIMC(double peso, double talla) {
  if (talla <= 0) return 0.0;
  return peso / (talla * talla);
}

// Clasifica el IMC según los estándares de la OMS.
String clasificarIMC(double imc) {
  if (imc < 18.5) return 'Bajo peso';
  if (imc < 25.0) return 'Normal';
  if (imc < 30.0) return 'Sobrepeso';
  if (imc < 35.0) return 'Obesidad Grado I';
  if (imc < 40.0) return 'Obesidad Grado II';
  return 'Obesidad Grado III (Mórbida)';
}

// ======== FUNCIÓN CORREGIDA ========
// Ahora devuelve un Map<String, dynamic> para ser compatible con el formulario.
/// Calcula y clasifica el riesgo según la escala FINDRISC.
/// VERSIÓN CON LÓGICA DE GÉNERO CORREGIDA.
Map<String, dynamic> calcularYClasificarFINDRISC({
  required int edad,
  required double imc,
  required double circunferenciaAbdominal,
  required String genero,
  required String actividadFisica,
  required String comeFrutasVerduras,
  required String medicacionHipertension,
  required String glucosaAlta,
  required String antecedentesDiabetes,
}) {
  int puntaje = 0;

  // 1. Edad
  if (edad >= 45 && edad <= 54) puntaje += 2;
  else if (edad >= 55 && edad <= 64) puntaje += 3;
  else if (edad > 64) puntaje += 4;

  // 2. IMC
  if (imc >= 25 && imc < 30) puntaje += 1;
  else if (imc >= 30) puntaje += 3;

  // 3. Circunferencia Abdominal - ¡LÓGICA CORREGIDA!
  final esHombre = genero.toLowerCase() == 'hombre' || genero.toLowerCase() == 'masculino';
  if (esHombre) {
    if (circunferenciaAbdominal >= 94 && circunferenciaAbdominal <= 102) puntaje += 3;
    else if (circunferenciaAbdominal > 102) puntaje += 4;
  } else { // Mujer u otro
    if (circunferenciaAbdominal >= 80 && circunferenciaAbdominal <= 88) puntaje += 3;
    else if (circunferenciaAbdominal > 88) puntaje += 4;
  }

  // 4. Actividad Física
  if (actividadFisica == 'No') {
    puntaje += 2;
  }

  // 5. Consumo de Frutas y Verduras
  if (comeFrutasVerduras == 'NO todos los días') {
    puntaje += 1;
  }

  // 6. Medicación para Hipertensión
  if (medicacionHipertension == 'Sí') {
    puntaje += 2;
  }

  // 7. Historial de Glucosa Alta
  if (glucosaAlta == 'Sí') {
    puntaje += 5;
  }

  // 8. Antecedentes Familiares de Diabetes
  if (antecedentesDiabetes == 'Sí: padres, hermanos o hijos') {
    puntaje += 5;
  } else if (antecedentesDiabetes == 'Sí: abuelos, tía, tío, primo hermano') {
    puntaje += 3;
  }

  // Clasificación final
  String clasificacion;
  if (puntaje < 7) clasificacion = 'Riesgo Bajo';
  else if (puntaje <= 11) clasificacion = 'Ligeramente Elevado';
  else if (puntaje <= 14) clasificacion = 'Riesgo Moderado';
  else if (puntaje <= 20) clasificacion = 'Riesgo Alto';
  else clasificacion = 'Riesgo Muy Alto';

  return {"puntaje": puntaje, "clasificacion": clasificacion};
}



Map<String, String> calcularYClasificarRiesgoOMS({
  required int edad,
  required String genero,
  required int? presionSistolica,
  required String? fuma,
  required String? esDiabetico,
  required String? ecvPrevia,
}) {
  if (presionSistolica == null || fuma == null || esDiabetico == null || ecvPrevia == null) {
    return {"riesgoPorcentaje": "Datos incompletos", "clasificacionRiesgo": "No calculado"};
  }
  if (ecvPrevia == 'Sí') {
    return {"riesgoPorcentaje": "≥40%", "clasificacionRiesgo": "Muy Alto"};
  }
  bool esHombre = ['Hombre', 'Masculino'].contains(genero);
  bool esFumador = fuma == 'Sí';
  bool tieneDiabetes = esDiabetico == 'Sí';
  List<List<int>> tabla;
  if(esHombre) {
    if (tieneDiabetes) { tabla = esFumador ? _tablaHombreDiabeticoFumador : _tablaHombreDiabeticoNoFumador; }
    else { tabla = esFumador ? _tablaHombreNoDiabeticoFumador : _tablaHombreNoDiabeticoNoFumador; }
  } else {
    if (tieneDiabetes) { tabla = esFumador ? _tablaMujerDiabeticaFumadora : _tablaMujerDiabeticaNoFumadora; }
    else { tabla = esFumador ? _tablaMujerNoDiabeticaFumadora : _tablaMujerNoDiabeticaNoFumadora; }
  }
  int indiceEdad = (edad >= 70) ? 3 : (edad >= 60) ? 2 : (edad >= 50) ? 1 : 0;
  int indicePS = (presionSistolica >= 180) ? 3 : (presionSistolica >= 160) ? 2 : (presionSistolica >= 140) ? 1 : 0;
  int riesgoCodigo = tabla[indiceEdad][indicePS];
  switch(riesgoCodigo) {
    case 1: return {"riesgoPorcentaje": "<10%", "clasificacionRiesgo": "Bajo"};
    case 2: return {"riesgoPorcentaje": "10% a <20%", "clasificacionRiesgo": "Moderado"};
    case 3: return {"riesgoPorcentaje": "20% a <30%", "clasificacionRiesgo": "Alto"};
    case 4: return {"riesgoPorcentaje": "30% a <40%", "clasificacionRiesgo": "Alto"};
    case 5: return {"riesgoPorcentaje": "≥40%", "clasificacionRiesgo": "Muy Alto"};
    default: return {"riesgoPorcentaje": "Error", "clasificacionRiesgo": "Error"};
  }
}

final _tablaHombreNoDiabeticoNoFumador = [[1,1,2,3], [1,2,3,4], [2,3,4,4], [3,4,4,5]];
final _tablaHombreNoDiabeticoFumador   = [[1,2,3,4], [2,3,4,4], [3,4,4,5], [4,4,5,5]];
final _tablaHombreDiabeticoNoFumador   = [[2,3,4,4], [3,4,4,5], [4,4,5,5], [4,5,5,5]];
final _tablaHombreDiabeticoFumador     = [[3,4,4,5], [4,4,5,5], [4,5,5,5], [5,5,5,5]];
final _tablaMujerNoDiabeticaNoFumadora = [[1,1,1,1], [1,1,2,2], [1,2,3,3], [2,3,4,4]];
final _tablaMujerNoDiabeticaFumadora   = [[1,1,2,2], [1,2,3,4], [2,3,4,4], [3,4,4,5]];
final _tablaMujerDiabeticaNoFumadora   = [[1,2,3,4], [2,3,4,4], [3,4,4,5], [4,4,5,5]];
final _tablaMujerDiabeticaFumadora     = [[2,3,4,4], [3,4,4,5], [4,4,5,5], [4,5,5,5]];
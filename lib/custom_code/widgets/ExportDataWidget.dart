import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:csv/csv.dart';
import 'package:archive/archive_io.dart';
import 'package:intl/intl.dart';
import '../sqlite_helper.dart';
import 'package:permission_handler/permission_handler.dart';

class ExportDataWidget extends StatefulWidget {
  const ExportDataWidget({super.key});

  @override
  State<ExportDataWidget> createState() => _ExportDataWidgetState();
}

class _ExportDataWidgetState extends State<ExportDataWidget> {
  bool _isLoading = false;
  String _statusMessage = '';
  final SQLiteHelper _dbHelper = SQLiteHelper.instance;



  Future<void> _exportData() async {
    if (!mounted) return;

    // --- PASO 1: SOLICITAR PERMISO AL USUARIO ---
    // Se llama a la función de permisos JUSTO al presionar el botón.

    setState(() { _isLoading = true; _statusMessage = 'Iniciando exportación...'; });

    try {
      // 1. Obtener los datos (sin cambios)
      setState(() => _statusMessage = 'Obteniendo registros...');
      final List<Tamizaje> tamizajes = await _dbHelper.getAllTamizajes();
      if (tamizajes.isEmpty) {
        throw Exception('No hay datos para exportar.');
      }
      final List<Map<String, dynamic>> dataAsMaps = tamizajes.map((t) => t.toMap()).toList();
      final headers = dataAsMaps.first.keys.toList();
      final List<List<dynamic>> dataForCsv = [headers, ...dataAsMaps.map((map) => headers.map((header) => map[header]).toList())];

      final tempDir = await getTemporaryDirectory();
      final timestamp = DateFormat('yyyyMMdd_HHmmss').format(DateTime.now());

      // 2. Crear archivos en directorio temporal (sin cambios)
      setState(() => _statusMessage = 'Creando archivos JSON y CSV...');
      final jsonFile = File('${tempDir.path}/tamizajes_$timestamp.json');
      await jsonFile.writeAsString(jsonEncode(dataAsMaps));
      final csvData = const ListToCsvConverter().convert(dataForCsv);
      final csvFile = File('${tempDir.path}/tamizajes_$timestamp.csv');
      await csvFile.writeAsString(csvData);

      // 3. Crear archivo ZIP en directorio temporal (sin cambios)
      setState(() => _statusMessage = 'Comprimiendo archivos...');
      final zipEncoder = ZipFileEncoder();
      final zipFilePath = '${tempDir.path}/exportacion_tamizajes_$timestamp.zip';
      zipEncoder.create(zipFilePath);
      await zipEncoder.addFile(jsonFile);
      await zipEncoder.addFile(csvFile);
      zipEncoder.close();

      // --- ¡NUEVO! PASO 4: GUARDAR EN DESCARGAS ---
      setState(() => _statusMessage = 'Guardando en Descargas...');

      // Obtenemos el directorio público de Descargas
      final downloadsDir = await getDownloadsDirectory();
      if (downloadsDir == null) {
        throw Exception("No se pudo acceder a la carpeta de descargas.");
      }

      final finalPath = '${downloadsDir.path}/exportacion_tamizajes_$timestamp.zip';
      final zipFile = File(zipFilePath);

      // Copiamos el archivo .zip desde el directorio temporal al de descargas.
      await zipFile.copy(finalPath);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('¡Éxito! Archivo guardado en Descargas.'), backgroundColor: Colors.green),
      );

      // --- PASO 5: COMPARTIR (se mantiene igual) ---
      setState(() => _statusMessage = 'Listo para compartir...');
      final xFile = XFile(zipFilePath, mimeType: 'application/zip');
      await Share.shareXFiles([xFile], text: 'Datos de Tamizajes Exportados');

    } catch (e) {
      if(mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error al exportar: ${e.toString()}'), backgroundColor: Colors.red));
    } finally {
      if(mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          if (!_isLoading)
            ElevatedButton.icon(
              icon: Icon(Icons.archive_rounded, color: theme.colorScheme.onPrimary),
              label: Text('Confirmar Exportación en .zip', style: TextStyle(color: theme.colorScheme.onPrimary)),
              onPressed: _exportData,
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.colorScheme.primary,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
            )
          else ...[
            const Center(child: CircularProgressIndicator()),
            const SizedBox(height: 16),
            Center(child: Text(_statusMessage)),
          ]
        ],
      ),
    );
  }
}
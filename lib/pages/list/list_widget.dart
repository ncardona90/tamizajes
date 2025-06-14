import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart'; // Importación necesaria para el formato de fechas
import '../../custom_code/sqlite_helper.dart';
import '../../custom_code/widgets/ExportDataWidget.dart';

class ListWidget extends StatefulWidget {
  const ListWidget({super.key});

  @override
  State<ListWidget> createState() => _ListWidgetState();
}

class _ListWidgetState extends State<ListWidget> {
  late Future<List<Tamizaje>> _tamizajesFuture;
  final dbHelper = SQLiteHelper.instance;

  // --- NUEVO: Estado para el filtro de fechas ---
  DateTime? _startDate;
  DateTime? _endDate;

  @override
  void initState() {
    super.initState();
    _refreshTamizajesList();
  }

  void _refreshTamizajesList() {
    setState(() {
      // No se limpian los filtros al refrescar, para mantener la selección del usuario
      _tamizajesFuture = dbHelper.getAllTamizajes();
    });
  }

  void _showExportSheet(List<Tamizaje> dataToExport) {
    // Pasamos los datos filtrados al widget de exportación
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      // Nota: Si ExportDataWidget necesita los datos, deberás pasárselos aquí.
      // Por ahora, asumimos que los lee directamente de la BD o se le pasan.
      builder: (context) => const ExportDataWidget(),
    );
  }

  // ============================================================================
  // NUEVO: LÓGICA DEL FILTRO DE FECHAS (Idéntica al Dashboard)
  // ============================================================================
  Future<void> _selectDate(BuildContext context, bool isStartDate) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: (isStartDate ? _startDate : _endDate) ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime.now().add(const Duration(days: 1)),
    );
    if (picked != null) {
      setState(() {
        if (isStartDate) {
          _startDate = picked;
          if (_endDate != null && _endDate!.isBefore(_startDate!)) {
            _endDate = _startDate;
          }
        } else {
          _endDate = picked;
          if (_startDate != null && _startDate!.isAfter(_endDate!)) {
            _startDate = _endDate;
          }
        }
      });
    }
  }

  void _clearFilters() {
    setState(() {
      _startDate = null;
      _endDate = null;
    });
  }

  List<Tamizaje> _getFilteredData(List<Tamizaje> allData) {
    if (_startDate == null || _endDate == null) {
      return allData;
    }
    final start = DateTime(_startDate!.year, _startDate!.month, _startDate!.day);
    final end = DateTime(_endDate!.year, _endDate!.month, _endDate!.day, 23, 59, 59);

    return allData.where((t) {
      try {
        if (t.fechaIntervencion == null || t.fechaIntervencion!.isEmpty) return false;
        final recordDate = DateTime.parse(t.fechaIntervencion!);
        return !recordDate.isBefore(start) && !recordDate.isAfter(end);
      } catch (e) {
        return false;
      }
    }).toList();
  }

  // ============================================================================
  // NUEVO: WIDGET DE LA BARRA DE FILTROS
  // ============================================================================
  Widget _buildFilterBar() {
    final dateFormat = DateFormat('dd/MM/yyyy');
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 12.0),
      color: Theme.of(context).primaryColor.withOpacity(0.1),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          ActionChip(
            avatar: const Icon(Icons.calendar_today, size: 16),
            label: Text(_startDate == null ? 'Inicio' : dateFormat.format(_startDate!)),
            onPressed: () => _selectDate(context, true),
          ),
          ActionChip(
            avatar: const Icon(Icons.event, size: 16),
            label: Text(_endDate == null ? 'Fin' : dateFormat.format(_endDate!)),
            onPressed: () => _selectDate(context, false),
          ),
          if (_startDate != null || _endDate != null)
            IconButton(
              icon: const Icon(Icons.clear, color: Colors.red),
              onPressed: _clearFilters,
              tooltip: 'Limpiar Filtro',
            )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tamizajes Registrados'),
        actions: [
          // El botón de exportar ahora se mostrará solo si hay datos
          FutureBuilder<List<Tamizaje>>(
              future: _tamizajesFuture,
              builder: (context, snapshot) {
                if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                  final filteredData = _getFilteredData(snapshot.data!);
                  return IconButton(
                    icon: const Icon(Icons.share),
                    onPressed: () => _showExportSheet(filteredData),
                    tooltip: 'Exportar Datos',
                  );
                }
                return const SizedBox.shrink(); // No mostrar si no hay datos
              }
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _refreshTamizajesList,
            tooltip: 'Refrescar Lista',
          ),
        ],
      ),
      // --- ESTRUCTURA MODIFICADA PARA INCLUIR FILTROS ---
      body: Column(
        children: [
          _buildFilterBar(),
          Expanded(
            child: FutureBuilder<List<Tamizaje>>(
              future: _tamizajesFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Text('No hay tamizajes registrados.\nVe a Inicio para agregar uno nuevo.',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    ),
                  );
                }

                final allTamizajes = snapshot.data!;
                final filteredTamizajes = _getFilteredData(allTamizajes);

                if (filteredTamizajes.isEmpty) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Text('No se encontraron registros\npara el rango de fechas seleccionado.',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    ),
                  );
                }

                // --- WIDGET PRINCIPAL CON CONTADOR Y LISTA ---
                return Column(
                  children: [
                    // --- NUEVO: WIDGET CONTADOR ---
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
                      child: Text(
                        'Mostrando ${filteredTamizajes.length} de ${allTamizajes.length} registros',
                        style: TextStyle(
                          color: Colors.grey.shade700,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                        itemCount: filteredTamizajes.length,
                        itemBuilder: (context, index) {
                          final tamizaje = filteredTamizajes[index];
                          return Card(
                            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            elevation: 3,
                            child: ListTile(
                              leading: CircleAvatar(child: Text(tamizaje.nombres.substring(0, 1).toUpperCase())),
                              title: Text('${tamizaje.nombres} ${tamizaje.apellidos}'),
                              subtitle: Text('ID: ${tamizaje.numeroDocumento}\nFecha: ${tamizaje.fechaIntervencion}'),
                              isThreeLine: true,
                              trailing: const Icon(Icons.chevron_right),
                              onTap: () async {
                                await context.push('/form', extra: tamizaje);
                                _refreshTamizajesList();
                              },
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../custom_code/sqlite_helper.dart';
import '../../custom_code/widgets/formulario_completo_widget.dart';

class FormWidget extends StatelessWidget {
  final Tamizaje? tamizajeForEdit;
  const FormWidget({super.key, this.tamizajeForEdit});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(tamizajeForEdit == null ? 'Nuevo Tamizaje' : 'Editar Tamizaje'),
      ),
      body: FormularioCompletoWidget(
        initialTamizajeData: tamizajeForEdit,
        onSaveComplete: () async {
          if (context.mounted) {
            // Regresa a la página anterior (la lista)
            context.pop();
          }
        },
        onCancel: () async {
          if (context.mounted) {
            context.pop();
          }
        },
      ),
    );
  }
}
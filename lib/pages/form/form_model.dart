import '/flutter_flow/flutter_flow_util.dart';
import 'form_widget.dart' show FormWidget;
import 'package:flutter/material.dart';

class FormModel extends FlutterFlowModel<FormWidget> {
  ///  State fields for stateful widgets in this page.

  final formKey = GlobalKey<FormState>();
  // State field(s) for nombres widget.
  FocusNode? nombresFocusNode;
  TextEditingController? nombresTextController;
  String? Function(BuildContext, String?)? nombresTextControllerValidator;
  String? _nombresTextControllerValidator(BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return 'nombre is required';
    }

    return null;
  }

  // State field(s) for apellidos widget.
  FocusNode? apellidosFocusNode;
  TextEditingController? apellidosTextController;
  String? Function(BuildContext, String?)? apellidosTextControllerValidator;
  String? _apellidosTextControllerValidator(BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return 'apellido is required';
    }

    return null;
  }

  @override
  void initState(BuildContext context) {
    nombresTextControllerValidator = _nombresTextControllerValidator;
    apellidosTextControllerValidator = _apellidosTextControllerValidator;
  }

  @override
  void dispose() {
    nombresFocusNode?.dispose();
    nombresTextController?.dispose();

    apellidosFocusNode?.dispose();
    apellidosTextController?.dispose();
  }
}

import '/flutter_flow/flutter_flow_util.dart';
import 'bs_create_tamizajes_widget.dart' show BsCreateTamizajesWidget;
import 'package:flutter/material.dart';

class BsCreateTamizajesModel extends FlutterFlowModel<BsCreateTamizajesWidget> {
  ///  State fields for stateful widgets in this component.

  final formKey = GlobalKey<FormState>();
  // State field(s) for nombres widget.
  FocusNode? nombresFocusNode;
  TextEditingController? nombresTextController;
  String? Function(BuildContext, String?)? nombresTextControllerValidator;
  // State field(s) for apellidos widget.
  FocusNode? apellidosFocusNode;
  TextEditingController? apellidosTextController;
  String? Function(BuildContext, String?)? apellidosTextControllerValidator;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    nombresFocusNode?.dispose();
    nombresTextController?.dispose();

    apellidosFocusNode?.dispose();
    apellidosTextController?.dispose();
  }
}

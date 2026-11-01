import 'package:flutter/material.dart';
import 'app.dart';
import 'services/services.dart';
import 'state/app_state.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  final services = HarborlineServices();
  final state = AppState(services);
  runApp(HarborlineApp(state: state));
}

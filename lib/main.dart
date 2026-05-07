import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Request camera permission before app starts
  // This ensures iOS and Android dialogs appear with Polish text
  await Permission.camera.request();
  
  runApp(const TickScanApp());
}

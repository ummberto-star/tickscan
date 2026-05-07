import 'package:flutter/material.dart';

class TickScanApp extends StatelessWidget {
  const TickScanApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TickScan',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorSchemeSeed: const Color(0xFF2E7D32),
        useMaterial3: true,
        brightness: Brightness.light,
      ),
      home: const Scaffold(
        body: Center(
          child: Text('TickScan — KROK 1 ✅'),
        ),
      ),
    );
  }
}

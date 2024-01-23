import 'package:credkit/spalsh.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'CREDKiT',
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xff0D1D2E),
        useMaterial3: true,
      ),
      home: SpalshScreen(),
    );
  }
}

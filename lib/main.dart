import 'package:credkit/firebase_options.dart';
import 'package:credkit/spalsh.dart';
import 'package:flutter/material.dart';
//import firebase_core
import 'package:firebase_core/firebase_core.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

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
      home: const SpalshScreen(),
    );
  }
}

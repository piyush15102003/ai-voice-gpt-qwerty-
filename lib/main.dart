import 'package:ai_voiceee/HomePage.dart';
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
      title: 'Qwerty',
      theme:  ThemeData.light(useMaterial3: true).copyWith(scaffoldBackgroundColor: Colors.grey,
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.grey,
      ),
      ),
      home: HomePage(),
    );
  }
}


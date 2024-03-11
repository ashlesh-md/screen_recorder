import 'package:flutter/material.dart';

import 'home_screen.dart';

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
          primaryColor: Colors.indigo, hintColor: Colors.indigoAccent),
      home: HomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

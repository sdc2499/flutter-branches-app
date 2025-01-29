import 'package:flutter/material.dart';
import 'screens/branches_list_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'רולדין',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        textTheme: TextTheme(
          bodyMedium: TextStyle(fontFamily: 'Roboto',fontSize: 16)
        ),
        visualDensity: VisualDensity.adaptivePlatformDensity
      ),
      home: BranchesListScreen()
    );
  }
}

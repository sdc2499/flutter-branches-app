import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'screens/branches_list_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'רולדין',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        textTheme: TextTheme(
          bodyMedium: TextStyle(fontFamily: 'Roboto', fontSize: 16),
        ),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      // הגדרת שפה עברית עם תמיכה ב-RTL
      locale: Locale('he', 'IL'), // שפה עברית
      supportedLocales: [
        const Locale('he', 'IL'), // תמיכה רק בעברית
      ],
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate, // ייבוא המודול המתאים
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate, // ייבוא המודול המתאים
      ],
      // הגדרת כיוון טקסט RTL לכל האפליקציה
      home: Directionality(
        textDirection: TextDirection.rtl, // הגדרת כיוון הטקסט
        child: BranchesListScreen(),
      ),
    );
  }
}

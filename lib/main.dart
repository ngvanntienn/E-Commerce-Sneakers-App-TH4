import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'screens/main_shell.dart';

void main() {
  runApp(const SneakersApp());
}

class SneakersApp extends StatelessWidget {
  const SneakersApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Sneakers App',
      theme: ThemeData(
        useMaterial3: true,
        primarySwatch: Colors.blue,
        textTheme: GoogleFonts.interTextTheme(Theme.of(context).textTheme),
      ),
      home: const MainShell(),
    );
  }
}

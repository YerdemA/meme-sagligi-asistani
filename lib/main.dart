import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'config/constants.dart';
import 'screens/home_screen.dart'; // <--- YENİ EKLENDİ

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Meme Sağlığı Asistanı',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary),
        scaffoldBackgroundColor: AppColors.background,
        useMaterial3: true,
        textTheme: GoogleFonts.latoTextTheme(),
      ),
      home: const HomeScreen(), // <--- ARTIK BURASI HOMESCREEN
    );
  }
}

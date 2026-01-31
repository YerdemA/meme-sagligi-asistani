import 'package:flutter/material.dart';

class AppColors {
  // Sağlık uygulaması olduğu için güven veren yumuşak tonlar
  static const Color primary = Color(0xFFE91E63); // Meme kanseri farkındalık rengi (Pembe)
  static const Color background = Color(0xFFFCE4EC); // Çok açık pembe zemin
  static const Color textDark = Color(0xFF2C3E50); // Okunaklı koyu gri
  static const Color success = Color(0xFF4CAF50); // Yeşil
  static const Color warning = Color(0xFFFFC107); // Sarı
  static const Color danger = Color(0xFFD32F2F); // Kırmızı
}

class AppTextStyles {
  // Okuma güçlüğü çekenler için büyük puntolar tercih edeceğiz
  static const TextStyle header = TextStyle(
    fontSize: 24, 
    fontWeight: FontWeight.bold, 
    color: AppColors.textDark
  );
  
  static const TextStyle body = TextStyle(
    fontSize: 18, 
    color: AppColors.textDark
  );
}
import 'package:flutter/material.dart';
import '../config/constants.dart';

class ResultScreen extends StatelessWidget {
  final int score; // Hesaplanan risk puanı buraya gelecek

  const ResultScreen({super.key, required this.score});

  @override
  Widget build(BuildContext context) {
    // Puana göre mesaj ve renk belirleme mantığı
    String message;
    Color color;
    IconData icon;

    if (score < 4) {
      // Düşük Risk
      message = "Harika görünüyorsunuz!\nDüzenli kontrollere devam edin.";
      color = AppColors.success;
      icon = Icons.sentiment_very_satisfied;
    } else if (score < 9) {
      // Orta Risk
      message =
          "Dikkatli olmanızda fayda var.\nKendi kendine muayeneyi aksatmayın.";
      color = AppColors.warning;
      icon = Icons.sentiment_neutral;
    } else {
      // Yüksek Risk
      message =
          "Lütfen en kısa sürede bir doktora görünün.\nTedbir almak hayat kurtarır.";
      color = AppColors.danger;
      icon = Icons.warning_amber_rounded;
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 120, color: color),
            const SizedBox(height: 30),
            Text(
              "Risk Analizi Sonucu",
              style: AppTextStyles.body.copyWith(color: Colors.grey),
            ),
            const SizedBox(height: 10),
            Text(
              message,
              textAlign: TextAlign.center,
              style: AppTextStyles.header.copyWith(color: color),
            ),
            const SizedBox(height: 50),

            // Ana Menüye Dön Butonu
            SizedBox(
              width: double.infinity,
              height: 60,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                ),
                onPressed: () {
                  // Tüm geçmişi silip ana sayfaya atar
                  Navigator.of(context).popUntil((route) => route.isFirst);
                },
                child: const Text(
                  "Ana Menüye Dön",
                  style: TextStyle(fontSize: 20),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

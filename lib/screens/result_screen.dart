import 'package:flutter/material.dart';
import '../config/constants.dart';
import '../services/tts_service.dart';

class ResultScreen extends StatefulWidget {
  final int score;

  const ResultScreen({super.key, required this.score});

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  final TtsService _ttsService = TtsService();

  @override
  void initState() {
    super.initState();

    // DÜZELTME: Sayfa geçiş animasyonuyla çakışmaması için 800ms gecikme eklendi.
    // Bu, sesin "Risk" diyip takılmasını engeller.
    Future.delayed(const Duration(milliseconds: 800), () {
      if (mounted) {
        _speakResult();
      }
    });
  }

  void _speakResult() {
    String ttsMessage;

    if (widget.score < 4) {
      ttsMessage = "Harika görünüyorsunuz. Düzenli kontrollere devam edin.";
    } else if (widget.score < 9) {
      ttsMessage =
          "Dikkatli olmanızda fayda var. Kendi kendine muayeneyi aksatmayın.";
    } else {
      ttsMessage =
          "Lütfen en kısa sürede bir doktora görünün. Tedbir almak hayat kurtarır.";
    }

    // GÜNCELLEME: Önce varsa eski sesi durdurup sonra temiz bir başlangıç yapar.
    _ttsService.stop().then((_) {
      _ttsService.speak("Risk Analizi Sonucu. $ttsMessage");
    });
  }

  @override
  void dispose() {
    _ttsService.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Görsel yapı ve mesajlar orijinal haliyle korundu
    String message;
    Color color;
    IconData icon;

    if (widget.score < 4) {
      message = "Harika görünüyorsunuz!\nDüzenli kontrollere devam edin.";
      color = AppColors.success;
      icon = Icons.sentiment_very_satisfied;
    } else if (widget.score < 9) {
      message =
          "Dikkatli olmanızda fayda var.\nKendi kendine muayeneyi aksatmayın.";
      color = AppColors.warning;
      icon = Icons.sentiment_neutral;
    } else {
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

            SizedBox(
              width: double.infinity,
              height: 60,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                ),
                onPressed: () {
                  _ttsService.stop();
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

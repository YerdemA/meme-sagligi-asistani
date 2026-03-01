import 'package:flutter_tts/flutter_tts.dart';

class TtsService {
  // Singleton yapısı: Uygulamanın her yerinde aynı ses motorunu kullanmak için
  static final TtsService _instance = TtsService._internal();
  factory TtsService() => _instance;
  TtsService._internal();

  final FlutterTts _flutterTts = FlutterTts();

  Future<void> speak(String text) async {
    await _flutterTts.setLanguage("tr-TR"); // Türkçe dil ayarı
    await _flutterTts.setPitch(1.0); // Ses tonu
    await _flutterTts.setSpeechRate(0.8); // Okuma hızı (İdeal seviye)
    await _flutterTts.speak(text);
  }

  Future<void> stop() async {
    await _flutterTts.stop();
  }
}

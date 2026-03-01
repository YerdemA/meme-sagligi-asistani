import 'package:flutter_tts/flutter_tts.dart';

class TtsService {
  // Singleton yapısı: Uygulamanın her yerinde aynı ses motorunu kullanmak için
  static final TtsService _instance = TtsService._internal();
  factory TtsService() => _instance;
  TtsService._internal();

  final FlutterTts _flutterTts = FlutterTts();

  // GÜNCELLEME: rate parametresi eklendi. Varsayılan (default) değeri 0.5 yapıldı.
  Future<void> speak(String text, {double rate = 0.5}) async {
    await _flutterTts.setLanguage("tr-TR"); // Türkçe dil ayarı
    await _flutterTts.setPitch(1.0); // Ses tonu

    // Gönderilen rate değerine göre hız ayarlanır
    await _flutterTts.setSpeechRate(rate);

    await _flutterTts.speak(text);
  }

  Future<void> stop() async {
    await _flutterTts.stop();
  }
}

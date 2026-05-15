import 'package:flutter_tts/flutter_tts.dart';

class TtsService {
  // 1. SINGLETON MİMARİSİ
  static final TtsService _instance = TtsService._internal();
  factory TtsService() => _instance;

  final FlutterTts flutterTts = FlutterTts();
  bool isVoiceEnabled = true;

  // 2. OTOMATİK KURULUM (Sınıf çağrıldığı an Türkçe ayarlarını yükler)
  TtsService._internal() {
    _initTts();
  }

  Future<void> _initTts() async {
    await flutterTts.setLanguage("tr-TR");
    await flutterTts.setSpeechRate(0.60);
    await flutterTts.setVolume(1.0);
    await flutterTts.setPitch(1.0);
  }

  // 3. AKILLI OKUMA FONKSİYONU
  Future<void> speak(String text, {double rate = 0.60}) async {
    if (!isVoiceEnabled) return;

    // Garantilemek için her okumada dili tekrar Türkçe olarak ayarlıyoruz
    await flutterTts.setLanguage("tr-TR");
    await flutterTts.setSpeechRate(rate);
    await flutterTts.speak(text);
  }

  // Sesi durdurma
  Future<void> stop() async {
    await flutterTts.stop();
  }

  // 4. SESİ AÇMA/KAPATMA (TOGGLE) FONKSİYONU
  void toggleVoice() {
    isVoiceEnabled = !isVoiceEnabled;
    if (!isVoiceEnabled) {
      stop();
    }
  }
}

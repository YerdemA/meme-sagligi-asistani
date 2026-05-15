import 'package:flutter/material.dart';
import '../config/constants.dart';
import '../services/tts_service.dart'; // Merkezi TTS servisini ekledik
// import 'home_screen.dart';

class ResultScreen extends StatefulWidget {
  // Eski 'score' değişkeni yerine artık Yapay Zekadan gelen bu sözlüğü (Map) alıyoruz
  final Map<String, dynamic> apiSonucu;

  const ResultScreen({super.key, required this.apiSonucu});

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  // 1. Merkezi (Singleton) TTS Servisini çağırıyoruz
  final TtsService _ttsService = TtsService();

  @override
  void initState() {
    super.initState();
    // 2. Sayfa yüklendiğinde sonucu otomatik oku
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _speakResult();
    });
  }

  // Gelen yapay zeka verilerini birleştirip sesli okuma metni oluşturur
  void _speakResult() {
    final String baslik = widget.apiSonucu['baslik'] ?? 'Sonuç Alınamadı';
    final String eylem =
        widget.apiSonucu['eylem'] ?? 'Lütfen daha sonra tekrar deneyin.';
    final bool kkmmHatirlat = widget.apiSonucu['kkmm_hatirlat'] ?? false;

    String textToSpeak = "Analiz sonucunuz hazır: $baslik. $eylem";

    if (kkmmHatirlat) {
      textToSpeak +=
          " Ayrıca, lütfen Kendi Kendine Meme Muayenesini her ay düzenli yapmayı unutmayın.";
    }

    _ttsService.speak(textToSpeak, rate: 0.45);
  }

  @override
  void dispose() {
    // 3. Sayfadan çıkarken sesi anında kes
    _ttsService.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Python sunucusundan gelen verileri (seviye, baslik, eylem) değişkenlere ayırıyoruz
    // StatefulWidget içinde olduğumuz için 'widget.apiSonucu' kullanıyoruz
    final int seviye = widget.apiSonucu['seviye'] ?? 1;
    final String baslik = widget.apiSonucu['baslik'] ?? 'Sonuç Alınamadı';
    final String eylem =
        widget.apiSonucu['eylem'] ?? 'Lütfen daha sonra tekrar deneyin.';
    final bool kkmmHatirlat = widget.apiSonucu['kkmm_hatirlat'] ?? false;

    // Seviyeye göre (1, 2, 3) ekranda gösterilecek rengi ve ikonu belirliyoruz
    Color durumRengi;
    IconData durumIkonu;

    if (seviye == 1) {
      durumRengi = Colors.green;
      durumIkonu = Icons.check_circle_outline;
    } else if (seviye == 2) {
      durumRengi = Colors.orange;
      durumIkonu = Icons.warning_amber_rounded;
    } else {
      durumRengi = Colors.red;
      durumIkonu = Icons.error_outline;
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Risk Analiz Sonucu"),
        backgroundColor: AppColors.background,
        automaticallyImplyLeading:
            false, // Geri tuşunu gizler (Kullanıcı testi bitirdi)
      ),
      // Kullanıcı isterse ekrana dokunup sonucu tekrar dinleyebilir
      body: GestureDetector(
        onTap: () {
          _ttsService.stop();
          _speakResult();
        },
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // 1. Üstteki Büyük İkon
                Icon(durumIkonu, size: 100, color: durumRengi),
                const SizedBox(height: 20),

                // 2. Python'un Bize Gönderdiği Başlık
                Text(
                  baslik,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: durumRengi,
                  ),
                ),
                const SizedBox(height: 20),

                // 3. Detaylı Eylem Planı Kartı
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 10,
                        offset: Offset(0, 5),
                      ),
                    ],
                    border: Border.all(
                      color: durumRengi.withOpacity(0.3),
                      width: 2,
                    ),
                  ),
                  child: Text(
                    eylem,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 18, height: 1.5),
                  ),
                ),
                const SizedBox(height: 20),

                // 4. Eğer model "KKMM Hatırlat: True" gönderdiyse bu ekstra uyarı çıkar
                if (kkmmHatirlat)
                  Container(
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      children: const [
                        Icon(Icons.health_and_safety, color: AppColors.primary),
                        SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            "Lütfen Kendi Kendine Meme Muayenesini (KKMM) her ay düzenli yapmayı unutmayın.",
                            style: TextStyle(
                              color: AppColors.primary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                const Spacer(),

                // 5. Ana Sayfaya Dön Butonu
                SizedBox(
                  height: 60,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    onPressed: () {
                      _ttsService.stop(); // Ana ekrana dönerken sesi kes
                      Navigator.of(context).popUntil((route) => route.isFirst);
                    },
                    child: const Text(
                      "ANA EKRANA DÖN",
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

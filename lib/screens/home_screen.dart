import 'package:flutter/material.dart';
import '../config/constants.dart';
import '../services/tts_service.dart'; // 1. TTS Servis import edildi
import 'education_screen.dart';
import 'assessment_screen.dart';

class HomeScreen extends StatefulWidget {
  // DÜZELTME: initState kullanımı için StatefulWidget yapıldı
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // 2. TTS Servis nesnesi tanımlandı
  final TtsService _ttsService = TtsService();

  @override
  void initState() {
    super.initState();
    // 3. Karşılama Seslendirmesi: Uygulama açılınca kullanıcıyı bilgilendirir
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _ttsService.speak(
        "Meme Sağlığı Asistanına Hoş Geldiniz. Lütfen yapmak istediğiniz işlemi seçin. Kendi kendine muayeneyi öğrenmek için ekranın üst kısmındaki pembe butona, Risk testini yapmak için alt kısımdaki yeşil butona basabilirsiniz.",
        rate: 0.42, // Giriş için anlaşılır ve nazik bir hız
      );
    });
  }

  @override
  void dispose() {
    _ttsService.stop(); // 4. Sayfadan ayrılınca sesi susturur
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Meme Sağlığı Asistanı"),
        centerTitle: true,
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            // Üstteki Bilgilendirme Kartı
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 10,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: const Row(
                children: [
                  Icon(Icons.info_outline, color: AppColors.primary, size: 32),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      "Hoşgeldiniz. Lütfen yapmak istediğiniz işlemi seçin.",
                      style: AppTextStyles.body,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),

            // 1. BUTON: Eğitim (Kendi Kendine Muayene)
            Expanded(
              child: _HomeButton(
                title: "Muayene Öğren",
                icon: Icons.accessibility_new_rounded,
                color: AppColors.primary,
                onTap: () {
                  // 5. Navigasyon öncesi sesi durdurur ve sayfaya geçer
                  _ttsService.stop();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const EducationScreen(),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 20),

            // 2. BUTON: Risk Testi
            Expanded(
              child: _HomeButton(
                title: "Risk Testi Yap",
                icon: Icons.medical_services_outlined,
                color: AppColors.success,
                onTap: () {
                  // 6. Navigasyon öncesi sesi durdurur ve sayfaya geçer
                  _ttsService.stop();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AssessmentScreen(),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

class _HomeButton extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _HomeButton({
    required this.title,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: color.withValues(alpha: 0.4),
              blurRadius: 15,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 80, color: Colors.white),
            const SizedBox(height: 10),
            Text(
              title,
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 5),
            const Row(
              // DEĞİŞİKLİK: Ses imgesini daha profesyonel bir hale getirdik
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.volume_up, color: Colors.white70, size: 20),
                SizedBox(width: 5),
                Text(
                  "Sesli Rehber Aktif",
                  style: TextStyle(color: Colors.white70, fontSize: 12),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

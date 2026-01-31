import 'package:flutter/material.dart';
import '../config/constants.dart';
import 'education_screen.dart';
import 'assessment_screen.dart';
// İleride buraya diğer sayfaları import edeceğiz

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

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
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 10,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
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
                icon: Icons.accessibility_new_rounded, // Vücut/İnsan ikonu
                color: AppColors.primary,
                onTap: () {
                  // Eski hali: print("Eğitim tıklandı");
                  // Yeni hali:
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
                icon:
                    Icons.medical_services_outlined, // Doktor çantası/Steteskop
                color: AppColors.success, // Güven veren yeşil tonu
                onTap: () {
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

// Tekrar eden kod yazmamak için özel buton widget'ı
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
                fontSize: 28, // Okuma güçlüğü için büyük font
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 5),
            const Icon(
              Icons.volume_up,
              color: Colors.white70,
              size: 24,
            ), // Sesli anlatım imgesi
          ],
        ),
      ),
    );
  }
}

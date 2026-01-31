import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart'; // Ses çalmak için
import '../config/constants.dart';
import '../data/slide_data.dart'; // Verileri buradan çekeceğiz
import '../models/slide_model.dart';

class EducationScreen extends StatefulWidget {
  const EducationScreen({super.key});

  @override
  State<EducationScreen> createState() => _EducationScreenState();
}

class _EducationScreenState extends State<EducationScreen> {
  // Slaytları ve sayfa kontrolcüsünü tanımlayalım
  late List<Slide> _slides;
  final PageController _pageController = PageController();
  int _currentIndex = 0;

  // Ses oynatıcı
  final AudioPlayer _audioPlayer = AudioPlayer();

  @override
  void initState() {
    super.initState();
    _slides = getSlides(); // data/slide_data.dart'tan verileri çek
    _playAudio(_currentIndex); // İlk sayfa açılınca sesi çal
  }

  @override
  void dispose() {
    _pageController.dispose();
    _audioPlayer
        .dispose(); // Sayfadan çıkınca ses çaları kapat (Hafıza sızıntısını önler)
    super.dispose();
  }

  // Sesi çalma fonksiyonu
  Future<void> _playAudio(int index) async {
    try {
      await _audioPlayer.stop(); // Önceki ses varsa durdur
      // AssetSource, 'assets/' öneki olmadan çalışır, sadece klasör yolunu ver
      // Örn: assets/audio/slide1.mp3 -> audio/slide1.mp3
      String cleanPath = _slides[index].audioPath.replaceFirst('assets/', '');
      await _audioPlayer.play(AssetSource(cleanPath));
    } catch (e) {
      debugPrint("Ses dosyası bulunamadı veya hata: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Nasıl Muayene Olunur?"),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          // --- SLAYT ALANI (PageView) ---
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              itemCount: _slides.length,
              onPageChanged: (index) {
                setState(() {
                  _currentIndex = index;
                });
                _playAudio(index); // Sayfa değişince sesi çal
              },
              itemBuilder: (context, index) {
                return _buildSlideItem(_slides[index]);
              },
            ),
          ),

          // --- ALT KONTROL PANELİ ---
          Container(
            padding: const EdgeInsets.all(20),
            color: Colors.white,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // GERİ BUTONU
                if (_currentIndex > 0)
                  _buildNavButton(
                    icon: Icons.arrow_back_ios,
                    label: "Geri",
                    color: Colors.grey,
                    onTap: () {
                      _pageController.previousPage(
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.ease,
                      );
                    },
                  )
                else
                  const SizedBox(width: 80), // Boşluk tutucu
                // SAYFA GÖSTERGESİ (Noktalar)
                Row(
                  children: List.generate(
                    _slides.length,
                    (index) => Container(
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      width: _currentIndex == index ? 12 : 8,
                      height: _currentIndex == index ? 12 : 8,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _currentIndex == index
                            ? AppColors.primary
                            : Colors.grey.shade300,
                      ),
                    ),
                  ),
                ),

                // İLERİ / BİTİR BUTONU
                if (_currentIndex < _slides.length - 1)
                  _buildNavButton(
                    icon: Icons.arrow_forward_ios,
                    label: "İleri",
                    color: AppColors.primary,
                    isRight: true,
                    onTap: () {
                      _pageController.nextPage(
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.ease,
                      );
                    },
                  )
                else
                  _buildNavButton(
                    icon: Icons.check,
                    label: "Bitir",
                    color: AppColors.success,
                    isRight: true,
                    onTap: () {
                      Navigator.pop(context); // Ana sayfaya dön
                    },
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Tekil Slayt Tasarımı
  Widget _buildSlideItem(Slide slide) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Resim Alanı
          Expanded(
            flex: 3,
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10)],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.asset(
                  slide.imagePath,
                  fit: BoxFit.contain, // Resmi sığdır
                  errorBuilder: (context, error, stackTrace) {
                    // Resim bulunamazsa gösterilecek yedek ikon
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.image_not_supported,
                          size: 50,
                          color: Colors.grey,
                        ),
                        Text(
                          "Görsel Bulunamadı\n(${slide.imagePath})",
                          textAlign: TextAlign.center,
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ),
          const SizedBox(height: 30),

          // Metin Alanı
          Expanded(
            flex: 2,
            child: SingleChildScrollView(
              // Metin çok uzunsa kaydırılabilsin
              child: Text(
                slide.text,
                style: AppTextStyles.header.copyWith(
                  fontSize: 22, // Biraz daha okunaklı
                  color: AppColors.textDark,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Navigasyon Buton Tasarımı
  Widget _buildNavButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
    bool isRight = false,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(30),
        ),
        child: Row(
          children: [
            if (!isRight) Icon(icon, color: color),
            if (!isRight) SizedBox(width: 5),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            if (isRight) SizedBox(width: 5),
            if (isRight) Icon(icon, color: color),
          ],
        ),
      ),
    );
  }
}

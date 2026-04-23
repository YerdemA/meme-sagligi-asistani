import 'package:flutter/material.dart';
import '../config/constants.dart';
import '../data/slide_data.dart';
import '../models/slide_model.dart';
import '../services/tts_service.dart';

class EducationScreen extends StatefulWidget {
  const EducationScreen({super.key});

  @override
  State<EducationScreen> createState() => _EducationScreenState();
}

class _EducationScreenState extends State<EducationScreen> {
  late List<Slide> _slides;
  final PageController _pageController = PageController();
  int _currentIndex = 0;
  final TtsService _ttsService = TtsService();

  @override
  void initState() {
    super.initState();
    _slides = getSlides();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _ttsService.speak(_slides[_currentIndex].text, rate: 0.50);
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    _ttsService.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(
        0xFFF5F7FA,
      ), // Giriş ekranıyla aynı ferah fon
      body: Column(
        children: [
          // 1. ÜST ALAN: Modern Header
          Container(
            padding: const EdgeInsets.fromLTRB(20, 50, 20, 30),
            decoration: const BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(32),
                bottomRight: Radius.circular(32),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(
                    Icons.arrow_back_ios_new,
                    color: Colors.white,
                    size: 22,
                  ),
                ),
                const Text(
                  "Nasıl Muayene Olunur?",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 44), // Simetri için
              ],
            ),
          ),

          // 2. SLAYT ALANI
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              itemCount: _slides.length,
              physics: const BouncingScrollPhysics(),
              onPageChanged: (index) {
                setState(() {
                  _currentIndex = index;
                });
                _ttsService.speak(_slides[index].text, rate: 0.50);
              },
              itemBuilder: (context, index) {
                return _buildSlideItem(_slides[index]);
              },
            ),
          ),

          // 3. ALT KONTROL PANELİ (Daha zarif butonlar)
          Container(
            padding: const EdgeInsets.fromLTRB(25, 10, 25, 40),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 10,
                  offset: Offset(0, -2),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildNavButton(
                  label: "Geri",
                  icon: Icons.arrow_back_ios_new,
                  color: Colors.grey.shade600,
                  isVisible: _currentIndex > 0,
                  onTap: () => _pageController.previousPage(
                    duration: const Duration(milliseconds: 400),
                    curve: Curves.easeInOut,
                  ),
                ),

                // Sayfa İndikatörleri (Noktalar)
                Row(
                  children: List.generate(
                    _slides.length,
                    (index) => AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      width: _currentIndex == index ? 24 : 8,
                      height: 8,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: _currentIndex == index
                            ? AppColors.primary
                            : Colors.grey.shade300,
                      ),
                    ),
                  ),
                ),

                _buildNavButton(
                  label: _currentIndex == _slides.length - 1
                      ? "Bitir"
                      : "İleri",
                  icon: _currentIndex == _slides.length - 1
                      ? Icons.check_circle
                      : Icons.arrow_forward_ios,
                  color: _currentIndex == _slides.length - 1
                      ? Colors.green.shade600
                      : AppColors.primary,
                  isVisible: true,
                  isRight: true,
                  onTap: () {
                    if (_currentIndex == _slides.length - 1) {
                      Navigator.pop(context);
                    } else {
                      _pageController.nextPage(
                        duration: const Duration(milliseconds: 400),
                        curve: Curves.easeInOut,
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSlideItem(Slide slide) {
    return SingleChildScrollView(
      // İçeriğin küçük ekranlarda taşmasını önler
      padding: const EdgeInsets.all(24.0),
      child: Column(
        children: [
          // GÖRSEL KARTI
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(30),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.06),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(30),
                  child: Image.asset(
                    slide.imagePath,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) =>
                        const SizedBox(
                          height: 250,
                          child: Icon(
                            Icons.image_not_supported,
                            size: 50,
                            color: Colors.grey,
                          ),
                        ),
                  ),
                ),
                // SES İKONU (Yarım şeffaf şık buton)
                Positioned(
                  right: 15,
                  bottom: 15,
                  child: FloatingActionButton.small(
                    elevation: 2,
                    backgroundColor: Colors.white.withOpacity(0.9),
                    onPressed: () => _ttsService.speak(slide.text, rate: 0.50),
                    child: const Icon(
                      Icons.volume_up_rounded,
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 40),
          // METİN ALANI
          Text(
            slide.text,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
              height: 1.4,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavButton({
    required String label,
    required IconData icon,
    required Color color,
    required bool isVisible,
    required VoidCallback onTap,
    bool isRight = false,
  }) {
    return Visibility(
      visible: isVisible,
      maintainSize: true,
      maintainAnimation: true,
      maintainState: true,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(15),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(15),
          ),
          child: Row(
            children: [
              if (!isRight) Icon(icon, size: 16, color: color),
              if (!isRight) const SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(
                  color: color,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              if (isRight) const SizedBox(width: 8),
              if (isRight) Icon(icon, size: 16, color: color),
            ],
          ),
        ),
      ),
    );
  }
}

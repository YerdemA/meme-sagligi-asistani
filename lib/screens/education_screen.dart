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

    // Sayfa ilk açıldığında ilk slaytı YAVAŞ okur (0.38 hızıyla)
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _ttsService.speak(_slides[_currentIndex].text, rate: 0.38);
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
      appBar: AppBar(
        title: const Text("Nasıl Muayene Olunur?"),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              itemCount: _slides.length,
              onPageChanged: (index) {
                setState(() {
                  _currentIndex = index;
                });
                // Sayfa değişince yeni metni YAVAŞ okur
                _ttsService.speak(_slides[index].text, rate: 0.38);
              },
              itemBuilder: (context, index) {
                return _buildSlideItem(_slides[index]);
              },
            ),
          ),

          // ALT KONTROL PANELİ
          Container(
            padding: const EdgeInsets.all(20),
            color: Colors.white,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
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
                  const SizedBox(width: 80),

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
                      Navigator.pop(context);
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
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            flex: 3,
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: const [
                  BoxShadow(color: Colors.black12, blurRadius: 10),
                ],
              ),
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Center(
                      child: Image.asset(
                        slide.imagePath,
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) {
                          return const Icon(
                            Icons.image_not_supported,
                            size: 50,
                            color: Colors.grey,
                          );
                        },
                      ),
                    ),
                  ),
                  Positioned(
                    right: 10,
                    top: 10,
                    child: CircleAvatar(
                      backgroundColor: AppColors.primary.withValues(alpha: 0.8),
                      child: IconButton(
                        icon: const Icon(
                          Icons.record_voice_over,
                          color: Colors.white,
                        ),
                        // İkona basıldığında da YAVAŞ okur
                        onPressed: () =>
                            _ttsService.speak(slide.text, rate: 0.38),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 30),
          Expanded(
            flex: 2,
            child: SingleChildScrollView(
              child: Text(
                slide.text,
                style: AppTextStyles.header.copyWith(
                  fontSize: 22,
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

  Widget _buildNavButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
    bool isRight = false,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(30),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(30),
        ),
        child: Row(
          children: [
            if (!isRight) Icon(icon, color: color),
            if (!isRight) const SizedBox(width: 5),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            if (isRight) const SizedBox(width: 5),
            if (isRight) Icon(icon, color: color),
          ],
        ),
      ),
    );
  }
}

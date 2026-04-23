import 'package:flutter/material.dart';
import '../config/constants.dart';
import '../services/tts_service.dart';
import 'education_screen.dart';
import 'assessment_screen.dart';
import 'prevention_guide_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TtsService _ttsService = TtsService();

  // Renk paleti
  static const Color _teal = Color(0xFF00695C);
  static const Color _tealLight = Color(0xFF00897B);
  static const Color _roseDeep = Color(0xFFC2185B);
  static const Color _bgPage = Color(0xFFF0F4F8);
  static const Color _cardBg = Color(0xFFFFFFFF);
  static const Color _textPrimary = Color(0xFF1A1F2E);
  static const Color _textSecondary = Color(0xFF6B7280);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _ttsService.speak(
        "Meme Sağlığı Asistanına Hoş Geldiniz. Lütfen yapmak istediğiniz işlemi seçin. "
        "Kendi kendine muayeneyi öğrenmek için ekranın orta kısmındaki pembe butona, "
        "Risk testini yapmak için alt kısımdaki turkuaz butona ."
        "Sağlıklı yaşam rehberi hakkında bilgi edinmek için bi alt kısımdaki turuncu tonundaki butona basabilirsiniz."
        "sistem nasıl çalışır ?"
        "ilk olarak risk testindeki 13 soruyu cevaplayın"
        "Cevaplarınızı gönderdikten sonra ise sonucunuzu çıkan ekranda görebileceksiniz."
        "Unutmayın ki Bu uygulama tıbbi tanı koymaz. Sonuçlar yalnızca farkındalık amaçlıdır.",
        rate: 0.50,
      );
    });
  }

  @override
  void dispose() {
    _ttsService.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bgPage,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // --- SLIVER APP BAR: Büyük başlık, scroll ile küçülür ---
          SliverAppBar(
            expandedHeight: 180,
            pinned: true,
            backgroundColor: _roseDeep,
            foregroundColor: Colors.white,
            elevation: 0,
            flexibleSpace: FlexibleSpaceBar(
              titlePadding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
              title: const Text(
                "Meme Sağlığı\nAsistanı",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                  height: 1.2,
                ),
              ),
              background: Stack(
                fit: StackFit.expand,
                children: [
                  // Arka plan deseni
                  Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Color(0xFFAD1457),
                          Color(0xFFC2185B),
                          Color(0xFFE91E63),
                        ],
                      ),
                    ),
                  ),
                  // Dekoratif daire 1
                  Positioned(
                    right: -40,
                    top: -40,
                    child: Container(
                      width: 200,
                      height: 200,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withOpacity(0.06),
                      ),
                    ),
                  ),
                  // Dekoratif daire 2
                  Positioned(
                    right: 30,
                    bottom: 30,
                    child: Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withOpacity(0.08),
                      ),
                    ),
                  ),
                  // Rozet
                  Positioned(
                    right: 20,
                    top: 50,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.3),
                        ),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.verified_outlined,
                            color: Colors.white,
                            size: 14,
                          ),
                          SizedBox(width: 4),
                          Text(
                            "AI Destekli",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // --- İÇERİK ---
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 1. Karşılama Kartı
                  _InfoCard(),
                  const SizedBox(height: 16),

                  // 2. YENİ: Yapay Zeka Bilgilendirme Kartı
                  _AIInfoCard(),
                  const SizedBox(height: 28),

                  // 3. Bölüm başlığı
                  const Text(
                    "Ne yapmak istersiniz?",
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: _textSecondary,
                      letterSpacing: 0.3,
                    ),
                  ),
                  const SizedBox(height: 14),

                  // --- BUTON 1: Muayene Öğren ---
                  _ModernActionCard(
                    title: "Muayene Öğren",
                    subtitle: "Adım adım görsel & sesli rehber",
                    description:
                        "Kendi kendine meme muayenesini doğru tekniklerle öğren.",
                    icon: Icons.accessibility_new_rounded,
                    accentColor: _roseDeep,
                    lightColor: const Color(0xFFFCE4EC),
                    onTap: () {
                      _ttsService.stop();
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const EducationScreen(),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 16),

                  // --- BUTON 2: Risk Testi ---
                  _ModernActionCard(
                    title: "Risk Testi Yap",
                    subtitle: "Yapay Zeka Destekli Değerlendirme",
                    description:
                        "Kişisel risk faktörlerine göre analiz ve öneriler al.",
                    icon: Icons.biotech_rounded,
                    accentColor: _teal,
                    lightColor: const Color(0xFFE0F2F1),
                    onTap: () {
                      _ttsService.stop();
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const AssessmentScreen(),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 16),
                  _ModernActionCard(
                    title: "Sağlıklı Yaşam Rehberi",
                    subtitle: "Bilgilendirme & Korunma",
                    description:
                        "Meme kanserinden korunma yolları ve dikkat edilmesi gerekenler.",
                    icon: Icons.lightbulb_outline_rounded,
                    accentColor: Colors.orange.shade800,
                    lightColor: Colors.orange.shade50,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const PreventionGuideScreen(),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 28),

                  // 4. YENİ: Nasıl Çalışır Bölümü
                  _HowItWorksSection(),
                  const SizedBox(height: 24),

                  // 5. Alt bilgi çubuğu (Disclaimer)
                  _DisclaimerBar(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ==========================================
// --- YARDIMCI WIDGET'LAR ---
// ==========================================

// Mevcut Karşılama Kartı
class _InfoCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: _HomeScreenState._cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE5E7EB)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFFFCE4EC),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.favorite_rounded,
              color: Color(0xFFC2185B),
              size: 24,
            ),
          ),
          const SizedBox(width: 14),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Hoş Geldiniz",
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: _HomeScreenState._textPrimary,
                  ),
                ),
                SizedBox(height: 3),
                Text(
                  "Sesli rehber aktif — tüm adımlar size okunacak.",
                  style: TextStyle(
                    fontSize: 12,
                    color: _HomeScreenState._textSecondary,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
          const Icon(
            Icons.volume_up_rounded,
            color: Color(0xFFC2185B),
            size: 20,
          ),
        ],
      ),
    );
  }
}

// YENİ: Yapay Zeka Bilgilendirme Kartı
class _AIInfoCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: _HomeScreenState._cardBg,
        borderRadius: BorderRadius.circular(20), // Diğer kartlarla uyumlu oval
        border: Border.all(color: const Color(0xFFE5E7EB)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: _HomeScreenState._teal.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.health_and_safety_rounded,
                  color: _HomeScreenState._teal,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Text(
                  "Bu Uygulama Ne İşe Yarar?",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: _HomeScreenState._textPrimary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            "Gelişmiş yapay zeka algoritmaları (XGBoost) kullanarak kişisel sağlık verilerinizi analiz eder ve size özel bir risk değerlendirmesi sunar. Amacımız, erken teşhis konusunda farkındalık yaratmaktır.",
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey.shade700,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 16),
          // Mini Özellik Etiketleri
          Row(
            children: [
              _buildMiniTag(Icons.smart_toy_rounded, "Yapay Zeka Destekli"),
              const SizedBox(width: 10),
              _buildMiniTag(Icons.lock_rounded, "Gizli & Güvenli"),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMiniTag(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        children: [
          Icon(icon, size: 14, color: _HomeScreenState._textSecondary),
          const SizedBox(width: 6),
          Text(
            text,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: _HomeScreenState._textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

// Mevcut Aksiyon Butonu (Muayene ve Test için)
class _ModernActionCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String description;
  final IconData icon;
  final Color accentColor;
  final Color lightColor;
  final VoidCallback onTap;

  const _ModernActionCard({
    required this.title,
    required this.subtitle,
    required this.description,
    required this.icon,
    required this.accentColor,
    required this.lightColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: _HomeScreenState._cardBg,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: const Color(0xFFE5E7EB)),
            boxShadow: [
              BoxShadow(
                color: accentColor.withOpacity(0.08),
                blurRadius: 16,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: lightColor,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(icon, color: accentColor, size: 32),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                        color: _HomeScreenState._textPrimary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: accentColor,
                        letterSpacing: 0.2,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      description,
                      style: const TextStyle(
                        fontSize: 12,
                        color: _HomeScreenState._textSecondary,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: lightColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: accentColor,
                  size: 14,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// YENİ: Nasıl Çalışır Bölümü
class _HowItWorksSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: _HomeScreenState._cardBg,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Sistem Nasıl Çalışır?",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: _HomeScreenState._textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          _buildStepItem(
            "1",
            "Risk Testini Çözün",
            "13 soruluk tıbbi anketi doldurun.",
          ),
          _buildStepItem(
            "2",
            "Buluta Gönderin",
            "Verileriniz güvenli sunucularımıza iletilir.",
          ),
          _buildStepItem(
            "3",
            "AI Analiz Etsin",
            "Optimize edilmiş makine öğrenmesi modelimiz risk skorunuzu hesaplar.",
          ),
          _buildStepItem(
            "4",
            "Sonucu Öğrenin",
            "Size özel tavsiyeleri ekranda görüntüleyin.",
            isLast: true,
          ),
        ],
      ),
    );
  }

  Widget _buildStepItem(
    String number,
    String title,
    String subtitle, {
    bool isLast = false,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: isLast ? 0 : 16),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: _HomeScreenState._roseDeep.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                number,
                style: const TextStyle(
                  color: _HomeScreenState._roseDeep,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: _HomeScreenState._textPrimary,
                  ),
                ),
                Text(
                  subtitle,
                  style: const TextStyle(
                    color: _HomeScreenState._textSecondary,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Mevcut Yasal Uyarı Çubuğu
class _DisclaimerBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF8E1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFFFECB3)),
      ),
      child: const Row(
        children: [
          Icon(Icons.info_outline_rounded, color: Color(0xFFF59E0B), size: 18),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              "Bu uygulama tıbbi tanı koymaz. Sonuçlar yalnızca farkındalık amaçlıdır.",
              style: TextStyle(
                fontSize: 11,
                color: Color(0xFF92400E),
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

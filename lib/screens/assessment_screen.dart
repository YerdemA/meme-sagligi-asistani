import 'package:flutter/material.dart';
import '../data/question_data.dart';
import '../models/question_model.dart';
import '../services/tts_service.dart';
import '../services/api_service.dart';
import 'result_screen.dart';

class AssessmentScreen extends StatefulWidget {
  const AssessmentScreen({super.key});

  @override
  State<AssessmentScreen> createState() => _AssessmentScreenState();
}

class _AssessmentScreenState extends State<AssessmentScreen>
    with TickerProviderStateMixin {
  // Merkezi (Singleton) TTS Servisi çağrılır
  final TtsService _ttsService = TtsService();

  List<RiskQuestion> _questions = [];
  int _currentIndex = 0;
  final Map<String, dynamic> _apiData = {};

  late AnimationController _slideController;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;
  bool _isForward = true;

  static const Color _rosePrimary = Color(0xFFC2185B);
  static const Color _roseDeep = Color(0xFFAD1457);
  static const Color _bgPage = Color(0xFFF0F4F8);
  static const Color _cardBg = Color(0xFFFFFFFF);
  static const Color _textPrimary = Color(0xFF1A1F2E);
  static const Color _textSecondary = Color(0xFF6B7280);
  static const Color _teal = Color(0xFF00695C);

  @override
  void initState() {
    super.initState();
    _questions = getQuestions();

    _slideController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 280),
    );

    _slideAnimation =
        Tween<Offset>(begin: const Offset(1.0, 0), end: Offset.zero).animate(
          CurvedAnimation(parent: _slideController, curve: Curves.easeOutCubic),
        );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _slideController, curve: Curves.easeOut));

    _slideController.forward();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_questions.isNotEmpty) {
        // İlk soru için giriş metni eklendi
        _speakQuestionAndOptions(
          _questions[_currentIndex],
          prefix: "Risk değerlendirmesi başlıyor. Soru 1: ",
        );
      }
    });
  }

  // Akıllı okuma fonksiyonu (Önceki seçimi de okuyabilmesi için prefix eklendi)
  void _speakQuestionAndOptions(RiskQuestion q, {String prefix = ""}) {
    String textToSpeak = prefix + q.questionText;

    if (q.type == QuestionType.yesNo) {
      textToSpeak += ". Seçenekler: Evet veya Hayır.";
    } else if (q.type == QuestionType.selection && q.options != null) {
      textToSpeak += ". Seçenekler: ${q.options!.join(", ")}.";
    } else if (q.type == QuestionType.numeric) {
      textToSpeak += ". Lütfen listeden bir değer seçip onaylayın.";
    }

    _ttsService.speak(textToSpeak);
  }

  // Cevaplama ve otomatik seslendirme mantığı
  void _handleAnswer(dynamic answer, String spokenAnswerText) {
    RiskQuestion currentQ = _questions[_currentIndex];
    _apiData[currentQ.apiKey] = currentQ.valueMapper!(answer);

    _ttsService.stop(); // Yeni seslendirme için öncekini kes

    if (_currentIndex < _questions.length - 1) {
      _isForward = true;
      _slideController.reset();

      _slideAnimation =
          Tween<Offset>(begin: const Offset(1.0, 0), end: Offset.zero).animate(
            CurvedAnimation(
              parent: _slideController,
              curve: Curves.easeOutCubic,
            ),
          );

      setState(() => _currentIndex++);
      _slideController.forward();

      // Kullanıcıya seçtiği cevabı onayla ve hemen yeni soruyu oku
      String nextSpeech =
          "$spokenAnswerText seçildi. Soru ${_currentIndex + 1}: ";
      _speakQuestionAndOptions(_questions[_currentIndex], prefix: nextSpeech);
    } else {
      // Test bittiğinde
      _ttsService.speak(
        "$spokenAnswerText seçildi. Değerlendirme tamamlandı. Verileriniz yapay zeka tarafından analiz ediliyor, lütfen ekranda bekleyin.",
      );
      _finishAndSendToAI();
    }
  }

  void _finishAndSendToAI() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        elevation: 0,
        child: Container(
          padding: const EdgeInsets.all(28),
          decoration: BoxDecoration(
            color: _cardBg,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.12),
                blurRadius: 30,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  color: _rosePrimary.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Padding(
                  padding: EdgeInsets.all(16),
                  child: CircularProgressIndicator(
                    color: _rosePrimary,
                    strokeWidth: 3,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                "Yapay Zeka Analiz Ediyor",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: _textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                "İlk bağlantıda 40–60 saniye sürebilir.\nLütfen bekleyin.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13,
                  color: _textSecondary,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 20),
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  backgroundColor: _rosePrimary.withOpacity(0.1),
                  valueColor: const AlwaysStoppedAnimation<Color>(_rosePrimary),
                  minHeight: 4,
                ),
              ),
            ],
          ),
        ),
      ),
    );

    try {
      final yapayZekaSonucu = await ApiService.riskAnaliziYap(_apiData);
      if (mounted) Navigator.pop(context);

      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => ResultScreen(apiSonucu: yapayZekaSonucu),
          ),
        );
      }
    } catch (e) {
      if (mounted) Navigator.pop(context);

      if (mounted) {
        _ttsService.speak(
          "Bağlantı hatası. Lütfen internetinizi kontrol edip tekrar deneyin.",
        );

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString()),
            backgroundColor: Colors.red.shade600,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            margin: const EdgeInsets.all(16),
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    _slideController.dispose();
    _ttsService.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    RiskQuestion currentQ = _questions[_currentIndex];
    double progress = (_currentIndex + 1) / _questions.length;

    return Scaffold(
      backgroundColor: _bgPage,
      body: Column(
        children: [
          // ── 1. HEADER ──
          _AssessmentHeader(
            currentIndex: _currentIndex,
            total: _questions.length,
            progress: progress,
            onBack: () {
              _ttsService.stop();
              Navigator.pop(context);
            },
          ),

          // ── 2. İÇERİK ──
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 32),
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: SlideTransition(
                  position: _slideAnimation,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Soru kartı
                      _QuestionCard(
                        question: currentQ,
                        // Kullanıcı ikona manuel basarsa sadece soruyu tekrar okur
                        onSpeakTap: () => _speakQuestionAndOptions(currentQ),
                        questionIndex: _currentIndex,
                        total: _questions.length,
                      ),
                      const SizedBox(height: 24),

                      // Cevap seçenekleri başlığı
                      const Padding(
                        padding: EdgeInsets.only(left: 4, bottom: 12),
                        child: Text(
                          "Seçeneğinizi seçin",
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: _textSecondary,
                            letterSpacing: 0.3,
                          ),
                        ),
                      ),

                      // Cevap alanı
                      _buildInputArea(currentQ),

                      const SizedBox(height: 16),

                      // Alt disclaimer
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFF8E1),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: const Color(0xFFFFECB3)),
                        ),
                        child: const Row(
                          children: [
                            Icon(
                              Icons.info_outline_rounded,
                              color: Color(0xFFF59E0B),
                              size: 16,
                            ),
                            SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                "Bu değerlendirme tıbbi tanı koymaz. Farkındalık amaçlıdır.",
                                style: TextStyle(
                                  fontSize: 11,
                                  color: Color(0xFF92400E),
                                  height: 1.4,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputArea(RiskQuestion q) {
    switch (q.type) {
      case QuestionType.yesNo:
        return Column(
          children: [
            _AnswerCard(
              text: "Evet",
              subtitle: "Bu durumu yaşadım",
              icon: Icons.check_circle_outline_rounded,
              accentColor: const Color(0xFFE53935),
              lightColor: const Color(0xFFFFEBEE),
              onTap: () =>
                  _handleAnswer(true, "Evet"), // Sesli yanıt metni eklendi
            ),
            const SizedBox(height: 12),
            _AnswerCard(
              text: "Hayır",
              subtitle: "Bu durum bende yok",
              icon: Icons.cancel_outlined,
              accentColor: _teal,
              lightColor: const Color(0xFFE0F2F1),
              onTap: () =>
                  _handleAnswer(false, "Hayır"), // Sesli yanıt metni eklendi
            ),
          ],
        );
      case QuestionType.numeric:
        return _ModernNumberInput(
          onConfirm: (val) => _handleAnswer(val, "$val değeri"),
        );
      case QuestionType.selection:
        return Column(
          children: q.options!.asMap().entries.map((entry) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _AnswerCard(
                text: entry.value,
                subtitle: "",
                icon: Icons.radio_button_unchecked_rounded,
                accentColor: _rosePrimary,
                lightColor: const Color(0xFFFCE4EC),
                onTap: () => _handleAnswer(
                  entry.value,
                  entry.value,
                ), // Sesli yanıt metni eklendi
              ),
            );
          }).toList(),
        );
    }
  }
}

// ═══════════════════════════════════════
// YARDIMCI WIDGET'LAR
// ═══════════════════════════════════════

class _AssessmentHeader extends StatelessWidget {
  final int currentIndex;
  final int total;
  final double progress;
  final VoidCallback onBack;

  static const Color _rosePrimary = Color(0xFFC2185B);

  const _AssessmentHeader({
    required this.currentIndex,
    required this.total,
    required this.progress,
    required this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFAD1457), _rosePrimary, Color(0xFFE91E63)],
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(28),
          bottomRight: Radius.circular(28),
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(8, 8, 20, 24),
          child: Column(
            children: [
              Row(
                children: [
                  IconButton(
                    onPressed: onBack,
                    icon: const Icon(
                      Icons.arrow_back_ios_new_rounded,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                  const Expanded(
                    child: Text(
                      "Risk Değerlendirmesi",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.white.withOpacity(0.3)),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.verified_outlined,
                          color: Colors.white,
                          size: 12,
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
                ],
              ),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Soru ${currentIndex + 1}",
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          "${(progress * 100).toInt()}% tamamlandı",
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.8),
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: LinearProgressIndicator(
                        value: progress,
                        minHeight: 6,
                        backgroundColor: Colors.white.withOpacity(0.2),
                        valueColor: const AlwaysStoppedAnimation<Color>(
                          Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _QuestionCard extends StatelessWidget {
  final RiskQuestion question;
  final VoidCallback onSpeakTap;
  final int questionIndex;
  final int total;

  static const Color _rosePrimary = Color(0xFFC2185B);
  static const Color _textPrimary = Color(0xFF1A1F2E);

  const _QuestionCard({
    required this.question,
    required this.onSpeakTap,
    required this.questionIndex,
    required this.total,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE5E7EB)),
        boxShadow: [
          BoxShadow(
            color: _rosePrimary.withOpacity(0.06),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              GestureDetector(
                onTap: onSpeakTap,
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: _rosePrimary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.volume_up_rounded,
                    color: _rosePrimary,
                    size: 22,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Text(
                "Soru ${questionIndex + 1} / $total",
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: _rosePrimary.withOpacity(0.8),
                  letterSpacing: 0.3,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            question.questionText,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: _textPrimary,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}

class _AnswerCard extends StatelessWidget {
  final String text;
  final String subtitle;
  final IconData icon;
  final Color accentColor;
  final Color lightColor;
  final VoidCallback onTap;

  static const Color _textPrimary = Color(0xFF1A1F2E);
  static const Color _textSecondary = Color(0xFF6B7280);

  const _AnswerCard({
    required this.text,
    required this.subtitle,
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
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFE5E7EB)),
            boxShadow: [
              BoxShadow(
                color: accentColor.withOpacity(0.06),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: lightColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: accentColor, size: 24),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      text,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: _textPrimary,
                      ),
                    ),
                    if (subtitle.isNotEmpty) ...[
                      const SizedBox(height: 2),
                      Text(
                        subtitle,
                        style: const TextStyle(
                          fontSize: 12,
                          color: _textSecondary,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: lightColor,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: accentColor,
                  size: 12,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ModernNumberInput extends StatefulWidget {
  final Function(int) onConfirm;
  const _ModernNumberInput({required this.onConfirm});

  @override
  State<_ModernNumberInput> createState() => _ModernNumberInputState();
}

class _ModernNumberInputState extends State<_ModernNumberInput> {
  int value = 25;

  static const Color _rosePrimary = Color(0xFFC2185B);
  static const Color _textPrimary = Color(0xFF1A1F2E);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE5E7EB)),
        boxShadow: [
          BoxShadow(
            color: _rosePrimary.withOpacity(0.05),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _NumButton(
                icon: Icons.remove_rounded,
                bgColor: const Color(0xFFF3F4F6),
                iconColor: _textPrimary,
                onTap: () => setState(() {
                  if (value > 0) value--;
                }),
              ),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 28),
                child: Column(
                  children: [
                    Text(
                      "$value",
                      style: const TextStyle(
                        fontSize: 52,
                        fontWeight: FontWeight.w700,
                        color: _rosePrimary,
                        height: 1,
                      ),
                    ),
                    Text(
                      "değer",
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade400,
                      ),
                    ),
                  ],
                ),
              ),
              _NumButton(
                icon: Icons.add_rounded,
                bgColor: const Color(0xFFFCE4EC),
                iconColor: _rosePrimary,
                onTap: () => setState(() => value++),
              ),
            ],
          ),
          const SizedBox(height: 28),
          SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              onPressed: () => widget.onConfirm(value),
              style: ElevatedButton.styleFrom(
                backgroundColor: _rosePrimary,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Onayla",
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
                  ),
                  SizedBox(width: 8),
                  Icon(Icons.check_rounded, size: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _NumButton extends StatelessWidget {
  final IconData icon;
  final Color bgColor;
  final Color iconColor;
  final VoidCallback onTap;

  const _NumButton({
    required this.icon,
    required this.bgColor,
    required this.iconColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      customBorder: const CircleBorder(),
      child: Container(
        width: 52,
        height: 52,
        decoration: BoxDecoration(color: bgColor, shape: BoxShape.circle),
        child: Icon(icon, size: 26, color: iconColor),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import '../config/constants.dart';
import '../data/question_data.dart';
import '../models/question_model.dart';
import 'result_screen.dart';

class AssessmentScreen extends StatefulWidget {
  const AssessmentScreen({super.key});

  @override
  State<AssessmentScreen> createState() => _AssessmentScreenState();
}

class _AssessmentScreenState extends State<AssessmentScreen> {
  // Ekranda gösterilecek aktif soru listesi (Kopyasını alıyoruz ki ekleme yapabilelim)
  List<Question> _displayQuestions = [];

  // Şu an kaçıncı sorudayız?
  int _currentIndex = 0;

  // Cevapları tuttuğumuz harita (Soru ID -> Cevap)
  final Map<int, dynamic> _answers = {};

  @override
  void initState() {
    super.initState();
    // Veritabanından HAM soruları çek
    var rawQuestions = getQuestions();
    // Sadece "Ana Soruları" (parentId'si olmayanları) listeye al
    _displayQuestions = rawQuestions.where((q) => q.parentId == null).toList();
  }

  // --- MANTIK MOTORU ---
  void _handleAnswer(dynamic answer) {
    // 1. Cevabı kaydet
    Question currentQ = _displayQuestions[_currentIndex];
    _answers[currentQ.id] = answer;

    // 2. Dinamik Soru Ekleme (Branching Logic)
    // Eğer bu soruya verilen cevap, bir alt soruyu tetikliyorsa:
    var rawQuestions = getQuestions();

    // Bu soruya bağlı alt soruları bul
    var childQuestions = rawQuestions
        .where((q) => q.parentId == currentQ.id)
        .toList();

    for (var child in childQuestions) {
      // Eğer tetikleyici cevap eşleşiyorsa (Örn: trigger=true ve cevap=true)
      if (child.triggerAnswer == answer) {
        // Bu alt soruyu, şu anki sorudan hemen sonraya ekle!
        if (!_displayQuestions.any((q) => q.id == child.id)) {
          _displayQuestions.insert(_currentIndex + 1, child);
        }
      } else {
        // Eğer cevap eşleşmiyorsa ve o soru listede varsa çıkar (Kullanıcı fikrini değiştirirse)
        _displayQuestions.removeWhere((q) => q.id == child.id);
      }
    }

    // 3. İlerle veya Bitir
    if (_currentIndex < _displayQuestions.length - 1) {
      setState(() {
        _currentIndex++;
      });
    } else {
      _finishTest();
    }
  }

  void _finishTest() {
    // --- PUAN HESAPLAMA (Demo Algoritması) ---
    int totalScore = 0;

    // Basit bir mantık: Her "Evet" 2 puan, Yaş > 40 ise 2 puan vb.
    _answers.forEach((key, value) {
      if (value == true) totalScore += 3; // Evet cevapları risklidir
      if (value is int && value > 40) totalScore += 2; // Yaş riski
      if (value.toString() == "Anne / Kız Kardeş") {
        totalScore += 5;
      } // Genetik risk
    });

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => ResultScreen(score: totalScore)),
    );
  }

  // --- ARAYÜZ ---
  @override
  Widget build(BuildContext context) {
    Question currentQ = _displayQuestions[_currentIndex];

    return Scaffold(
      appBar: AppBar(
        title: Text("Soru ${_currentIndex + 1} / ${_displayQuestions.length}"),
        backgroundColor: AppColors.background,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            // SORU METNİ
            Container(
              padding: const EdgeInsets.all(20),
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 5)],
              ),
              child: Column(
                children: [
                  const Icon(
                    Icons.record_voice_over,
                    color: AppColors.primary,
                    size: 40,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    currentQ.text,
                    style: AppTextStyles.header,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            const Spacer(),

            // CEVAP ALANI (Tipe göre değişir)
            _buildInputArea(currentQ),

            const Spacer(),
          ],
        ),
      ),
    );
  }

  Widget _buildInputArea(Question q) {
    switch (q.type) {
      case QuestionType.yesNo:
        return Row(
          children: [
            Expanded(
              child: _BigButton(
                text: "HAYIR",
                color: Colors.green,
                icon: Icons.close,
                onTap: () => _handleAnswer(false),
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: _BigButton(
                text: "EVET",
                color: Colors.red,
                icon: Icons.check,
                onTap: () => _handleAnswer(true),
              ),
            ),
          ],
        );

      case QuestionType.numeric:
        return _NumberInput(onConfirm: (val) => _handleAnswer(val));

      case QuestionType.selection:
        return Column(
          children: q.options!
              .map(
                (opt) => Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: _BigButton(
                    text: opt,
                    color: AppColors.primary,
                    icon: Icons.touch_app,
                    onTap: () => _handleAnswer(opt),
                  ),
                ),
              )
              .toList(),
        );


    }
  }
}

// --- YARDIMCI WIDGETLAR ---

// Büyük Seçim Butonu
class _BigButton extends StatelessWidget {
  final String text;
  final Color color;
  final IconData icon;
  final VoidCallback onTap;

  const _BigButton({
    required this.text,
    required this.color,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 120, // Parmağı zorlamayacak kadar büyük
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
        onPressed: onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: Colors.white),
            const SizedBox(height: 5),
            Text(
              text,
              style: const TextStyle(
                fontSize: 20,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

// Numara Girici (+ / - Sayacı)
class _NumberInput extends StatefulWidget {
  final Function(int) onConfirm;
  const _NumberInput({required this.onConfirm});

  @override
  State<_NumberInput> createState() => _NumberInputState();
}

class _NumberInputState extends State<_NumberInput> {
  int value = 25; // Varsayılan değer

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton.filled(
              onPressed: () => setState(() => value--),
              icon: const Icon(Icons.remove, size: 40),
              style: IconButton.styleFrom(
                backgroundColor: Colors.grey.shade300,
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppColors.primary, width: 2),
              ),
              child: Text(
                "$value",
                style: const TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            IconButton.filled(
              onPressed: () => setState(() => value++),
              icon: const Icon(Icons.add, size: 40),
              style: IconButton.styleFrom(backgroundColor: AppColors.primary),
            ),
          ],
        ),
        const SizedBox(height: 30),
        SizedBox(
          width: 200,
          height: 60,
          child: ElevatedButton(
            onPressed: () => widget.onConfirm(value),
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.success),
            child: const Text(
              "ONAYLA",
              style: TextStyle(fontSize: 22, color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }
}

enum QuestionType { yesNo, selection, numeric }

class RiskQuestion {
  final String apiKey; // Python sunucusunun beklediği tam isim
  final String questionText; // Ekranda okunacak soru
  final QuestionType type; // Soru tipi
  final List<String>? options; // Seçenekler (varsa)
  final dynamic Function(dynamic)?
  valueMapper; // Kullanıcı cevabını Python sayısına çeviren dönüştürücü

  RiskQuestion({
    required this.apiKey,
    required this.questionText,
    required this.type,
    this.options,
    this.valueMapper,
  });
}

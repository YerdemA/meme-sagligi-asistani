// Soruların tipini belirleyen enum (Numara listesi)
enum QuestionType {
  yesNo, // Evet/Hayır butonları çıkacak
  numeric, // Sayı girilecek (Yaş, Kilo)
  selection, // Çoktan seçmeli (Hap türü vb.)
}

class Question {
  final int id;
  final String text;
  final String audioPath; // "Lütfen yaşınızı girin" gibi ses kaydı
  final QuestionType type;

  // Seçenekli sorular için cevap listesi (Örn: ["Doğum Kontrol", "Menopoz"])
  final List<String>? options;

  // --- BAĞLANTILI SORU MANTIĞI ---
  // Bu soru başka bir soruya mı bağlı? (Null ise ana sorudur)
  final int? parentId;

  // Üst soruya ne cevap verilirse bu soru tetiklenir?
  // (Örn: parentId=2 olan soruya "Evet" denirse bu soru açılır)
  final dynamic triggerAnswer;

  // --- RİSK HESAPLAMA ---
  // Bu soruya verilen cevabın risk katsayısı nedir?
  // (Basit tutmak için demo aşamasında burayı manuel yöneteceğiz)

  // Kullanıcının verdiği cevabı tutmak için (Runtime'da dolacak)
  dynamic answer;

  Question({
    required this.id,
    required this.text,
    required this.audioPath,
    required this.type,
    this.options,
    this.parentId,
    this.triggerAnswer,
    this.answer,
  });
}

import '../models/question_model.dart';

List<Question> getQuestions() {
  return [
    // 1. Soru: Yaş
    Question(
      id: 1,
      text: "Yaşınız kaç?",
      audioPath: "assets/audio/q1_yas.mp3",
      type: QuestionType.numeric,
    ),

    // 2. Soru: Ailede Var mı?
    Question(
      id: 2,
      text: "Ailenizde veya yakın çevrenizde meme kanseri geçiren var mı?",
      audioPath: "assets/audio/q2_aile.mp3",
      type: QuestionType.yesNo,
    ),

    // 2.1 Bağlantılı Soru: Yakınlık Derecesi (Sadece Evet denirse çıkar)
    Question(
      id: 3,
      parentId: 2, // 2. soruya bağlı
      triggerAnswer: true, // 2. soruya 'Evet' (true) denirse göster
      text: "Yakınlık derecesi nedir?",
      audioPath: "assets/audio/q3_yakinlik.mp3",
      type: QuestionType.selection,
      options: ["Anne / Kız Kardeş", "Uzak Akraba"],
    ),

    // 3. Soru: Kitle gördünüz mü?
    Question(
      id: 4,
      text: "Daha önce memenizde kitle veya bir sorun fark ettiniz mi?",
      audioPath: "assets/audio/q4_kitle.mp3",
      type: QuestionType.yesNo,
    ),

    // 4. Soru: Doğum
    Question(
      id: 5,
      text: "Hiç doğum yaptınız mı?",
      audioPath: "assets/audio/q5_dogum.mp3",
      type: QuestionType.yesNo,
    ),

    // 5. Soru: Emzirme
    Question(
      id: 6,
      text: "Emzirme durumunuz oldu mu?",
      audioPath: "assets/audio/q6_emzirme.mp3",
      type: QuestionType.yesNo,
    ),

    // 6. Soru: İlk Adet Yaşı
    Question(
      id: 7,
      text: "İlk adet görme yaşınız kaçtı?",
      audioPath: "assets/audio/q7_adet_yasi.mp3",
      type: QuestionType.numeric,
    ),

    // 7. Soru: Menopoz
    Question(
      id: 8,
      text: "Menopoza girdiniz mi?",
      audioPath: "assets/audio/q8_menopoz.mp3",
      type: QuestionType.yesNo,
    ),

    // 7.1 Bağlantılı Soru: Menopoz Yaşı
    Question(
      id: 9,
      parentId: 8,
      triggerAnswer: true,
      text: "Kaç yaşında menopoza girdiniz?",
      audioPath: "assets/audio/q9_menopoz_yasi.mp3",
      type: QuestionType.numeric,
    ),

    // 8. Soru: Hormon İlacı
    Question(
      id: 10,
      text: "Hormon ilacı kullandınız mı?",
      audioPath: "assets/audio/q10_hormon.mp3",
      type: QuestionType.yesNo,
    ),

    // 8.1 Bağlantılı Soru: İlaç Türü
    Question(
      id: 11,
      parentId: 10,
      triggerAnswer: true,
      text: "Hangi ilacı kullandınız?",
      audioPath: "assets/audio/q11_ilac_turu.mp3",
      type: QuestionType.selection,
      options: ["Doğum Kontrol Hapı", "Menopoz İlacı"],
    ),

    // 9. Soru: Kilo
    Question(
      id: 12,
      text: "Kilonuz kaç?",
      audioPath: "assets/audio/q12_kilo.mp3",
      type: QuestionType.numeric,
    ),

    // 10. Soru: Sigara
    Question(
      id: 13,
      text: "Sigara kullanıyor musunuz?",
      audioPath: "assets/audio/q13_sigara.mp3",
      type: QuestionType.yesNo,
    ),

    // 11. Soru: Alkol
    Question(
      id: 14,
      text: "Alkol kullanıyor musunuz?",
      audioPath: "assets/audio/q14_alkol.mp3",
      type: QuestionType.yesNo,
    ),
  ];
}

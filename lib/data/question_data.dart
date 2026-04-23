import '../models/question_model.dart';

List<RiskQuestion> getQuestions() {
  return [
    // 1. Yaş Grubu
    RiskQuestion(
      apiKey: "yas_grubu",
      questionText: "Lütfen yaş aralığınızı seçiniz.",
      type: QuestionType.selection,
      options: [
        "30 yaş altı",
        "30-39 yaş",
        "40-49 yaş",
        "50-59 yaş",
        "60-69 yaş",
        "70 yaş ve üzeri",
      ],
      valueMapper: (cevap) {
        if (cevap == "30 yaş altı") return 0;
        if (cevap == "30-39 yaş") return 1;
        if (cevap == "40-49 yaş") return 2;
        if (cevap == "50-59 yaş") return 3;
        if (cevap == "60-69 yaş") return 4;
        return 5;
      },
    ),
    // 2. Aile Geçmişi
    RiskQuestion(
      apiKey: "birinci_derece_meme_ca",
      questionText:
          "Birinci derece yakınınızda (anne, kız kardeş, kızı) meme kanseri öyküsü var mı?",
      type: QuestionType.yesNo,
      valueMapper: (cevap) => (cevap == true) ? 1 : 0,
    ),
    // 3. Erken Tanı
    RiskQuestion(
      apiKey: "erken_tani",
      questionText:
          "Ailenizde 50 yaşından önce meme kanseri tanısı almış biri var mı?",
      type: QuestionType.yesNo,
      valueMapper: (cevap) => (cevap == true) ? 1 : 0,
    ),
    // 4. Yumurtalık Kanseri
    RiskQuestion(
      apiKey: "yumurtalik_ca",
      questionText: "Ailenizde yumurtalık kanseri öyküsü var mı?",
      type: QuestionType.yesNo,
      valueMapper: (cevap) => (cevap == true) ? 1 : 0,
    ),
    // 5. Kişisel Kanser
    RiskQuestion(
      apiKey: "kisisel_kanser",
      questionText: "Daha önce herhangi bir kanser tedavisi gördünüz mü?",
      type: QuestionType.yesNo,
      valueMapper: (cevap) => (cevap == true) ? 1 : 0,
    ),
    // 6. Biyopsi
    RiskQuestion(
      apiKey: "biyopsi",
      questionText:
          "Daha önce şüpheli bir durum nedeniyle meme biyopsisi yaptırdınız mı?",
      type: QuestionType.yesNo,
      valueMapper: (cevap) => (cevap == true) ? 1 : 0,
    ),
    // 7. İlk Adet Yaşı (Numeric)
    RiskQuestion(
      apiKey: "ilk_adet",
      questionText: "İlk adet gördüğünüz yaş kaçtır?",
      type: QuestionType.numeric,
      valueMapper: (cevap) => cevap, // Sayıyı doğrudan yolla
    ),
    // 8. Doğum
    RiskQuestion(
      apiKey: "dogum",
      questionText:
          "İlk canlı doğumunuzu 30 yaşından sonra mı yaptınız veya hiç doğum yapmadınız mı?",
      type: QuestionType.yesNo,
      valueMapper: (cevap) => (cevap == true) ? 1 : 0,
    ),
    // 9. BMI Grubu
    RiskQuestion(
      apiKey: "bmi_grubu",
      questionText: "Vücut kitle indeksiniz (BMI) hangi aralıkta?",
      type: QuestionType.selection,
      options: ["Zayıf / Normal", "Fazla Kilolu", "Obez", "Aşırı Obez"],
      valueMapper: (cevap) {
        if (cevap == "Zayıf / Normal") return 0;
        if (cevap == "Fazla Kilolu") return 1;
        if (cevap == "Obez") return 2;
        return 3;
      },
    ),
    // 10. Alkol
    RiskQuestion(
      apiKey: "alkol",
      questionText: "Alkol tüketim alışkanlığınız nedir?",
      type: QuestionType.selection,
      options: [
        "Hiç kullanmıyorum",
        "Haftada 1-2 kadeh",
        "Düzenli kullanıyorum",
      ],
      valueMapper: (cevap) {
        if (cevap == "Hiç kullanmıyorum") return 0;
        if (cevap == "Haftada 1-2 kadeh") return 1;
        return 2;
      },
    ),
    // 11. Fiziksel Aktivite
    RiskQuestion(
      apiKey: "fiziksel_aktivite",
      questionText: "Haftada en az 3 gün, 30 dakika egzersiz yapıyor musunuz?",
      type: QuestionType.yesNo,
      valueMapper: (cevap) => (cevap == true) ? 1 : 0,
    ),
    // 12. Mamografi
    RiskQuestion(
      apiKey: "mamografi",
      questionText: "Düzenli mamografi taraması yaptırıyor musunuz?",
      type: QuestionType.yesNo,
      valueMapper: (cevap) => (cevap == true) ? 1 : 0,
    ),
    // 13. KKMM (Kendi Kendine Meme Muayenesi)
    RiskQuestion(
      apiKey: "kkmm_aliskanlik",
      questionText:
          "Her ay Kendi Kendine Meme Muayenesi (KKMM) yapıyor musunuz?",
      type: QuestionType.yesNo,
      valueMapper: (cevap) => (cevap == true) ? 1 : 0,
    ),
  ];
}

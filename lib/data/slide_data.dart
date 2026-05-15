import '../models/slide_model.dart';

// Not: Seslendirme işlemleri merkezi TTS servisi üzerinden yapıldığı için,
// slayt verilerinden ses dosyası (audioPath) özellikleri tamamen kaldırılmıştır.
List<Slide> getSlides() {
  return [
    Slide(
      imagePath: 'assets/education/gorsel1.png',
      text: 'Aynanın karşısına geçin ve ellerinizi belinize koyun.',
    ),
    Slide(
      imagePath: 'assets/education/gorsel2.png',
      text:
          'Memelerinizin şeklinde veya renginde bir değişiklik var mı kontrol edin.',
    ),
    Slide(
      imagePath: 'assets/education/gorsel3.png',
      text:
          'Kollarınızı yukarı kaldırın ve aynı değişiklikleri tekrar gözlemleyin.',
    ),
    Slide(
      imagePath: 'assets/education/gorsel4.png',
      text:
          'Sırtüstü uzanın. Sağ elinizle sol memenizi, sol elinizle sağ memenizi dairesel hareketlerle yoklayın.',
    ),
  ];
}

import '../models/slide_model.dart';

// Klasör yapısına ve yeni dosya isimlerine göre güncellenmiş slayt listesi
List<Slide> getSlides() {
  return [
    Slide(
      imagePath: 'assets/education/gorsel1.png', // Klasör yolunu düzelttik
      text: 'Aynanın karşısına geçin ve ellerinizi belinize koyun.',
      audioPath:
          '', // Artık TTS (seslendirme) kullandığımız için burayı boş bırakabilirsin
    ),
    Slide(
      imagePath: 'assets/education/gorsel2.png',
      text:
          'Memelerinizin şeklinde veya renginde bir değişiklik var mı kontrol edin.',
      audioPath: '',
    ),
    Slide(
      imagePath: 'assets/education/gorsel3.png',
      text:
          'Kollarınızı yukarı kaldırın ve aynı değişiklikleri tekrar gözlemleyin.',
      audioPath: '',
    ),
    Slide(
      imagePath: 'assets/education/gorsel4.png',
      text:
          'Sırtüstü uzanın. Sağ elinizle sol memenizi, sol elinizle sağ memenizi dairesel hareketlerle yoklayın.',
      audioPath: '',
    ),
  ];
}

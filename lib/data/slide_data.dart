import '../models/slide_model.dart';

// Demo için slayt listesi
List<Slide> getSlides() {
  return [
    Slide(
      imagePath: 'assets/images/slide1.png', // Bu resimleri bulman gerekecek
      text: 'Aynanın karşısına geçin ve ellerinizi belinize koyun.',
      audioPath: 'assets/audio/slide1.mp3',
    ),
    Slide(
      imagePath: 'assets/images/slide2.png',
      text:
          'Memelerinizin şeklinde veya renginde bir değişiklik var mı kontrol edin.',
      audioPath: 'assets/audio/slide2.mp3',
    ),
    Slide(
      imagePath: 'assets/images/slide3.png',
      text:
          'Kollarınızı yukarı kaldırın ve aynı değişiklikleri tekrar gözlemleyin.',
      audioPath: 'assets/audio/slide3.mp3',
    ),
    Slide(
      imagePath: 'assets/images/slide4.png',
      text:
          'Sırtüstü uzanın. Sağ elinizle sol memenizi, sol elinizle sağ memenizi dairesel hareketlerle yoklayın.',
      audioPath: 'assets/audio/slide4.mp3',
    ),
  ];
}

class Slide {
  final String imagePath; // Görselin dosya yolu (assets/images/...)
  final String text; // Ekranda yazacak kısa metin
  final String audioPath; // Ses dosyasının yolu (assets/audio/...)

  Slide({required this.imagePath, required this.text, required this.audioPath});
}

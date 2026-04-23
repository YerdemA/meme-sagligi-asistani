import 'package:flutter/material.dart';
import '../services/tts_service.dart'; // TTS servis yolunu projene göre kontrol et

class PreventionGuideScreen extends StatefulWidget {
  const PreventionGuideScreen({super.key});

  @override
  State<PreventionGuideScreen> createState() => _PreventionGuideScreenState();
}

class _PreventionGuideScreenState extends State<PreventionGuideScreen> {
  final TtsService _ttsService = TtsService();

  @override
  void initState() {
    super.initState();
    // Sayfa oluşturulduktan hemen sonra sesli okumayı başlat
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _speakPreventionGuide();
    });
  }

  // Rehber içeriğini özetleyen okuma fonksiyonu
  void _speakPreventionGuide() {
    String textToSpeak =
        "Sağlıklı Yaşam Rehberine Hoş Geldiniz. Meme kanserinden korunmak için: "
        "Meyve ve sebze ağırlıklı beslenin, haftada en az yüz elli dakika egzersiz yapın, "
        "ideal kilonuzu koruyun ve alkol ile tütün ürünlerinden uzak durun. "
        "Unutmayın, erken teşhis hayat kurtarır.";

    _ttsService.speak(textToSpeak, rate: 0.45);
  }

  @override
  void dispose() {
    // Sayfadan çıkıldığında sesin devam etmesini engelle
    _ttsService.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const Color primaryColor = Color(0xFFC2185B); // Rose Deep

    return Scaffold(
      backgroundColor: const Color(0xFFF0F4F8),
      // Kullanıcının sesi tekrar dinleyebilmesi için bir buton ekleyelim
      floatingActionButton: FloatingActionButton(
        onPressed: _speakPreventionGuide,
        backgroundColor: primaryColor,
        child: const Icon(Icons.volume_up, color: Colors.white),
      ),
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // Modern Header
          SliverAppBar(
            expandedHeight: 150,
            pinned: true,
            backgroundColor: primaryColor,
            flexibleSpace: const FlexibleSpaceBar(
              title: Text(
                "Sağlıklı Yaşam Rehberi",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              centerTitle: true,
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionTitle("Kansere Karşı Korunma Yolları"),
                  const SizedBox(height: 15),

                  _buildInfoCard(
                    Icons.apple_rounded,
                    "Sağlıklı Beslenme",
                    "Meyve, sebze ve tam tahıllar açısından zengin bir diyet benimseyin. İşlenmiş gıdalardan uzak durun.",
                    Colors.orange,
                  ),
                  _buildInfoCard(
                    Icons.fitness_center_rounded,
                    "Düzenli Egzersiz",
                    "Haftada en az 150 dakika orta tempolu egzersiz, hormonal dengeyi koruyarak riski azaltır.",
                    Colors.blue,
                  ),
                  _buildInfoCard(
                    Icons.monitor_weight_rounded,
                    "Kilo Kontrolü",
                    "Özellikle menopoz sonrası sağlıklı bir vücut kitle indeksine (BMI) sahip olmak kritiktir.",
                    Colors.green,
                  ),
                  _buildInfoCard(
                    Icons.no_drinks_rounded,
                    "Zararlı Alışkanlıklar",
                    "Alkol tüketimini sınırlandırın ve tütün ürünlerinden tamamen uzak durun.",
                    Colors.red,
                  ),

                  const SizedBox(height: 25),
                  _buildSectionTitle("Erken Teşhisin Önemi"),
                  const SizedBox(height: 15),

                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: primaryColor.withOpacity(0.2)),
                    ),
                    child: const Text(
                      "Meme kanseri erken evrede teşhis edildiğinde tedavi başarı oranı %90'ın üzerindedir. Bu nedenle aylık muayene ve yıllık doktor kontrollerini ihmal etmeyin.",
                      style: TextStyle(
                        fontSize: 14,
                        height: 1.5,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 80,
                  ), // FloatingActionButton için boşluk
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Color(0xFF1A1F2E),
      ),
    );
  }

  Widget _buildInfoCard(IconData icon, String title, String desc, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  desc,
                  style: TextStyle(
                    color: Colors.grey.shade700,
                    fontSize: 13,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

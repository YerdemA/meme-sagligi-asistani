import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  // Render bulut sunucumuzun canlı (Live) adresi
  static const String apiUrl =
      "https://meme-sagligi-api.onrender.com/api/risk-analizi";

  static Future<Map<String, dynamic>> riskAnaliziYap(
    Map<String, dynamic> anketCevaplari,
  ) async {
    try {
      // Bulut sunucusunun (Render) uykudan uyanma ihtimaline karşı 60 saniye bekleme süresi eklendi
      final response = await http
          .post(
            Uri.parse(apiUrl),
            headers: {"Content-Type": "application/json"},
            body: jsonEncode(anketCevaplari),
          )
          .timeout(const Duration(seconds: 75));

      if (response.statusCode == 200) {
        return jsonDecode(utf8.decode(response.bodyBytes));
      } else {
        throw Exception("Sunucu hatası: ${response.statusCode}");
      }
    } catch (e) {
      // Hata mesajı bulut ortamına göre profesyonelleştirildi
      throw Exception(
        "Bağlantı hatası veya zaman aşımı. Lütfen internet bağlantınızı kontrol edip tekrar deneyin. (Sunucu uyanıyor olabilir)",
      );
    }
  }
}

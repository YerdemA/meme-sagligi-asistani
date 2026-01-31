
import 'package:flutter_test/flutter_test.dart';
import 'package:meme_sagligi_asistani/main.dart';

void main() {
  testWidgets('App title smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Verify that our app title is present.
    expect(find.text('Meme Sağlığı Asistanı'), findsOneWidget);
    
    // Verify that the education button is present.
    expect(find.text('Muayene Öğren'), findsOneWidget);
    
    // Verify that the assessment button is present.
    expect(find.text('Risk Testi Yap'), findsOneWidget);
  });
}

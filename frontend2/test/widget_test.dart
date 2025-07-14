import 'package:flutter_test/flutter_test.dart';
import 'package:potato_disease_detection/main.dart';

void main() {
  testWidgets('App bar title is present', (WidgetTester tester) async {
    await tester.pumpWidget(PotatoDiseaseApp(apiUrl: 'https://test-api-url.com'));
    expect(find.text('Potato Disease Detector'), findsOneWidget);
  });
}
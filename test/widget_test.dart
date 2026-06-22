import 'package:flutter_test/flutter_test.dart';
import 'package:taller_1_am3/main.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const PeliculasApp());
  });
}

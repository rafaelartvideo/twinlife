import 'package:flutter_test/flutter_test.dart';
import 'package:twinlife/app/app.dart';

void main() {
  testWidgets('TwinLife opens onboarding', (tester) async {
    await tester.pumpWidget(const TwinLifeApp());

    expect(find.text('TwinLife'), findsOneWidget);
    expect(find.text('Começar nossa história'), findsOneWidget);
  });
}

import 'package:flutter_test/flutter_test.dart';
import 'package:twinlife/app/app.dart';

void main() {
  testWidgets('TwinLife opens initial setup quiz', (tester) async {
    await tester.pumpWidget(const TwinLifeApp());

    expect(find.text('TwinLife'), findsOneWidget);
    expect(find.text('Vamos conhecer um pouco de vocês?'), findsOneWidget);
    expect(find.text('Continuar'), findsOneWidget);
  });
}

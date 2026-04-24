import 'package:batseeku/main.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('app starts at launch screen', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: BatSeekUApp(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('BatSeekU'), findsOneWidget);
    expect(find.text('Get Started'), findsOneWidget);
  });
}

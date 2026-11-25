import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:nirmaan/main.dart';

void main() {
  testWidgets('App renders Nirmaan title', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(child: NirmaanApp()),
    );
    await tester.pumpAndSettle();

    expect(find.text('Nirmaan'), findsOneWidget);
  });
}

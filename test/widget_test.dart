import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:nirmaan/main.dart';

void main() {
  testWidgets('App renders Nirmaan title on launch', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(child: NirmaanApp()),
    );
    await tester.pump(const Duration(milliseconds: 300));
    expect(find.text('Nirmaan'), findsWidgets);

    // Advance past splash timer
    await tester.pump(const Duration(milliseconds: 2200));
    await tester.pump();
  });
}

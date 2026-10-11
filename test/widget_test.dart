import 'package:flutter_test/flutter_test.dart';
import 'package:novejal_mark/main.dart';

void main() {
  testWidgets('Voting screen renders smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    expect(find.text('গাছ পয়েন্ট সিস্টেম (৫ জন ইউজার)'), findsOneWidget);
  });
}

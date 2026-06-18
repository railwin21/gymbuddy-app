import 'package:flutter_test/flutter_test.dart';
import 'package:gymbuddy/main.dart';

void main() {
  testWidgets('App loads GymBuddy', (WidgetTester tester) async {
    await tester.pumpWidget(const GymBuddyApp());
    expect(find.text('GymBuddy'), findsOneWidget);
  });
}

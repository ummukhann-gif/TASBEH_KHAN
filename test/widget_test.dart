import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:terra_tasbih/app_state.dart';
import 'package:terra_tasbih/main.dart';

void main() {
  testWidgets('app boots into Terra Tasbih shell', (tester) async {
    SharedPreferences.setMockInitialValues({});
    final state = await TasbihAppState.load();

    await tester.pumpWidget(TerraTasbihApp(state: state));
    await tester.pumpAndSettle();

    expect(find.text('Terra Tasbih'), findsWidgets);
    expect(find.text('Counter'), findsOneWidget);
  });
}

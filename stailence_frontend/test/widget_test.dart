// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:stailence_frontend/injection_container.dart';
import 'package:stailence_frontend/main.dart';

void main() {
  const MethodChannel secureStorageChannel = MethodChannel('plugins.it_nomads.com/flutter_secure_storage');

  setUpAll(() {
    TestWidgetsFlutterBinding.ensureInitialized();
    SharedPreferences.setMockInitialValues(<String, Object>{});
    secureStorageChannel.setMockMethodCallHandler((MethodCall call) async {
      switch (call.method) {
        case 'read':
          return null;
        case 'write':
        case 'delete':
        case 'deleteAll':
        case 'writeAll':
          return null;
        case 'readAll':
          return <String, String>{};
        default:
          return null;
      }
    });
  });

  tearDownAll(() {
    secureStorageChannel.setMockMethodCallHandler(null);
  });

  testWidgets('Stailence app renders splash screen', (WidgetTester tester) async {
    await InjectionContainer.init();

    await tester.pumpWidget(const StailenceApp());

    expect(find.text('Stailence'), findsOneWidget);
  });
}

import 'dart:async';
import 'package:flutter_test/flutter_test.dart';

Future<void> testExecutable(FutureOr<void> Function() testMain) async {
  // Initialize Flutter binding for native plugins
  TestWidgetsFlutterBinding.ensureInitialized();

  // Run all tests
  await testMain();
}
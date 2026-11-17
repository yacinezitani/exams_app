import 'package:exam_app/app.dart';
import 'package:exam_app/core/di/injection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:intl/date_symbol_data_local.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting();
  await setupInjection();

  assert(() {
    Animate.restartOnHotReload = true;
    return true;
  }());

  runApp(const RecallApp());
}

import 'package:flutter/material.dart';
import 'package:iem_2022_spot_discovery/app/app.dart';
import 'package:iem_2022_spot_discovery/core/manager/database_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DatabaseManager().init();
  runApp(const App());
}

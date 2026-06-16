import 'package:flutter/material.dart';
import 'package:instagram_reel/app/app.dart';
import 'package:instagram_reel/di/injection.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await configureDependencies();

  runApp(const MyApp());
}

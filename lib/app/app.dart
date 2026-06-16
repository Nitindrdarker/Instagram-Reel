import 'package:flutter/material.dart';
import 'package:instagram_reel/features/feed/presentation/pages/feed_page.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const FeedPage(),
    );
  }
}

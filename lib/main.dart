import 'package:flutter/material.dart';
import 'package:salvation_bible_app/routing/app_routes.dart';
import 'package:salvation_bible_app/view/theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
debugShowCheckedModeBanner: false,
theme: AppTheme.theme,
routerConfig: router,
    );
  }
}

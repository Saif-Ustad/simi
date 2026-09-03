import 'package:flutter/material.dart';

import 'core/config/routes/router.dart';
import 'core/config/theme/app_theme.dart';

void main() {
  runApp(const SimiApp());
}

class SimiApp extends StatelessWidget {
  const SimiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'SIMI ❤️',

      theme: AppTheme.light,

      routerConfig: router,
    );
  }
}
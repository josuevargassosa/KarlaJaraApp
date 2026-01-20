import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:provider/provider.dart';

import 'core/routes/app_router.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/theme_provider.dart';

Future<void> main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  runApp(
    MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => ThemeProvider())],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final router = AppRouter.buildRouter();
    final themeMode = context.watch<ThemeProvider>().themeMode;

    // Remove splash screen when UI builds
    FlutterNativeSplash.remove();

    return MaterialApp.router(
      title: 'The Bridge',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme(),
      themeMode: themeMode,
      routerConfig: router,
    );
  }
}

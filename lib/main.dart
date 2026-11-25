import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'app/router.dart';
import 'core/theme/app_theme.dart';
import 'core/providers/theme_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: '.env');

  runApp(const ProviderScope(child: NirmaanApp()));
}

class NirmaanApp extends ConsumerWidget {
  const NirmaanApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);

    return MaterialApp.router(
      title: 'Nirmaan',
      debugShowCheckedModeBanner: false,
      theme: NirmaanTheme.light,
      darkTheme: NirmaanTheme.dark,
      themeMode: themeMode,
      routerConfig: appRouter,
    );
  }
}

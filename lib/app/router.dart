/// GoRouter configuration for Nirmaan.
library;

import 'package:go_router/go_router.dart';
import '../app/app_shell.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const AppShell(),
    ),
  ],
);

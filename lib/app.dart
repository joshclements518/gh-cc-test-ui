import 'package:flutter/material.dart';
import 'features/auth/login_screen.dart';
import 'features/shell/main_shell.dart';
import 'state/app_state.dart';
import 'theme/app_theme.dart';

class HarborlineApp extends StatelessWidget {
  const HarborlineApp({super.key, required this.state});
  final AppState state;

  @override
  Widget build(BuildContext context) {
    return AppScope(
      state: state,
      child: AnimatedBuilder(
        animation: state,
        builder: (context, _) {
          return MaterialApp(
            title: 'Harborline Navigator',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.light(),
            home: state.signedIn ? const MainShell() : const LoginScreen(),
          );
        },
      ),
    );
  }
}

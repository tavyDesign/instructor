import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:instructor_auto/providers/auth_provider.dart';
import 'package:instructor_auto/screens/login_screen.dart';
import 'package:instructor_auto/screens/home_screen.dart';

class AuthChecker extends ConsumerWidget {
  const AuthChecker({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);

    return authState.maybeWhen(
      data: (user) => user != null ? HomeScreen() : const LoginScreen(),
      orElse: () => const LoginScreen(),
    );
  }
}

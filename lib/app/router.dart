import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';

import '../features/auth/presentation/login_screen.dart';
import '../features/dashboard/presentation/dashboard_screen.dart';
import '../features/tasks/presentation/task_list_screen.dart';
import '../features/tasks/presentation/task_detail_screen.dart';
import '../features/tasks/presentation/task_create_wizard.dart';
import '../features/auth/presentation/forgot_password_screen.dart';
import '../features/auth/presentation/verify_code_screen.dart';
import '../features/auth/presentation/reset_password_screen.dart';
import '../data/models/task.dart';

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        name: 'splash',
        builder: (context, state) => const _Splash(),
      ),
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/home',
        name: 'home',
        builder: (context, state) => const DashboardScreen(),
      ),

      // Tasks
      GoRoute(
        path: '/tasks',
        name: 'tasks',
        builder: (context, state) => const TaskListScreen(),
      ),
      GoRoute(
        path: '/tasks/create',
        name: 'task_create',
        builder: (context, state) => const TaskCreateWizard(),
      ),
      GoRoute(
        path: '/tasks/:id',
        name: 'task_detail',
        builder: (context, state) => TaskDetailScreen(
          initial: state.extra is Task ? state.extra as Task : null,
        ),
      ),

      // Auth recovery
      GoRoute(
        path: '/forgot',
        name: 'forgot',
        builder: (context, state) => const ForgotPasswordScreen(),
      ),
      GoRoute(
        path: '/verify',
        name: 'verify',
        builder: (context, state) {
          final email = (state.extra as String?) ?? '';
          return VerifyCodeScreen(email: email);
        },
      ),
      GoRoute(
        path: '/reset',
        name: 'reset_password', // single, unique route
        builder: (context, state) {
          String email = '';
          String otp = '';
          final extra = state.extra;
          if (extra is Map) {
            email = (extra['email'] as String?) ?? '';
            otp = (extra['otp'] as String?) ?? '';
          } else if (extra is String) {
            email = extra;
          }
          return ResetPasswordScreen(email: email, initialOtp: otp);
        },
      ),
      GoRoute(
        path: '/auth/reset',              // unique path
        name: 'auth_reset_password',      // unique name
        builder: (context, state) {
          String email = '';
          String otp = '';
          final extra = state.extra;
          if (extra is Map) {
            email = (extra['email'] as String?) ?? '';
            otp   = (extra['otp'] as String?) ?? '';
          } else if (extra is String) {
            email = extra;
          }
          return ResetPasswordScreen(email: email, initialOtp: otp);
        },
      ),
    ],
  );
});

class _Splash extends StatelessWidget {
  const _Splash();

  @override
  Widget build(BuildContext context) {
    Future.microtask(() async {
      await Future<void>.delayed(const Duration(milliseconds: 500));
      if (context.mounted) context.go('/login');
    });
    return const Scaffold(body: Center(child: FlutterLogo(size: 72)));
  }
}

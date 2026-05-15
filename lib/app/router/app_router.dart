import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../di/injection.dart';
import '../../features/auth/presentation/cubit/auth_cubit.dart';
import '../../features/auth/presentation/cubit/auth_state.dart';
import '../../features/auth/presentation/pages/forgot_password_page.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/pages/register_page.dart';
import '../../features/auth/presentation/pages/splash_page.dart';
import '../../features/auth/presentation/pages/welcome_page.dart';
import '../../features/exercise/presentation/pages/exercise_detail_page.dart';
import '../../features/home/presentation/pages/home_dashboard_page.dart';
import '../../features/onboarding/presentation/pages/onboarding_page.dart';
import '../../features/exercise/presentation/pages/exercise_list_page.dart';
import '../../features/exercise/presentation/pages/exercise_player_page.dart';
import '../../features/profile/presentation/pages/edit_profile_page.dart';
import '../../features/profile/presentation/pages/profile_page.dart';
import '../../features/progress/presentation/pages/progress_page.dart';
import '../../features/settings/presentation/pages/privacy_policy_page.dart';
import '../../features/settings/presentation/pages/settings_page.dart';
import '../../features/settings/presentation/pages/terms_of_service_page.dart';
import '../../features/sos/presentation/pages/sos_page.dart';
import 'go_router_refresh_stream.dart';
import 'route_names.dart';
import 'scaffold_with_nav_bar.dart';

// ignore: avoid_classes_with_only_static_members
class AppRouter {
  /// The application router.
  ///
  /// [GoRouter.optionURLReflectsImperativeAPIs] is enabled so that
  /// imperative navigation calls (push/pop) are reflected in the URL bar.
  static final GoRouter router = _createRouter();

  static GoRouter _createRouter() {
    GoRouter.optionURLReflectsImperativeAPIs = true;
    return GoRouter(
      initialLocation: '/',
      debugLogDiagnostics: true,
      refreshListenable:
          GoRouterRefreshStream(getIt<AuthCubit>().stream),
      redirect: _redirect,
      routes: [
        // ── Unauthenticated routes ────────────────────────────────────────
        GoRoute(
          path: '/',
          name: RouteNames.splash,
          builder: (context, state) => const SplashPage(),
        ),
        GoRoute(
          path: '/welcome',
          name: RouteNames.welcome,
          builder: (context, state) => const WelcomePage(),
        ),
        GoRoute(
          path: '/login',
          name: RouteNames.login,
          builder: (context, state) => const LoginPage(),
        ),
        GoRoute(
          path: '/register',
          name: RouteNames.register,
          builder: (context, state) => const RegisterPage(),
        ),
        GoRoute(
          path: '/forgot-password',
          name: RouteNames.forgotPassword,
          builder: (context, state) => const ForgotPasswordPage(),
        ),
        GoRoute(
          path: '/onboarding',
          name: RouteNames.onboarding,
          builder: (context, state) => const OnboardingPage(),
        ),
        GoRoute(
          path: '/onboarding/:step',
          name: RouteNames.onboardingStep,
          builder: (context, state) {
            final step = state.pathParameters['step'] ?? '1';
            return _PlaceholderPage(name: 'Onboarding Step $step');
          },
        ),

        // ── Public / legal routes ─────────────────────────────────────────
        GoRoute(
          path: '/privacy-policy',
          name: RouteNames.privacyPolicy,
          builder: (context, state) => const PrivacyPolicyPage(),
        ),
        GoRoute(
          path: '/terms-of-service',
          name: RouteNames.termsOfService,
          builder: (context, state) => const TermsOfServicePage(),
        ),

        // ── Authenticated standalone routes ───────────────────────────────
        GoRoute(
          path: '/settings',
          name: RouteNames.settings,
          builder: (context, state) => const SettingsPage(),
        ),
        GoRoute(
          path: '/sos',
          name: RouteNames.sos,
          builder: (context, state) => const SosPage(),
        ),

        // ── Shell route — bottom navigation tabs ──────────────────────────
        ShellRoute(
          builder: (context, state, child) =>
              ScaffoldWithNavBar(child: child),
          routes: [
            GoRoute(
              path: '/home',
              name: RouteNames.home,
              builder: (context, state) => const HomeDashboardPage(),
            ),
            GoRoute(
              path: '/exercise',
              name: RouteNames.exerciseList,
              builder: (context, state) => const ExerciseListPage(),
              routes: [
                GoRoute(
                  path: ':id',
                  name: RouteNames.exerciseDetail,
                  builder: (context, state) {
                    final id = state.pathParameters['id'] ?? '';
                    return ExerciseDetailPage(exerciseId: id);
                  },
                  routes: [
                    GoRoute(
                      path: 'play',
                      name: RouteNames.exercisePlayer,
                      builder: (context, state) {
                        final id = state.pathParameters['id'] ?? '';
                        return ExercisePlayerPage(exerciseId: id);
                      },
                    ),
                  ],
                ),
              ],
            ),
            GoRoute(
              path: '/progress',
              name: RouteNames.progress,
              builder: (context, state) => const ProgressPage(),
            ),
            GoRoute(
              path: '/profile',
              name: RouteNames.profile,
              builder: (context, state) => const ProfilePage(),
              routes: [
                GoRoute(
                  path: 'edit',
                  name: RouteNames.editProfile,
                  builder: (context, state) => const EditProfilePage(),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  /// Routes that are always accessible regardless of auth state.
  static const _publicRoutes = <String>{
    '/privacy-policy',
    '/terms-of-service',
  };

  /// Routes that are only for unauthenticated / pre-auth users.
  static const _unauthOnlyRoutes = <String>{
    '/welcome',
    '/login',
    '/register',
    '/forgot-password',
  };

  /// Routes that require a fully authenticated (non-guest) user.
  static const _authenticatedRoutes = <String>{
    '/settings',
    '/sos',
    '/home',
    '/exercise',
    '/progress',
    '/profile',
  };

  /// Redirect callback wired to [AuthCubit] state.
  ///
  /// Rules:
  /// - [AuthInitial] / [AuthLoading] → stay on splash ('/') while resolving.
  /// - [AuthUnauthenticated] accessing an auth-required route → '/welcome'.
  /// - [AuthGuest] accessing a fully-authenticated-only route → '/welcome'.
  /// - [AuthAuthenticated] / [AuthGuest] accessing an unauth-only route → '/home'.
  /// - [AuthError] → '/welcome' so the user can retry.
  static String? _redirect(BuildContext context, GoRouterState state) {
    final authState = getIt<AuthCubit>().state;
    final location = state.matchedLocation;

    // Always allow public routes.
    if (_publicRoutes.contains(location)) return null;

    switch (authState) {
      case AuthInitial() || AuthLoading():
        // Stay on splash while auth state is being resolved.
        return location == '/' ? null : '/';

      case AuthUnauthenticated() || AuthError():
        // Send unauthenticated users to welcome unless already on an
        // unauth-only or public route.
        if (_unauthOnlyRoutes.contains(location) || location == '/') {
          return null;
        }
        return '/welcome';

      case AuthGuest():
        // Guests can access unauth-only routes and the splash, but not
        // routes that require a full account.
        if (_unauthOnlyRoutes.contains(location) || location == '/') {
          return '/home';
        }
        if (_authenticatedRoutes.any((r) => location.startsWith(r))) {
          return null;
        }
        return null;

      case AuthAuthenticated():
        // Fully authenticated users should not see unauth-only screens.
        if (_unauthOnlyRoutes.contains(location) || location == '/') {
          return '/home';
        }
        return null;
    }
  }
}

// ── Placeholder widget ────────────────────────────────────────────────────────

class _PlaceholderPage extends StatelessWidget {
  final String name;
  const _PlaceholderPage({required this.name});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(name)),
      body: Center(child: Text(name)),
    );
  }
}

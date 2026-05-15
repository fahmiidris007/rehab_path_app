import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../../core/constants/app_constants.dart';
import '../cubit/auth_cubit.dart';
import '../cubit/auth_state.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    await Future.delayed(
      const Duration(milliseconds: AppConstants.splashMinDurationMs),
    );
    if (mounted) {
      context.read<AuthCubit>().checkSession();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        switch (state) {
          case AuthAuthenticated() || AuthGuest():
            context.go('/home');
          case AuthUnauthenticated():
            context.go('/welcome');
          default:
            break;
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: Center(
          child: Text(
            'RehabPath',
            style: AppTextStyles.displayH1.copyWith(
              color: AppColors.primary,
            ),
          ),
        ),
      ),
    );
  }
}

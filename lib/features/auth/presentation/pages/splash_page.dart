import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../../core/constants/app_constants.dart';
import '../cubit/auth_cubit.dart';

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
      // Trigger session check — GoRouter's redirect (via GoRouterRefreshStream)
      // will handle navigation once the AuthCubit emits a resolved state.
      context.read<AuthCubit>().checkSession();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: Text(
          'RehabPath',
          style: AppTextStyles.displayH1.copyWith(
            color: AppColors.primary,
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../di/injection.dart';
import '../features/auth/presentation/cubit/auth_cubit.dart';
import '../l10n/app_localizations.dart';
import '../shared/domain/enums/app_enums.dart';
import 'cubit/app_cubit.dart';
import 'router/app_router.dart';
import 'theme/app_theme.dart';

class RehabPathApp extends StatelessWidget {
  const RehabPathApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AppCubit>(
          create: (_) {
            final cubit = AppCubit();
            // Load persisted settings asynchronously so the UI reflects
            // the user's last saved preferences as early as possible.
            cubit.loadPersistedSettings();
            return cubit;
          },
        ),
        BlocProvider<AuthCubit>(
          create: (_) => getIt<AuthCubit>(),
        ),
      ],
      child: const _AppView(),
    );
  }
}

class _AppView extends StatelessWidget {
  const _AppView();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppCubit, AppState>(
      builder: (context, state) {
        final cubit = context.read<AppCubit>();

        return MediaQuery.withClampedTextScaling(
          minScaleFactor: cubit.fontSizeMultiplier,
          maxScaleFactor: cubit.fontSizeMultiplier,
          child: MaterialApp.router(
            title: 'RehabPath',
            routerConfig: AppRouter.router,
            // Localization
            locale: _toLocale(state.locale),
            supportedLocales: AppLocalizations.supportedLocales,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            // Always use light theme — the app design is optimised for light
            // mode only. Forcing ThemeMode.light prevents the device dark-mode
            // setting from breaking the UI.
            theme: AppTheme.light(),
            themeMode: ThemeMode.light,
          ),
        );
      },
    );
  }

  Locale _toLocale(AppLocale appLocale) {
    return switch (appLocale) {
      AppLocale.en => const Locale('en'),
      AppLocale.id => const Locale('id'),
    };
  }
}

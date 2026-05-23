import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../../core/widgets/app_error_widget.dart';
import '../../../../core/widgets/app_loading_widget.dart';
import '../../../../core/widgets/app_top_app_bar.dart';
import '../../../../di/injection.dart';
import '../../../../features/auth/presentation/cubit/auth_cubit.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../shared/domain/enums/app_enums.dart';
import '../cubit/settings_cubit.dart';
import '../widgets/biometric_login_toggle.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<SettingsCubit>()..loadSettings(),
      child: const _SettingsView(),
    );
  }
}

class _SettingsView extends StatelessWidget {
  const _SettingsView();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppTopAppBar(
        title: l10n.settingsTitle,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          color: AppColors.textPrimary,
          onPressed: () => context.pop(),
        ),
      ),
      body: BlocConsumer<SettingsCubit, SettingsState>(
        listenWhen: (_, current) =>
            current is SettingsNotificationPermissionDenied,
        listener: (context, state) {
          if (state is SettingsNotificationPermissionDenied) {
            _showPermissionDeniedDialog(context);
          }
        },
        builder: (context, state) {
          return switch (state) {
            SettingsLoading() => const AppLoadingWidget(),
            SettingsError(:final message) => AppErrorWidget(message: message),
            SettingsLoaded(:final data) => _SettingsContent(data: data),
            SettingsNotificationPermissionDenied(:final data) =>
              _SettingsContent(data: data),
          };
        },
      ),
    );
  }

  void _showPermissionDeniedDialog(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    showDialog<void>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(l10n.settingsNotificationPermissionDeniedTitle),
        content: Text(l10n.settingsNotificationPermissionDeniedMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(l10n.commonOk),
          ),
        ],
      ),
    );
  }
}

class _SettingsContent extends StatelessWidget {
  const _SettingsContent({required this.data});

  final SettingsData data;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final cubit = context.read<SettingsCubit>();

    return ListView(
      children: [
        // ── Appearance ───────────────────────────────────────────────────
        // _SectionHeader(title: l10n.settingsAppearance),
        // _SubSectionLabel(label: l10n.settingsTheme),
        // _RadioGroup<AppThemeMode>(
        //   groupValue: data.themeMode,
        //   onChanged: (v) => cubit.changeTheme(v),
        //   items: [
        //     (value: AppThemeMode.light, label: l10n.settingsThemeLight),
        //     (value: AppThemeMode.dark, label: l10n.settingsThemeDark),
        //     (value: AppThemeMode.system, label: l10n.settingsThemeSystem),
        //   ],
        // ),
        // const Divider(height: 1),
        // _SubSectionLabel(label: l10n.settingsFontSize),
        // _RadioGroup<FontSizeLevel>(
        //   groupValue: data.fontSizeLevel,
        //   onChanged: (v) => cubit.changeFontSize(v),
        //   items: [
        //     (value: FontSizeLevel.defaultSize, label: l10n.settingsFontSizeDefault),
        //     (value: FontSizeLevel.large, label: l10n.settingsFontSizeLarge),
        //     (value: FontSizeLevel.extraLarge, label: l10n.settingsFontSizeExtraLarge),
        //   ],
        // ),

        // ── Language ─────────────────────────────────────────────────────
        _SectionHeader(title: l10n.settingsLanguage),
        _RadioGroup<AppLocale>(
          groupValue: data.locale,
          onChanged: (v) => cubit.changeLocale(v),
          items: [
            (value: AppLocale.en, label: l10n.settingsLanguageEn),
            (value: AppLocale.id, label: l10n.settingsLanguageId),
          ],
        ),

        // ── Notifications ────────────────────────────────────────────────
        _SectionHeader(title: l10n.settingsNotifications),
        SwitchListTile(
          title: Text(
            l10n.settingsDailyReminder,
            style: AppTextStyles.body.copyWith(color: AppColors.textPrimary),
          ),
          subtitle: Text(
            l10n.settingsDailyReminderSubtitle,
            style: AppTextStyles.body.copyWith(
              color: AppColors.textSecondary,
              fontSize: 14,
            ),
          ),
          value: data.notificationsEnabled,
          activeThumbColor: AppColors.primary,
          onChanged: (enabled) => cubit.toggleNotifications(enabled),
        ),
        SwitchListTile(
          title: Text(
            l10n.settingsVoiceCues,
            style: AppTextStyles.body.copyWith(color: AppColors.textPrimary),
          ),
          subtitle: Text(
            l10n.settingsVoiceCuesSubtitle,
            style: AppTextStyles.body.copyWith(
              color: AppColors.textSecondary,
              fontSize: 14,
            ),
          ),
          value: data.voiceCuesEnabled,
          activeThumbColor: AppColors.primary,
          onChanged: (enabled) => cubit.toggleVoiceCues(enabled),
        ),
        const BiometricLoginToggle(),

        // // ── Account ──────────────────────────────────────────────────────
        // _SectionHeader(title: l10n.settingsAccount),
        // ListTile(
        //   title: Text(
        //     l10n.settingsPrivacyPolicy,
        //     style: AppTextStyles.body.copyWith(color: AppColors.textPrimary),
        //   ),
        //   trailing: const Icon(
        //     Icons.chevron_right,
        //     color: AppColors.textSecondary,
        //   ),
        //   onTap: () => context.pushNamed('privacy-policy'),
        // ),
        // ListTile(
        //   title: Text(
        //     l10n.settingsTermsOfService,
        //     style: AppTextStyles.body.copyWith(color: AppColors.textPrimary),
        //   ),
        //   trailing: const Icon(
        //     Icons.chevron_right,
        //     color: AppColors.textSecondary,
        //   ),
        //   onTap: () => context.pushNamed('terms-of-service'),
        // ),
        // ListTile(
        //   title: Text(
        //     l10n.settingsLogout,
        //     style: AppTextStyles.body.copyWith(color: AppColors.error),
        //   ),
        //   leading: const Icon(Icons.logout, color: AppColors.error),
        //   onTap: () => context.read<AuthCubit>().logout(),
        // ),
        const SizedBox(height: 32),
      ],
    );
  }
}

// ── Helpers ───────────────────────────────────────────────────────────────────

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 4),
      child: Text(
        title,
        style: AppTextStyles.h3Section.copyWith(
          color: AppColors.textPrimary,
        ),
      ),
    );
  }
}

class _SubSectionLabel extends StatelessWidget {
  const _SubSectionLabel({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
      child: Text(
        label,
        style: AppTextStyles.bodySemiBold.copyWith(
          color: AppColors.textSecondary,
        ),
      ),
    );
  }
}

/// A group of radio tiles backed by [RadioGroup] (Flutter ≥ 3.32).
class _RadioGroup<T> extends StatelessWidget {
  const _RadioGroup({
    required this.groupValue,
    required this.onChanged,
    required this.items,
  });

  final T groupValue;
  final ValueChanged<T> onChanged;
  final List<({T value, String label})> items;

  @override
  Widget build(BuildContext context) {
    return RadioGroup<T>(
      groupValue: groupValue,
      onChanged: (v) {
        if (v != null) onChanged(v);
      },
      child: Column(
        children: items
            .map(
              (item) => ListTile(
                title: Text(
                  item.label,
                  style: AppTextStyles.body
                      .copyWith(color: AppColors.textPrimary),
                ),
                leading: Radio<T>(
                  value: item.value,
                ),
                onTap: () => onChanged(item.value),
              ),
            )
            .toList(),
      ),
    );
  }
}

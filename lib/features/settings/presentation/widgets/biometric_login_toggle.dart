import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../auth/presentation/cubit/auth_cubit.dart';
import '../../../auth/presentation/cubit/auth_state.dart';
import '../cubit/settings_cubit.dart';

/// Toggle that enables or disables biometric login from the settings screen.
///
/// Behaviour (Requirements 4.1, 4.2, 13.1, 13.3):
/// - Reads `biometricEnabled` and `biometricCapable` from [SettingsCubit].
/// - Disabled when the device has no biometric capability or the user is
///   not currently authenticated (we cannot store credentials for an
///   unknown account).
/// - Enabling triggers a password re-entry sheet; on confirm we delegate
///   to [SettingsCubit.enableBiometric] which orchestrates the OS prompt
///   and credential storage. Disabling clears credentials directly.
/// - Listens for the `settingsBiometricEnableFailed` error state to surface
///   a localized SnackBar.
class BiometricLoginToggle extends StatelessWidget {
  const BiometricLoginToggle({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return BlocListener<SettingsCubit, SettingsState>(
      listenWhen: (_, current) => current is SettingsError,
      listener: (context, state) {
        if (state is SettingsError &&
            state.message == 'settingsBiometricEnableFailed') {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(content: Text(l10n.settingsBiometricEnableFailed)),
            );
        }
      },
      child: BlocBuilder<SettingsCubit, SettingsState>(
        buildWhen: (previous, current) =>
            previous is! SettingsLoaded ||
            current is SettingsLoaded ||
            current is SettingsNotificationPermissionDenied,
        builder: (context, state) {
          final data = switch (state) {
            SettingsLoaded(:final data) => data,
            SettingsNotificationPermissionDenied(:final data) => data,
            _ => null,
          };

          // Always render the tile so the layout is stable while loading;
          // the switch is simply disabled until data arrives.
          final biometricCapable = data?.biometricCapable ?? false;
          final biometricEnabled = data?.biometricEnabled ?? false;

          return BlocBuilder<AuthCubit, AuthState>(
            builder: (context, authState) {
              final isAuthenticated = authState is AuthAuthenticated;
              final isEnabledControl =
                  data != null && biometricCapable && isAuthenticated;

              return Semantics(
                label: l10n.settingsBiometricToggle,
                toggled: biometricEnabled,
                child: SwitchListTile(
                  title: Text(
                    l10n.settingsBiometricToggle,
                    style: AppTextStyles.body
                        .copyWith(color: AppColors.textPrimary),
                  ),
                  value: biometricEnabled,
                  activeThumbColor: AppColors.primary,
                  onChanged: isEnabledControl
                      ? (next) => _handleToggle(context, next, l10n)
                      : null,
                ),
              );
            },
          );
        },
      ),
    );
  }

  void _handleToggle(
    BuildContext context,
    bool turningOn,
    AppLocalizations l10n,
  ) {
    if (!turningOn) {
      context.read<SettingsCubit>().disableBiometric();
      return;
    }
    _promptForPassword(context, l10n);
  }

  Future<void> _promptForPassword(
    BuildContext context,
    AppLocalizations l10n,
  ) async {
    final settingsCubit = context.read<SettingsCubit>();
    final password = await showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      builder: (sheetContext) => _PasswordPromptSheet(
        title: l10n.settingsBiometricEnableTitle,
        message: l10n.settingsBiometricVerifyPassword,
        passwordHint: l10n.authLoginPasswordHint,
        confirmLabel: l10n.commonConfirm,
        cancelLabel: l10n.commonCancel,
      ),
    );

    if (password == null || password.isEmpty) {
      return;
    }

    await settingsCubit.enableBiometric(
      enteredPassword: password,
      reason: l10n.authBiometricReason,
    );
  }
}

class _PasswordPromptSheet extends StatefulWidget {
  const _PasswordPromptSheet({
    required this.title,
    required this.message,
    required this.passwordHint,
    required this.confirmLabel,
    required this.cancelLabel,
  });

  final String title;
  final String message;
  final String passwordHint;
  final String confirmLabel;
  final String cancelLabel;

  @override
  State<_PasswordPromptSheet> createState() => _PasswordPromptSheetState();
}

class _PasswordPromptSheetState extends State<_PasswordPromptSheet> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _confirm() {
    final value = _controller.text;
    if (value.isEmpty) return;
    Navigator.of(context).pop(value);
  }

  @override
  Widget build(BuildContext context) {
    final viewInsets = MediaQuery.of(context).viewInsets.bottom;
    return Padding(
      padding: EdgeInsets.fromLTRB(24, 24, 24, 24 + viewInsets),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            widget.title,
            style: AppTextStyles.h3Section
                .copyWith(color: AppColors.textPrimary),
          ),
          const SizedBox(height: 12),
          Text(
            widget.message,
            style: AppTextStyles.body.copyWith(color: AppColors.textSecondary),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _controller,
            obscureText: true,
            autofocus: true,
            textInputAction: TextInputAction.done,
            onSubmitted: (_) => _confirm(),
            decoration: InputDecoration(
              hintText: widget.passwordHint,
              border: const OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: 48,
                  child: OutlinedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text(widget.cancelLabel),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: SizedBox(
                  height: 48,
                  child: FilledButton(
                    onPressed: _confirm,
                    child: Text(widget.confirmLabel),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

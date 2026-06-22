import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:logger/logger.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_dimensions.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../../core/constants/pref_keys.dart';
import '../../../../core/widgets/app_primary_button.dart';
import '../../../../core/widgets/language_selector_button.dart';
import '../../../../di/injection.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../shared/data/datasources/shared_preferences_data_source.dart';
import '../../domain/repositories/biometric_credential_repository.dart';
import '../../domain/validators/password_input.dart';
import '../../domain/validators/phone_input.dart';
import '../cubit/auth_cubit.dart';
import '../cubit/auth_state.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();

  PhoneNumberInput _phone = const PhoneNumberInput.pure();
  PasswordInput _password = const PasswordInput.pure();
  bool _obscurePassword = true;

  /// Whether to render the legacy-account banner above the form. Flipped to
  /// true when an [AuthLegacyAccountNeedsPhone] state is observed AND the
  /// persisted [PrefKeys.legacyAccountWarningShown] flag is not yet set.
  /// Reset back to false when the user dismisses the banner or taps the CTA.
  bool _showLegacyBanner = false;

  /// Tracks whether we already logged the legacy-user warning during this
  /// page's lifetime. Prevents `Logger().w(...)` spam if the cubit re-emits
  /// `AuthLegacyAccountNeedsPhone` while the banner is suppressed (R2.4).
  bool _legacyWarningLogged = false;

  StreamSubscription<({String phoneNumber, String password})>? _autofillSub;

  /// Whether biometric login is enabled & ready on this device. When true the
  /// page renders the simplified biometric-first layout (phone/password hidden)
  /// so the user can focus on signing in with biometrics. Null while the
  /// initial capability check is still in flight.
  bool? _biometricReady;

  /// When the user taps "Use password instead" on the simplified layout we
  /// reveal the full form for the rest of this page's lifetime.
  bool _passwordFallbackRequested = false;

  /// Whether the standard phone/password form should be visible.
  bool get _showCredentialForm =>
      _biometricReady != true || _passwordFallbackRequested;

  @override
  void initState() {
    super.initState();
    // Listen for autofill events pushed by AuthCubit after a successful
    // biometric restore so the form populates without further interaction
    // (R3.5).
    _autofillSub = context.read<AuthCubit>().autofillStream.listen((creds) {
      _phoneController.text = creds.phoneNumber;
      _passwordController.text = creds.password;
      if (!mounted) return;
      setState(() {
        _phone = PhoneNumberInput.dirty(creds.phoneNumber);
        _password = PasswordInput.dirty(creds.password);
      });
    });
    // Determine whether to show the simplified biometric-only layout. This is
    // a capability check only — it never triggers the OS prompt.
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => _resolveBiometricMode(),
    );
  }

  Future<void> _resolveBiometricMode() async {
    final status = await context.read<AuthCubit>().getBiometricStatus();
    if (!mounted) return;
    setState(() => _biometricReady = status == BiometricStatus.ready);
  }

  @override
  void dispose() {
    _autofillSub?.cancel();
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onPhoneChanged(String value) {
    setState(() => _phone = PhoneNumberInput.dirty(value));
  }

  void _onPasswordChanged(String value) {
    setState(() => _password = PasswordInput.dirty(value));
  }

  bool get _isFormValid => _phone.isValid && _password.isValid;

  void _submit() {
    setState(() {
      _phone = PhoneNumberInput.dirty(_phoneController.text);
      _password = PasswordInput.dirty(_passwordController.text);
    });
    if (_isFormValid) {
      context.read<AuthCubit>().loginWithPhone(
        _phoneController.text.trim(),
        _passwordController.text,
      );
    }
  }

  void _onBiometricPressed() {
    final l10n = AppLocalizations.of(context)!;
    context.read<AuthCubit>().requestBiometricLogin(
      reason: l10n.authBiometricReason,
    );
  }

  /// Maps a known ARB key emitted by [AuthCubit] error states to its
  /// localized string. Falls back to the raw key when unknown so we never
  /// silently lose error context.
  String _localizeError(AppLocalizations l10n, String key) {
    switch (key) {
      case 'authInvalidCredentials':
        return l10n.authInvalidCredentials;
      case 'authBiometricSessionExpired':
        return l10n.authBiometricSessionExpired;
      case 'authBiometricFailed':
        return l10n.authBiometricFailed;
      case 'authBiometricUnavailable':
        return l10n.authBiometricUnavailable;
      case 'authBiometricNotEnabled':
        return l10n.authBiometricNotEnabled;
      case 'authLegacyAccountNeedsPhone':
        return l10n.authLegacyAccountNeedsPhone;
      case 'authPhoneAlreadyTaken':
        return l10n.authPhoneAlreadyTaken;
      default:
        return key;
    }
  }

  String? _phoneErrorText(AppLocalizations l10n) {
    final err = _phone.displayError;
    switch (err) {
      case null:
      case PhoneNumberValidationError.empty:
        return null;
      case PhoneNumberValidationError.invalidFormat:
        return l10n.authPhoneInvalid;
      case PhoneNumberValidationError.alreadyTaken:
        // Not used on the login page.
        return l10n.authPhoneAlreadyTaken;
    }
  }

  void _showSnack(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: AppColors.error),
    );
  }

  /// Handles an [AuthLegacyAccountNeedsPhone] state by either showing the
  /// inline banner (first time per session) or simply emitting a one-shot
  /// `Logger().w(...)` when the persisted flag indicates the user has
  /// already been warned. Validates Requirements 2.4, 14.1, 14.2.
  void _handleLegacyAccount() {
    final prefs = getIt<SharedPreferencesDataSource>();
    final alreadyWarned =
        prefs.getBool(PrefKeys.legacyAccountWarningShown) ?? false;

    if (alreadyWarned) {
      // Already surfaced in a previous session — log once and skip the
      // banner so we don't spam the user.
      if (!_legacyWarningLogged) {
        _legacyWarningLogged = true;
        Logger().w(
          'Legacy account warning suppressed — banner already shown in a '
          'previous session',
        );
      }
      return;
    }

    if (!_legacyWarningLogged) {
      _legacyWarningLogged = true;
      Logger().w('Legacy account detected — surfacing add-phone banner');
    }

    // Persist the flag so subsequent sessions take the suppressed path.
    unawaited(prefs.setBool(PrefKeys.legacyAccountWarningShown, true));

    if (!mounted) return;
    setState(() => _showLegacyBanner = true);
  }

  /// Builds the inline legacy-account banner shown above the login form.
  ///
  /// The banner uses [AppColors.accent] tinted background to read as a
  /// warning without competing with the destructive [AppColors.error] tone.
  /// Actions: navigate to the profile-edit screen (R14.2) or dismiss.
  Widget _buildLegacyBanner(AppLocalizations l10n) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppDimensions.cardGap),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.accent.withValues(alpha: 0.15),
        border: Border.all(color: AppColors.accent),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.info_outline, color: AppColors.accentDark),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  l10n.authLegacyAccountNeedsPhone,
                  style: AppTextStyles.body.copyWith(
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () {
                  setState(() => _showLegacyBanner = false);
                },
                child: Text(l10n.commonCancel),
              ),
              const SizedBox(width: 8),
              TextButton(
                onPressed: () {
                  setState(() => _showLegacyBanner = false);
                  context.go('/profile/edit');
                },
                child: Text(l10n.authLegacyAccountAddPhoneCta),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Builds the simplified, biometric-first sign-in body shown when biometric
  /// login is enabled and ready. The phone/password form is hidden so the user
  /// can focus on the prominent biometric action, with a discreet
  /// "use password instead" fallback that reveals the full form.
  Widget _buildBiometricFocus(AppLocalizations l10n) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: AppDimensions.sectionGap),
        Text(
          l10n.authBiometricSimpleSubtitle,
          textAlign: TextAlign.center,
          style: AppTextStyles.body.copyWith(color: AppColors.textSecondary),
        ),
        const SizedBox(height: AppDimensions.sectionGap),

        // Large, prominent biometric action.
        BlocBuilder<AuthCubit, AuthState>(
          builder: (context, state) {
            final isLoading =
                state is AuthLoading || state is AuthBiometricRestoring;
            return Center(
              child: Semantics(
                label: l10n.authBiometricSemanticLabel,
                button: true,
                child: InkWell(
                  borderRadius: BorderRadius.circular(60),
                  onTap: isLoading ? null : _onBiometricPressed,
                  child: Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.primary.withValues(alpha: 0.12),
                      border: Border.all(color: AppColors.primary, width: 2),
                    ),
                    child: isLoading
                        ? const Padding(
                            padding: EdgeInsets.all(36),
                            child: CircularProgressIndicator(
                              color: AppColors.primary,
                            ),
                          )
                        : const Icon(
                            Icons.fingerprint,
                            size: 64,
                            color: AppColors.primary,
                          ),
                  ),
                ),
              ),
            );
          },
        ),
        const SizedBox(height: AppDimensions.sectionGap),

        // Fallback to the standard phone/password form.
        TextButton(
          onPressed: () {
            setState(() => _passwordFallbackRequested = true);
          },
          child: Text(
            l10n.authUsePasswordInstead,
            style: AppTextStyles.bodySemiBold.copyWith(
              color: AppColors.primary,
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthBiometricUnavailable) {
          _showSnack(l10n.authBiometricUnavailable);
        } else if (state is AuthBiometricNotEnabled) {
          _showSnack(l10n.authBiometricNotEnabled);
        } else if (state is AuthBiometricFailed) {
          _showSnack(_localizeError(l10n, state.message));
        } else if (state is AuthLegacyAccountNeedsPhone) {
          _handleLegacyAccount();
        } else if (state is AuthError) {
          _showSnack(_localizeError(l10n, state.message));
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          backgroundColor: AppColors.background,
          elevation: 0,
          // leading: BackButton(color: AppColors.textPrimary),
          actions: [
            // Language selector
            const LanguageSelectorButton(),
            const SizedBox(width: 8),
          ],
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimensions.screenPaddingH,
              vertical: 16,
            ),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (_showLegacyBanner) _buildLegacyBanner(l10n),

                  // Heading adapts to the active layout: a focused "welcome
                  // back" greeting for biometric-only, the standard login
                  // title otherwise.
                  Text(
                    _showCredentialForm
                        ? l10n.authLoginTitle
                        : l10n.authBiometricSimpleTitle,
                    style: AppTextStyles.displayH1.copyWith(
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: AppDimensions.sectionGap),

                  if (_showCredentialForm) ...[
                    // Phone field
                    TextFormField(
                      controller: _phoneController,
                      keyboardType: TextInputType.phone,
                      textInputAction: TextInputAction.next,
                      onChanged: _onPhoneChanged,
                      decoration: InputDecoration(
                        labelText: l10n.authPhoneLabel,
                        hintText: l10n.authPhoneHint,
                        errorText: _phoneErrorText(l10n),
                      ),
                    ),
                    const SizedBox(height: AppDimensions.cardGap),

                    // Password field
                    TextFormField(
                      controller: _passwordController,
                      obscureText: _obscurePassword,
                      textInputAction: TextInputAction.done,
                      onChanged: _onPasswordChanged,
                      onFieldSubmitted: (_) => _submit(),
                      decoration: InputDecoration(
                        labelText: l10n.authLoginPasswordHint,
                        errorText: _password.displayError != null
                            ? l10n.authLoginPasswordError
                            : null,
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassword
                                ? Icons.visibility_off
                                : Icons.visibility,
                          ),
                          onPressed: () {
                            setState(
                              () => _obscurePassword = !_obscurePassword,
                            );
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),

                    // Forgot password
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () => context.push('/forgot-password'),
                        child: Text(
                          l10n.authLoginForgotPassword,
                          style: AppTextStyles.body.copyWith(
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: AppDimensions.cardGap),

                    // Log In button
                    BlocBuilder<AuthCubit, AuthState>(
                      builder: (context, state) {
                        final isLoading =
                            state is AuthLoading ||
                            state is AuthBiometricRestoring;
                        return AppPrimaryButton(
                          label: l10n.authLoginButton,
                          isLoading: isLoading,
                          onPressed: isLoading ? null : _submit,
                        );
                      },
                    ),
                    const SizedBox(height: AppDimensions.cardGap),

                    // Biometric sign-in button (compact icon in full layout)
                    Center(
                      child: Semantics(
                        label: l10n.authBiometricSemanticLabel,
                        button: true,
                        child: SizedBox(
                          width: 56,
                          height: 56,
                          child: IconButton(
                            iconSize: 32,
                            tooltip: l10n.authBiometricSemanticLabel,
                            icon: const Icon(Icons.fingerprint),
                            color: AppColors.primary,
                            onPressed: _onBiometricPressed,
                          ),
                        ),
                      ),
                    ),
                  ] else
                    _buildBiometricFocus(l10n),

                  const SizedBox(height: AppDimensions.cardGap),

                  // Register link
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        l10n.authLoginNoAccount,
                        style: AppTextStyles.body.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                      TextButton(
                        onPressed: () => context.push('/register'),
                        child: Text(
                          l10n.authLoginRegisterLink,
                          style: AppTextStyles.bodySemiBold.copyWith(
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

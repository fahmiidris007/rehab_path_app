import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_dimensions.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../../core/widgets/app_primary_button.dart';
import '../../../../l10n/app_localizations.dart';
import '../../domain/validators/confirm_password_input.dart';
import '../../domain/validators/name_input.dart';
import '../../domain/validators/password_input.dart';
import '../../domain/validators/phone_input.dart';
import '../cubit/auth_cubit.dart';
import '../cubit/auth_state.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  NameInput _name = const NameInput.pure();
  PhoneNumberInput _phone = const PhoneNumberInput.pure();
  PasswordInput _password = const PasswordInput.pure();
  ConfirmPasswordInput _confirmPassword = const ConfirmPasswordInput.pure();

  /// Server-side error for the phone field surfaced through `AuthCubit`
  /// (e.g. duplicate phone). Reset on every keystroke in the phone field
  /// and overrides any inline `formz` validation error when set.
  String? _phoneServerError;

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _onNameChanged(String value) {
    setState(() => _name = NameInput.dirty(value));
  }

  void _onPhoneChanged(String value) {
    setState(() {
      _phone = PhoneNumberInput.dirty(value);
      // User edited the field — drop any stale server-side error.
      _phoneServerError = null;
    });
  }

  void _onPasswordChanged(String value) {
    setState(() {
      _password = PasswordInput.dirty(value);
      _confirmPassword = ConfirmPasswordInput.dirty(
        password: value,
        value: _confirmPasswordController.text,
      );
    });
  }

  void _onConfirmPasswordChanged(String value) {
    setState(() {
      _confirmPassword = ConfirmPasswordInput.dirty(
        password: _passwordController.text,
        value: value,
      );
    });
  }

  bool get _isFormValid =>
      _name.isValid &&
      _phone.isValid &&
      _password.isValid &&
      _confirmPassword.isValid;

  String? _phoneErrorText(AppLocalizations l10n) {
    if (_phoneServerError != null) return _phoneServerError;
    final error = _phone.displayError;
    if (error == null) return null;
    switch (error) {
      case PhoneNumberValidationError.empty:
        return null;
      case PhoneNumberValidationError.invalidFormat:
        return l10n.authPhoneInvalid;
      case PhoneNumberValidationError.alreadyTaken:
        return l10n.authPhoneAlreadyTaken;
    }
  }

  void _submit() {
    setState(() {
      _name = NameInput.dirty(_nameController.text);
      _phone = PhoneNumberInput.dirty(_phoneController.text);
      _password = PasswordInput.dirty(_passwordController.text);
      _confirmPassword = ConfirmPasswordInput.dirty(
        password: _passwordController.text,
        value: _confirmPasswordController.text,
      );
      _phoneServerError = null;
    });
    if (_isFormValid) {
      context.read<AuthCubit>().registerWithPhone(
            _nameController.text.trim(),
            _phoneController.text.trim(),
            _passwordController.text,
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthRegistrationSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(l10n.authRegisterSuccessMessage),
              backgroundColor: const Color(0xFF00609B),
            ),
          );
          context.go('/login');
        } else if (state is AuthError) {
          // Duplicate phone is signalled by the repo with the localized key
          // `authPhoneAlreadyTaken`; surface it inline rather than as a
          // SnackBar so the affected field is obvious to the user.
          if (state.message == 'authPhoneAlreadyTaken') {
            setState(() {
              _phoneServerError = l10n.authPhoneAlreadyTaken;
            });
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: AppColors.error,
              ),
            );
          }
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          backgroundColor: AppColors.background,
          elevation: 0,
          leading: BackButton(color: AppColors.textPrimary),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimensions.screenPaddingH,
              vertical: 16,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  l10n.authRegisterTitle,
                  style: AppTextStyles.displayH1.copyWith(
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: AppDimensions.sectionGap),

                // Name field
                TextFormField(
                  controller: _nameController,
                  keyboardType: TextInputType.name,
                  textInputAction: TextInputAction.next,
                  textCapitalization: TextCapitalization.words,
                  onChanged: _onNameChanged,
                  decoration: InputDecoration(
                    labelText: l10n.authRegisterNameHint,
                    errorText: _name.displayError != null
                        ? l10n.authRegisterNameError
                        : null,
                  ),
                ),
                const SizedBox(height: AppDimensions.cardGap),

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
                  textInputAction: TextInputAction.next,
                  onChanged: _onPasswordChanged,
                  decoration: InputDecoration(
                    labelText: l10n.authRegisterPasswordHint,
                    errorText: _password.displayError != null
                        ? l10n.authRegisterPasswordError
                        : null,
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword
                            ? Icons.visibility_off
                            : Icons.visibility,
                      ),
                      onPressed: () {
                        setState(() => _obscurePassword = !_obscurePassword);
                      },
                    ),
                  ),
                ),
                const SizedBox(height: AppDimensions.cardGap),

                // Confirm Password field
                TextFormField(
                  controller: _confirmPasswordController,
                  obscureText: _obscureConfirmPassword,
                  textInputAction: TextInputAction.done,
                  onChanged: _onConfirmPasswordChanged,
                  onFieldSubmitted: (_) => _submit(),
                  decoration: InputDecoration(
                    labelText: l10n.authRegisterConfirmPasswordHint,
                    errorText: _confirmPassword.displayError != null
                        ? l10n.authRegisterConfirmPasswordError
                        : null,
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscureConfirmPassword
                            ? Icons.visibility_off
                            : Icons.visibility,
                      ),
                      onPressed: () {
                        setState(
                          () => _obscureConfirmPassword =
                              !_obscureConfirmPassword,
                        );
                      },
                    ),
                  ),
                ),
                const SizedBox(height: AppDimensions.sectionGap),

                // Create Account button
                BlocBuilder<AuthCubit, AuthState>(
                  builder: (context, state) {
                    final isLoading = state is AuthLoading;
                    return AppPrimaryButton(
                      label: l10n.authRegisterButton,
                      isLoading: isLoading,
                      onPressed: isLoading ? null : _submit,
                    );
                  },
                ),
                const SizedBox(height: AppDimensions.cardGap),

                // Log In link
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      l10n.authRegisterHaveAccount,
                      style: AppTextStyles.body.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                    TextButton(
                      onPressed: () => context.push('/login'),
                      child: Text(
                        l10n.authRegisterLoginLink,
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
    );
  }
}

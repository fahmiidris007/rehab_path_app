import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_dimensions.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../../core/widgets/app_primary_button.dart';
import '../../../../core/widgets/language_selector_button.dart';
import '../../../../l10n/app_localizations.dart';
import '../../domain/validators/email_input.dart';
import '../../domain/validators/password_input.dart';
import '../cubit/auth_cubit.dart';
import '../cubit/auth_state.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  EmailInput _email = const EmailInput.pure();
  PasswordInput _password = const PasswordInput.pure();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onEmailChanged(String value) {
    setState(() => _email = EmailInput.dirty(value));
  }

  void _onPasswordChanged(String value) {
    setState(() => _password = PasswordInput.dirty(value));
  }

  bool get _isFormValid => _email.isValid && _password.isValid;

  void _submit() {
    setState(() {
      _email = EmailInput.dirty(_emailController.text);
      _password = PasswordInput.dirty(_passwordController.text);
    });
    if (_isFormValid) {
      context.read<AuthCubit>().login(
            _emailController.text.trim(),
            _passwordController.text,
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: AppColors.error,
            ),
          );
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          backgroundColor: AppColors.background,
          elevation: 0,
          leading: BackButton(color: AppColors.textPrimary),
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
                  Text(
                    l10n.authLoginTitle,
                    style: AppTextStyles.displayH1.copyWith(
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: AppDimensions.sectionGap),

                  // Email field
                  TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    onChanged: _onEmailChanged,
                    decoration: InputDecoration(
                      labelText: l10n.authLoginEmailHint,
                      errorText: _email.displayError != null
                          ? l10n.authLoginEmailError
                          : null,
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
                          setState(() => _obscurePassword = !_obscurePassword);
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
                      final isLoading = state is AuthLoading;
                      return AppPrimaryButton(
                        label: l10n.authLoginButton,
                        isLoading: isLoading,
                        onPressed: isLoading ? null : _submit,
                      );
                    },
                  ),
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

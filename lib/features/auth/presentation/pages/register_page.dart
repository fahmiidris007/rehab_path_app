import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_dimensions.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../../core/widgets/app_primary_button.dart';
import '../../domain/validators/confirm_password_input.dart';
import '../../domain/validators/email_input.dart';
import '../../domain/validators/name_input.dart';
import '../../domain/validators/password_input.dart';
import '../cubit/auth_cubit.dart';
import '../cubit/auth_state.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  NameInput _name = const NameInput.pure();
  EmailInput _email = const EmailInput.pure();
  PasswordInput _password = const PasswordInput.pure();
  ConfirmPasswordInput _confirmPassword = const ConfirmPasswordInput.pure();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _onNameChanged(String value) {
    setState(() => _name = NameInput.dirty(value));
  }

  void _onEmailChanged(String value) {
    setState(() => _email = EmailInput.dirty(value));
  }

  void _onPasswordChanged(String value) {
    setState(() {
      _password = PasswordInput.dirty(value);
      // Re-validate confirm password when password changes
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
      _email.isValid &&
      _password.isValid &&
      _confirmPassword.isValid;

  void _submit() {
    setState(() {
      _name = NameInput.dirty(_nameController.text);
      _email = EmailInput.dirty(_emailController.text);
      _password = PasswordInput.dirty(_passwordController.text);
      _confirmPassword = ConfirmPasswordInput.dirty(
        password: _passwordController.text,
        value: _confirmPasswordController.text,
      );
    });
    if (_isFormValid) {
      context.read<AuthCubit>().register(
            _nameController.text.trim(),
            _emailController.text.trim(),
            _passwordController.text,
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthRegistrationSuccess) {
          // Account created — redirect to login with a success message.
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Account created! Please log in to continue.'),
              backgroundColor: Color(0xFF00609B),
            ),
          );
          context.go('/login');
        } else if (state is AuthError) {
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
                  'Create Account',
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
                    labelText: 'Full Name',
                    errorText: _name.displayError != null
                        ? 'Name must be 1–50 characters'
                        : null,
                  ),
                ),
                const SizedBox(height: AppDimensions.cardGap),

                // Email field
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  onChanged: _onEmailChanged,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    errorText: _email.displayError != null
                        ? 'Please enter a valid email address'
                        : null,
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
                    labelText: 'Password',
                    errorText: _password.displayError != null
                        ? 'Password must be 8–64 characters'
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
                    labelText: 'Confirm Password',
                    errorText: _confirmPassword.displayError != null
                        ? 'Passwords do not match'
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
                      label: 'Create Account',
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
                      'Already have an account?',
                      style: AppTextStyles.body.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                    TextButton(
                      onPressed: () => context.push('/login'),
                      child: Text(
                        'Log In',
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

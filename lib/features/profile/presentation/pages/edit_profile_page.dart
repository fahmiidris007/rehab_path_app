import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_dimensions.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/widgets/app_loading_widget.dart';
import '../../../../core/widgets/app_primary_button.dart';
import '../../../../core/widgets/app_top_app_bar.dart';
import '../../../../di/injection.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../auth/domain/usecases/upsert_phone_number_use_case.dart';
import '../../../auth/domain/validators/phone_input.dart';
import '../../../auth/presentation/cubit/auth_cubit.dart';
import '../../../auth/presentation/cubit/auth_state.dart';
import '../cubit/profile_cubit.dart';

/// Edit profile page.
class EditProfilePage extends StatelessWidget {
  const EditProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final authState = context.read<AuthCubit>().state;
    final userId =
        authState is AuthAuthenticated ? authState.user.id : '';

    return BlocProvider<ProfileCubit>(
      create: (_) => getIt<ProfileCubit>()..loadProfile(userId),
      child: const _EditProfileView(),
    );
  }
}

class _EditProfileView extends StatefulWidget {
  const _EditProfileView();

  @override
  State<_EditProfileView> createState() => _EditProfileViewState();
}

class _EditProfileViewState extends State<_EditProfileView> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController? _nameController;
  TextEditingController? _phoneController;
  bool _isSaving = false;
  bool _initialized = false;

  /// Phone validation state. We use [PhoneNumberInput] to mirror the
  /// register / login flow so error mapping stays consistent.
  PhoneNumberInput _phone = const PhoneNumberInput.pure();

  /// Set to [PhoneNumberValidationError.alreadyTaken] when the
  /// repository rejects the upsert because another user owns the phone.
  PhoneNumberValidationError? _phoneServerError;

  @override
  void dispose() {
    _nameController?.dispose();
    _phoneController?.dispose();
    super.dispose();
  }

  void _initControllers(String currentName, String currentPhone) {
    if (!_initialized) {
      _nameController = TextEditingController(text: currentName);
      _phoneController = TextEditingController(text: currentPhone);
      _phone = PhoneNumberInput.dirty(currentPhone);
      _initialized = true;
    }
  }

  void _onPhoneChanged(String value) {
    setState(() {
      _phone = PhoneNumberInput.dirty(value);
      _phoneServerError = null;
    });
  }

  String? _phoneErrorText(AppLocalizations l10n) {
    if (_phoneServerError == PhoneNumberValidationError.alreadyTaken) {
      return l10n.authPhoneAlreadyTaken;
    }
    final err = _phone.displayError;
    switch (err) {
      case null:
      case PhoneNumberValidationError.empty:
        // Empty is allowed only if the field has not been touched. The form
        // validator below enforces non-empty on submit when the user wants
        // to save a phone change.
        return null;
      case PhoneNumberValidationError.invalidFormat:
        return l10n.authPhoneInvalid;
      case PhoneNumberValidationError.alreadyTaken:
        return l10n.authPhoneAlreadyTaken;
    }
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    final cubit = context.read<ProfileCubit>();
    final state = cubit.state;
    if (state is! ProfileLoaded) return;

    final l10n = AppLocalizations.of(context)!;
    final messenger = ScaffoldMessenger.of(context);

    final newName = _nameController!.text.trim();
    final newPhone = _phoneController!.text.trim();
    final currentPhone = state.user.phoneNumber;

    final phoneChanged = newPhone != currentPhone;
    final nameChanged = newName != state.user.name;

    // Force phone validation on submit. An empty phone never passes here —
    // the upsert use case requires a valid E.164 number.
    if (phoneChanged) {
      setState(() {
        _phone = PhoneNumberInput.dirty(newPhone);
        _phoneServerError = null;
      });
      if (!_phone.isValid) {
        return;
      }
    }

    setState(() => _isSaving = true);

    var phoneSucceeded = true;
    if (phoneChanged) {
      final upsertUseCase = getIt<UpsertPhoneNumberUseCase>();
      final result = await upsertUseCase(
        UpsertPhoneNumberParams(
          userId: state.user.id,
          phoneNumber: newPhone,
        ),
      );

      if (!mounted) return;

      phoneSucceeded = result.fold(
        (failure) {
          if (failure is ValidationFailure && failure.field == 'phoneNumber') {
            switch (failure.message) {
              case 'authPhoneAlreadyTaken':
                setState(() {
                  _phoneServerError = PhoneNumberValidationError.alreadyTaken;
                });
                break;
              case 'authPhoneInvalid':
                setState(() {
                  _phone = PhoneNumberInput.dirty(newPhone);
                  _phoneServerError = null;
                });
                break;
              default:
                messenger.showSnackBar(
                  SnackBar(
                    content: Text(
                      l10n.editProfileFailedToUpdate,
                      style: AppTextStyles.body
                          .copyWith(color: Colors.white),
                    ),
                    backgroundColor: AppColors.error,
                  ),
                );
            }
          } else {
            messenger.showSnackBar(
              SnackBar(
                content: Text(
                  l10n.editProfileFailedToUpdate,
                  style: AppTextStyles.body
                      .copyWith(color: Colors.white),
                ),
                backgroundColor: AppColors.error,
              ),
            );
          }
          return false;
        },
        (_) => true,
      );

      if (!phoneSucceeded) {
        if (mounted) setState(() => _isSaving = false);
        return;
      }
    }

    // Persist name (and any other profile-level edits) via the existing
    // ProfileCubit pipeline. The phone field is owned by the auth/Hive
    // user record and is updated above; we reflect it here to keep the
    // entity in sync for the rest of the session.
    var nameSucceeded = true;
    if (nameChanged || phoneChanged) {
      final updatedUser = state.user.copyWith(
        name: newName,
        phoneNumber: phoneChanged ? newPhone : currentPhone,
      );
      nameSucceeded = await cubit.updateProfile(updatedUser);
    }

    if (!mounted) return;
    setState(() => _isSaving = false);

    if (!nameSucceeded) {
      messenger.showSnackBar(
        SnackBar(
          content: Text(
            l10n.editProfileFailedToUpdate,
            style: AppTextStyles.body.copyWith(color: Colors.white),
          ),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    if (phoneChanged) {
      messenger.showSnackBar(
        SnackBar(
          content: Text(
            l10n.editProfilePhoneUpdated,
            style: AppTextStyles.body.copyWith(color: Colors.white),
          ),
          backgroundColor: AppColors.success,
        ),
      );
    }

    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return BlocBuilder<ProfileCubit, ProfileState>(
      builder: (context, state) {
        if (state is ProfileLoading) {
          return const Scaffold(body: AppLoadingWidget());
        }

        if (state is ProfileError) {
          return Scaffold(
            appBar: AppTopAppBar(title: l10n.editProfileTitle),
            body: Center(
              child: Text(
                state.message,
                style: AppTextStyles.body
                    .copyWith(color: AppColors.textSecondary),
              ),
            ),
          );
        }

        final loaded = state as ProfileLoaded;
        _initControllers(loaded.user.name, loaded.user.phoneNumber);

        return Scaffold(
          appBar: AppTopAppBar(title: l10n.editProfileTitle),
          body: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(
              horizontal: AppDimensions.screenPaddingH,
              vertical: AppDimensions.sectionGap,
            ),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    l10n.editProfileFullName,
                    style: AppTextStyles.bodySemiBold.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _nameController,
                    textCapitalization: TextCapitalization.words,
                    style: AppTextStyles.body.copyWith(
                      color: AppColors.textPrimary,
                    ),
                    decoration: _fieldDecoration(
                      hintText: l10n.editProfileNameHint,
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return l10n.editProfileNameEmpty;
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: AppDimensions.sectionGap),
                  Text(
                    l10n.authPhoneLabel,
                    style: AppTextStyles.bodySemiBold.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _phoneController,
                    keyboardType: TextInputType.phone,
                    onChanged: _onPhoneChanged,
                    style: AppTextStyles.body.copyWith(
                      color: AppColors.textPrimary,
                    ),
                    decoration: _fieldDecoration(
                      labelText: l10n.authPhoneLabel,
                      hintText: l10n.authPhoneHint,
                      errorText: _phoneErrorText(l10n),
                    ),
                  ),
                  const SizedBox(height: AppDimensions.sectionGap),
                  AppPrimaryButton(
                    label: l10n.editProfileSave,
                    onPressed: _isSaving ? null : _save,
                    isLoading: _isSaving,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  InputDecoration _fieldDecoration({
    String? labelText,
    String? hintText,
    String? errorText,
  }) {
    return InputDecoration(
      labelText: labelText,
      hintText: hintText,
      errorText: errorText,
      hintStyle: AppTextStyles.body.copyWith(
        color: AppColors.textDisabled,
      ),
      filled: true,
      fillColor: AppColors.surfaceWhite,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 14,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppDimensions.radiusCard),
        borderSide: const BorderSide(color: AppColors.border),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppDimensions.radiusCard),
        borderSide: const BorderSide(color: AppColors.border),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppDimensions.radiusCard),
        borderSide: const BorderSide(
          color: AppColors.primary,
          width: 2,
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppDimensions.radiusCard),
        borderSide: const BorderSide(color: AppColors.error),
      ),
    );
  }
}

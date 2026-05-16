import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_dimensions.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../../core/widgets/app_loading_widget.dart';
import '../../../../core/widgets/app_primary_button.dart';
import '../../../../core/widgets/app_top_app_bar.dart';
import '../../../../di/injection.dart';
import '../../../../l10n/app_localizations.dart';
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
  bool _isSaving = false;
  bool _initialized = false;

  @override
  void dispose() {
    _nameController?.dispose();
    super.dispose();
  }

  void _initController(String currentName) {
    if (!_initialized) {
      _nameController = TextEditingController(text: currentName);
      _initialized = true;
    }
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    final cubit = context.read<ProfileCubit>();
    final state = cubit.state;
    if (state is! ProfileLoaded) return;

    setState(() => _isSaving = true);

    final updatedUser =
        state.user.copyWith(name: _nameController!.text.trim());
    final success = await cubit.updateProfile(updatedUser);

    if (!mounted) return;
    setState(() => _isSaving = false);

    if (success) {
      context.pop();
    } else {
      final l10n = AppLocalizations.of(context)!;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            l10n.editProfileFailedToUpdate,
            style: AppTextStyles.body.copyWith(color: Colors.white),
          ),
          backgroundColor: AppColors.error,
        ),
      );
    }
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
        _initController(loaded.user.name);

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
                    decoration: InputDecoration(
                      hintText: l10n.editProfileNameHint,
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
                        borderRadius:
                            BorderRadius.circular(AppDimensions.radiusCard),
                        borderSide:
                            const BorderSide(color: AppColors.border),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius:
                            BorderRadius.circular(AppDimensions.radiusCard),
                        borderSide:
                            const BorderSide(color: AppColors.border),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius:
                            BorderRadius.circular(AppDimensions.radiusCard),
                        borderSide: const BorderSide(
                          color: AppColors.primary,
                          width: 2,
                        ),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderRadius:
                            BorderRadius.circular(AppDimensions.radiusCard),
                        borderSide:
                            const BorderSide(color: AppColors.error),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return l10n.editProfileNameEmpty;
                      }
                      return null;
                    },
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
}

/// Edit profile page.
///
/// Provides its own [ProfileCubit] so it can be pushed as a standalone route
/// without depending on a parent [ProfileCubit] in the widget tree.

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_dimensions.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../../core/widgets/app_primary_button.dart';
import '../../../../di/injection.dart';
import '../../../../features/auth/presentation/cubit/auth_cubit.dart';
import '../../../../features/auth/presentation/cubit/auth_state.dart';
import '../../../../shared/domain/entities/exercise_entity.dart';
import '../../../../shared/domain/enums/app_enums.dart';
import '../cubit/exercise_player_cubit.dart';

/// Modal bottom sheet that collects a self-report after completing an exercise.
///
/// Presents:
/// - "How did it go?" title
/// - [BodyCondition] radio group (Sitting / Standing)
/// - [SupportUsed] radio group (Walking aid / Kitchen worktop / No support)
/// - A "Submit" [AppPrimaryButton]
///
/// On submit, calls [ExercisePlayerCubit.submitSelfReport].
class SelfReportBottomSheet extends StatefulWidget {
  const SelfReportBottomSheet({
    super.key,
    required this.exercise,
  });

  final ExerciseEntity exercise;

  /// Convenience helper to show the sheet as a modal bottom sheet.
  static Future<void> show(
    BuildContext context, {
    required ExerciseEntity exercise,
  }) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.surfaceWhite,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppDimensions.radiusCard),
        ),
      ),
      // Pass the cubit down so the sheet can call submitSelfReport.
      builder: (_) => BlocProvider.value(
        value: context.read<ExercisePlayerCubit>(),
        child: SelfReportBottomSheet(exercise: exercise),
      ),
    );
  }

  @override
  State<SelfReportBottomSheet> createState() => _SelfReportBottomSheetState();
}

class _SelfReportBottomSheetState extends State<SelfReportBottomSheet> {
  BodyCondition _bodyCondition = BodyCondition.standing;
  SupportUsed _supportUsed = SupportUsed.noSupport;

  void _submit() {
    final authState = getIt<AuthCubit>().state;
    final userId = switch (authState) {
      AuthAuthenticated(:final user) => user.id,
      _ => 'guest',
    };

    context.read<ExercisePlayerCubit>().submitSelfReport(
          userId: userId,
          exercise: widget.exercise,
          bodyCondition: _bodyCondition,
          supportUsed: _supportUsed,
        );

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Padding(
      padding: EdgeInsets.fromLTRB(
        AppDimensions.screenPaddingH,
        24,
        AppDimensions.screenPaddingH,
        24 + bottomInset,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Drag handle
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.neutralGray,
                borderRadius: BorderRadius.circular(AppDimensions.radiusPill),
              ),
            ),
          ),
          const SizedBox(height: 20),
          // Title
          Text(
            'How did it go?',
            style: AppTextStyles.h3Section.copyWith(
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 24),
          // Body condition
          Text(
            'Body position',
            style: AppTextStyles.bodySemiBold.copyWith(
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          _RadioGroup<BodyCondition>(
            value: _bodyCondition,
            options: const [
              (BodyCondition.sitting, 'Sitting'),
              (BodyCondition.standing, 'Standing'),
            ],
            onChanged: (v) => setState(() => _bodyCondition = v),
          ),
          const SizedBox(height: 20),
          // Support used
          Text(
            'Support used',
            style: AppTextStyles.bodySemiBold.copyWith(
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          _RadioGroup<SupportUsed>(
            value: _supportUsed,
            options: const [
              (SupportUsed.walkingAid, 'Walking aid'),
              (SupportUsed.kitchenWorktop, 'Kitchen worktop'),
              (SupportUsed.noSupport, 'No support'),
            ],
            onChanged: (v) => setState(() => _supportUsed = v),
          ),
          const SizedBox(height: 28),
          // Submit button
          AppPrimaryButton(
            label: 'Submit',
            onPressed: _submit,
          ),
        ],
      ),
    );
  }
}

// ── Generic radio group ───────────────────────────────────────────────────────

class _RadioGroup<T> extends StatelessWidget {
  const _RadioGroup({
    required this.value,
    required this.options,
    required this.onChanged,
  });

  final T value;
  final List<(T, String)> options;
  final ValueChanged<T> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: options.map((option) {
        final (optionValue, label) = option;
        final isSelected = value == optionValue;
        return InkWell(
          onTap: () => onChanged(optionValue),
          borderRadius: BorderRadius.circular(AppDimensions.radiusCard),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Row(
              children: [
                SizedBox(
                  width: AppDimensions.minTouchTarget,
                  height: AppDimensions.minTouchTarget,
                  child: Center(
                    child: Container(
                      width: 22,
                      height: 22,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: isSelected
                              ? AppColors.primary
                              : AppColors.border,
                          width: 2,
                        ),
                      ),
                      child: isSelected
                          ? Center(
                              child: Container(
                                width: 12,
                                height: 12,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: AppColors.primary,
                                ),
                              ),
                            )
                          : null,
                    ),
                  ),
                ),
                const SizedBox(width: 4),
                Text(
                  label,
                  style: AppTextStyles.body.copyWith(
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}

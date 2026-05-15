import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_dimensions.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../shared/domain/entities/emergency_contact_entity.dart';
import '../cubit/sos_cubit.dart';

/// A card displaying an emergency contact's name, relationship, and phone
/// number. Tapping the phone number triggers a call via [SosCubit.callContact].
class EmergencyContactCard extends StatelessWidget {
  const EmergencyContactCard({
    super.key,
    required this.contact,
  });

  final EmergencyContactEntity contact;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: const EdgeInsets.all(AppDimensions.cardInnerPadding),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  contact.name,
                  style: AppTextStyles.bodySemiBold.copyWith(
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  contact.relationship,
                  style: AppTextStyles.body.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          // Phone number — tappable with min 56dp touch target
          GestureDetector(
            onTap: () =>
                context.read<SosCubit>().callContact(contact.phoneNumber),
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                minWidth: AppDimensions.recTouchTarget,
                minHeight: AppDimensions.recTouchTarget,
              ),
              child: Align(
                alignment: Alignment.centerRight,
                child: Text(
                  contact.phoneNumber,
                  style: AppTextStyles.body.copyWith(
                    color: AppColors.primary,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

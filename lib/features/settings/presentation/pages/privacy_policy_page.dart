import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_dimensions.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../../core/widgets/app_top_app_bar.dart';
import '../../../../l10n/app_localizations.dart';

class PrivacyPolicyPage extends StatelessWidget {
  const PrivacyPolicyPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppTopAppBar(title: l10n.settingsPrivacyPolicy),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.screenPaddingH,
          vertical: AppDimensions.sectionGap,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Privacy Policy',
              style: AppTextStyles.displayH1.copyWith(
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Last updated: January 2025',
              style: AppTextStyles.body.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 24),
            _Section(
              title: '1. Information We Collect',
              body:
                  'We collect information you provide directly to us, such as when you create an account, '
                  'complete your health profile, or contact us for support. This includes your name, email address, '
                  'age, health conditions, and exercise activity data.',
            ),
            _Section(
              title: '2. How We Use Your Information',
              body:
                  'We use the information we collect to provide, maintain, and improve our services, '
                  'personalise your rehabilitation program, send you reminders and notifications, '
                  'and communicate with you about your progress.',
            ),
            _Section(
              title: '3. Data Security',
              body:
                  'We take reasonable measures to help protect information about you from loss, theft, '
                  'misuse, and unauthorised access, disclosure, alteration, and destruction. '
                  'Your health data is encrypted at rest and in transit.',
            ),
            _Section(
              title: '4. Data Sharing',
              body:
                  'We do not sell, trade, or otherwise transfer your personally identifiable information '
                  'to outside parties without your consent, except as required by law or to provide our services.',
            ),
            _Section(
              title: '5. Your Rights',
              body:
                  'You have the right to access, correct, or delete your personal data at any time. '
                  'You may also request a copy of your data or withdraw consent for data processing '
                  'by contacting our support team.',
            ),
            _Section(
              title: '6. Contact Us',
              body:
                  'If you have any questions about this Privacy Policy, please contact us at '
                  'privacy@rehabpath.app.',
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}

class _Section extends StatelessWidget {
  const _Section({required this.title, required this.body});

  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppTextStyles.bodySemiBold.copyWith(
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            body,
            style: AppTextStyles.body.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

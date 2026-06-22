import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_dimensions.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../../core/widgets/app_top_app_bar.dart';
import '../../../../l10n/app_localizations.dart';

class TermsOfServicePage extends StatelessWidget {
  const TermsOfServicePage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppTopAppBar(title: l10n.settingsTermsOfService),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.screenPaddingH,
          vertical: AppDimensions.sectionGap,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Terms of Service',
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
              title: '1. Acceptance of Terms',
              body:
                  'By accessing or using the Laman Lansia application, you agree to be bound by these Terms of Service. '
                  'If you do not agree to these terms, please do not use our application.',
            ),
            _Section(
              title: '2. Medical Disclaimer',
              body:
                  'Laman Lansia is designed to support rehabilitation exercises and is not a substitute for '
                  'professional medical advice, diagnosis, or treatment. Always seek the advice of your '
                  'physician or other qualified health provider with any questions you may have regarding '
                  'a medical condition.',
            ),
            _Section(
              title: '3. User Responsibilities',
              body:
                  'You are responsible for maintaining the confidentiality of your account credentials '
                  'and for all activities that occur under your account. You agree to provide accurate '
                  'and complete information when creating your profile.',
            ),
            _Section(
              title: '4. Prohibited Activities',
              body:
                  'You may not use the application for any unlawful purpose, to transmit harmful content, '
                  'to attempt to gain unauthorised access to our systems, or to interfere with the '
                  'proper functioning of the application.',
            ),
            _Section(
              title: '5. Intellectual Property',
              body:
                  'All content, features, and functionality of the Laman Lansia application are owned by '
                  'Laman Lansia and are protected by applicable intellectual property laws. '
                  'You may not reproduce, distribute, or create derivative works without our express permission.',
            ),
            _Section(
              title: '6. Limitation of Liability',
              body:
                  'To the maximum extent permitted by law, Laman Lansia shall not be liable for any indirect, '
                  'incidental, special, consequential, or punitive damages arising from your use of the application.',
            ),
            _Section(
              title: '7. Changes to Terms',
              body:
                  'We reserve the right to modify these terms at any time. We will notify you of significant '
                  'changes via the application or by email. Your continued use of the application after '
                  'such changes constitutes your acceptance of the new terms.',
            ),
            _Section(
              title: '8. Contact Us',
              body:
                  'If you have any questions about these Terms of Service, please contact us at '
                  'legal@lamanlansia.app.',
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
            style: AppTextStyles.body.copyWith(color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }
}

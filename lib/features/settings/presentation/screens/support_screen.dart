import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_typography.dart';
import '../../../../core/constants/app_spacing.dart';

class SupportScreen extends StatelessWidget {
  const SupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Help & Support'),
        backgroundColor: AppColors.surface,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
      ),
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.screenPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionHeader('Frequently Asked Questions'),
              const SizedBox(height: AppSpacing.md),
              _buildFAQItem(
                'How do I create an account?',
                'You can create an account by tapping the "Sign Up" button on the login screen and following the registration process.',
              ),
              _buildFAQItem(
                'How do I reset my password?',
                'On the login screen, tap "Forgot Password" and enter your email address. You\'ll receive a password reset link.',
              ),
              _buildFAQItem(
                'How do I change my profile picture?',
                'Go to your profile, tap on your profile picture, and select "Change Photo" to upload a new image.',
              ),
              _buildFAQItem(
                'How do I report inappropriate content?',
                'Long press on any message or content and select "Report" from the options menu.',
              ),
              const SizedBox(height: AppSpacing.xl),
              
              _buildSectionHeader('Contact Support'),
              const SizedBox(height: AppSpacing.md),
              _buildContactItem(
                Icons.email_outlined,
                'Email Support',
                'support@app.com',
                'Send us an email for detailed inquiries',
              ),
              _buildContactItem(
                Icons.chat_bubble_outline,
                'Live Chat',
                'Available 24/7',
                'Chat with our support team instantly',
              ),
              _buildContactItem(
                Icons.phone_outlined,
                'Phone Support',
                '+1 (555) 123-4567',
                'Call us for urgent matters',
              ),
              const SizedBox(height: AppSpacing.xl),
              
              _buildSectionHeader('Resources'),
              const SizedBox(height: AppSpacing.md),
              _buildResourceItem(
                Icons.book_outlined,
                'User Guide',
                'Learn how to use all app features',
              ),
              _buildResourceItem(
                Icons.security_outlined,
                'Privacy Policy',
                'Understand how we protect your data',
              ),
              _buildResourceItem(
                Icons.description_outlined,
                'Terms of Service',
                'Review our terms and conditions',
              ),
              _buildResourceItem(
                Icons.feedback_outlined,
                'Send Feedback',
                'Help us improve the app',
              ),
              const SizedBox(height: AppSpacing.xl),
              
              _buildSectionHeader('App Information'),
              const SizedBox(height: AppSpacing.md),
              _buildInfoItem('Version', '1.0.0'),
              _buildInfoItem('Build', '100'),
              _buildInfoItem('Platform', 'Flutter'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: AppTypography.headlineLarge.copyWith(
        color: AppColors.textPrimary,
        fontSize: 24,
      ),
    );
  }

  Widget _buildFAQItem(String question, String answer) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      child: ExpansionTile(
        title: Text(
          question,
          style: AppTypography.titleLarge.copyWith(
            color: AppColors.textPrimary,
            fontSize: 16,
          ),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Text(
              answer,
              style: AppTypography.bodyLarge.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactItem(IconData icon, String title, String subtitle, String description) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.divider, width: 1),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(AppSpacing.sm),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              color: AppColors.primary,
              size: 24,
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTypography.titleLarge.copyWith(
                    color: AppColors.textPrimary,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  subtitle,
                  style: AppTypography.labelLarge.copyWith(
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  description,
                  style: AppTypography.bodyLarge.copyWith(
                    color: AppColors.textSecondary,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResourceItem(IconData icon, String title, String description) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(AppSpacing.sm),
          decoration: BoxDecoration(
            color: AppColors.secondary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            color: AppColors.secondary,
            size: 20,
          ),
        ),
        title: Text(
          title,
          style: AppTypography.titleLarge.copyWith(
            color: AppColors.textPrimary,
            fontSize: 16,
          ),
        ),
        subtitle: Text(
          description,
          style: AppTypography.bodyLarge.copyWith(
            color: AppColors.textSecondary,
            fontSize: 14,
          ),
        ),
        trailing: const Icon(
          Icons.arrow_forward_ios,
          color: AppColors.textSecondary,
          size: 16,
        ),
        onTap: () {
          // Handle navigation to resource
        },
      ),
    );
  }

  Widget _buildInfoItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: AppTypography.bodyLarge.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          Text(
            value,
            style: AppTypography.bodyLarge.copyWith(
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

import '../../../common/widgets/app_main_button.dart';
import '../../../common/widgets/onboarding/onboarding_progress_dots.dart';
import '../../../core/config/theme/app_colors.dart';
import '../../../core/config/theme/app_spacing.dart';
import '../../../core/config/theme/app_text_theme.dart';

class ProfilePhotosScreen extends StatefulWidget {
  const ProfilePhotosScreen({
    super.key,
    required this.onBack,
    required this.onContinue,
    required this.onSkip,
  });

  final VoidCallback onBack;
  final void Function(File? userPhoto, File? partnerPhoto) onContinue;
  final VoidCallback onSkip;

  @override
  State<ProfilePhotosScreen> createState() => _ProfilePhotosScreenState();
}

class _ProfilePhotosScreenState extends State<ProfilePhotosScreen> {
  final ImagePicker _picker = ImagePicker();

  File? _userPhoto;
  File? _partnerPhoto;

  Future<void> _pickPhoto({
    required bool isUser,
  }) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
      );

      if (pickedFile == null) return;

      setState(() {
        if (isUser) {
          _userPhoto = File(pickedFile.path);
        } else {
          _partnerPhoto = File(pickedFile.path);
        }
      });
    } catch (e) {
      debugPrint('Could not pick image: $e');
    }
  }

  void _handleContinue() {
    widget.onContinue(
      _userPhoto,
      _partnerPhoto,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      body: SafeArea(
        child: Column(
          children: [
            // ------------------------------------------------------------
            // TOP NAVIGATION
            // ------------------------------------------------------------
            SizedBox(
              height: 72,
              width: double.infinity,
              child: Stack(
                children: [
                  // Back arrow — fixed to top-left
                  Positioned(
                    left: 16,
                    top: 12,
                    child: IconButton(
                      onPressed: widget.onBack,
                      icon: const Icon(
                        Icons.arrow_back_ios_new_rounded,
                        size: 19,
                      ),
                      color: AppColors.primary,
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(
                        minWidth: 40,
                        minHeight: 40,
                      ),
                    ),
                  ),

                  // Progress indicators — centered
                  Positioned.fill(
                    child: Align(
                      alignment: Alignment.center,
                      child: const ProgressDots(
                        currentStep: 3,
                        totalSteps: 5,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // ==========================================================
            // MAIN CONTENT
            // ==========================================================
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.lg,
                ),
                child: Column(
                  children: [
                    const SizedBox(height: 20),

                    // ====================================================
                    // WHITE CARD
                    // ====================================================
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.fromLTRB(
                        16,
                        22,
                        16,
                        22,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.045),
                            blurRadius: 15,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          // ----------------------------------------------
                          // TITLE
                          // ----------------------------------------------
                          Text(
                            'Faces of Love',
                            textAlign: TextAlign.center,
                            style: AppTextTheme.headlineMedium.copyWith(
                              color: AppColors.textPrimary,
                              fontWeight: FontWeight.w600,
                              height: 1.2,
                            ),
                          ),

                          const SizedBox(height: 6),

                          // ----------------------------------------------
                          // DESCRIPTION
                          // ----------------------------------------------
                          Text(
                            'Add photos so this sanctuary feels\n'
                                'uniquely yours. These will be your\n'
                                'avatars in the journal.',
                            textAlign: TextAlign.center,
                            style: AppTextTheme.bodyMedium.copyWith(
                              color: AppColors.textSecondary,
                              height: 1.4,
                            ),
                          ),

                          const SizedBox(height: 26),

                          // ----------------------------------------------
                          // PHOTOS ROW
                          // ----------------------------------------------
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              // USER PHOTO
                              _PhotoPicker(
                                photo: _userPhoto,
                                label: 'You',
                                onTap: () {
                                  _pickPhoto(isUser: true);
                                },
                              ),

                              // HEART
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                ),
                                child: Icon(
                                  Icons.favorite_rounded,
                                  size: 14,
                                  color: AppColors.primaryContainer,
                                ),
                              ),

                              // PARTNER PHOTO
                              _PhotoPicker(
                                photo: _partnerPhoto,
                                label: 'Partner',
                                onTap: () {
                                  _pickPhoto(isUser: false);
                                },
                                isPartner: true,
                              ),
                            ],
                          ),

                          const SizedBox(height: 28),

                          // ----------------------------------------------
                          // CONTINUE BUTTON
                          // ----------------------------------------------

                          AppMainButton(
                            text: 'Continue',
                            onPressed: _handleContinue,
                            height: 48,
                            borderRadius: 6,
                          ),

                          const SizedBox(height: 17),

                          // ----------------------------------------------
                          // SKIP
                          // ----------------------------------------------
                          GestureDetector(
                            onTap: widget.onSkip,
                            child: Padding(
                              padding: const EdgeInsets.all(4),
                              child: Text(
                                'Skip for now',
                                style: AppTextTheme.bodyMedium.copyWith(
                                  fontSize: 12,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ======================================================================
// PHOTO PICKER
// ======================================================================

class _PhotoPicker extends StatelessWidget {
  const _PhotoPicker({
    required this.photo,
    required this.label,
    required this.onTap,
    this.isPartner = false,
  });

  final File? photo;
  final String label;
  final VoidCallback onTap;
  final bool isPartner;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: onTap,
          child: photo != null
              ? _SelectedPhoto(
            photo: photo!,
          )
              : _EmptyPhotoPicker(
            isPartner: isPartner,
          ),
        ),

        const SizedBox(height: 7),

        Text(
          label,
          style: AppTextTheme.labelSmall.copyWith(
            fontSize: 10,
            color: AppColors.textPrimary,
          ),
        ),
      ],
    );
  }
}

// ======================================================================
// EMPTY PHOTO PICKER
// ======================================================================

class _EmptyPhotoPicker extends StatelessWidget {
  const _EmptyPhotoPicker({
    required this.isPartner,
  });

  final bool isPartner;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 70,
      height: 70,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: isPartner
              ? AppColors.outlineVariant
              : AppColors.primaryContainer,
          width: 1.2,
        ),
      ),
      child: Center(
        child: Icon(
          Icons.add_a_photo_outlined,
          size: 25,
          color: AppColors.primary.withValues(alpha: 0.7),
        ),
      ),
    );
  }
}

// ======================================================================
// SELECTED PHOTO
// ======================================================================

class _SelectedPhoto extends StatelessWidget {
  const _SelectedPhoto({
    required this.photo,
  });

  final File photo;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 70,
      height: 70,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: AppColors.primaryContainer,
          width: 2,
        ),
        image: DecorationImage(
          image: FileImage(photo),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}

// ============================================================================
// PROGRESS INDICATOR
// ============================================================================

class _ProgressIndicator extends StatelessWidget {
  const _ProgressIndicator({
    required this.currentStep,
    required this.totalSteps,
  });

  final int currentStep;
  final int totalSteps;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(
        totalSteps,
            (index) {
          final bool isActive =
              index + 1 == currentStep;

          return Container(
            width: isActive ? 28 : 28,
            height: 7,
            margin: const EdgeInsets.symmetric(
              horizontal: 7,
            ),
            decoration: BoxDecoration(
              color: isActive
                  ? AppColors.primary
                  : AppColors.outlineVariant.withValues(
                alpha: 0.55,
              ),
              borderRadius: BorderRadius.circular(10),
            ),
          );
        },
      ),
    );
  }
}
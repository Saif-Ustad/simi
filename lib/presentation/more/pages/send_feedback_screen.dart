import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

import '../../../core/config/theme/app_colors.dart';
import '../../../core/config/theme/app_text_theme.dart';

class SendFeedbackScreen extends StatefulWidget {
  const SendFeedbackScreen({
    super.key,
    this.initialEmail = '',
    this.onBack,
    this.onSubmit,
  });

  final String initialEmail;

  final VoidCallback? onBack;
  final ValueChanged<FeedbackData>? onSubmit;

  @override
  State<SendFeedbackScreen> createState() =>
      _SendFeedbackScreenState();
}

class _SendFeedbackScreenState
    extends State<SendFeedbackScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;

  final TextEditingController _messageController =
  TextEditingController();

  final TextEditingController _emailController =
  TextEditingController();

  final TextEditingController _detailsController =
  TextEditingController();

  final ImagePicker _picker = ImagePicker();

  FeedbackType _feedbackType =
      FeedbackType.idea;

  int _rating = 0;

  XFile? _attachment;

  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();

    _emailController.text = widget.initialEmail;

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 850),
    )..forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _messageController.dispose();
    _emailController.dispose();
    _detailsController.dispose();
    super.dispose();
  }

  // ===========================================================================
  // SUBMIT
  // ===========================================================================

  Future<void> _submitFeedback() async {
    final message =
    _messageController.text.trim();

    if (message.isEmpty) {
      _showMessage(
        'Tell us a little more about your thoughts.',
      );
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    final data = FeedbackData(
      type: _feedbackType,
      rating: _rating,
      message: message,
      details: _detailsController.text.trim(),
      email: _emailController.text.trim(),
      attachment: _attachment,
    );

    // Small delay for a polished submission state.
    await Future.delayed(
      const Duration(milliseconds: 700),
    );

    if (!mounted) return;

    widget.onSubmit?.call(data);

    setState(() {
      _isSubmitting = false;
    });

    _showSuccess();
  }

  // ===========================================================================
  // PICK IMAGE
  // ===========================================================================

  Future<void> _pickAttachment() async {
    try {
      final image =
      await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
      );

      if (image == null || !mounted) {
        return;
      }

      setState(() {
        _attachment = image;
      });
    } catch (_) {
      _showMessage(
        'Could not open your photos.',
      );
    }
  }

  void _removeAttachment() {
    setState(() {
      _attachment = null;
    });
  }

  // ===========================================================================
  // SUCCESS
  // ===========================================================================

  void _showSuccess() {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (sheetContext) {
        return Container(
          width: double.infinity,
          padding: const EdgeInsets.fromLTRB(
            22,
            12,
            22,
            24,
          ),
          decoration: const BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(32),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const _SheetHandle(),

              const SizedBox(height: 24),

              Container(
                width: 70,
                height: 70,
                decoration: const BoxDecoration(
                  color: Color(0xFFFCE4EC),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.favorite_rounded,
                  size: 30,
                  color: AppColors.primary,
                ),
              ),

              const SizedBox(height: 19),

              Text(
                'Thank you.',
                style: GoogleFonts.playfairDisplay(
                  fontSize: 27,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),

              const SizedBox(height: 7),

              Text(
                'Your little note has been sent to the '
                    'SIMI team. We really appreciate you '
                    'taking the time.',
                textAlign: TextAlign.center,
                style: AppTextTheme.bodyMedium.copyWith(
                  fontSize: 11,
                  height: 1.55,
                  color: AppColors.textSecondary,
                ),
              ),

              const SizedBox(height: 22),

              SizedBox(
                width: double.infinity,
                height: 54,
                child: GestureDetector(
                  onTap: () {
                    Navigator.of(sheetContext).pop();
                    Navigator.of(context).maybePop();
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius:
                      BorderRadius.circular(27),
                    ),
                    child: Center(
                      child: Text(
                        'Done',
                        style:
                        AppTextTheme.labelLarge.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 4),
            ],
          ),
        );
      },
    );
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.all(16),
        ),
      );
  }

  // ===========================================================================
  // BUILD
  // ===========================================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      resizeToAvoidBottomInset: true,
      body: Stack(
        children: [
          const Positioned.fill(
            child: _FeedbackBackground(),
          ),

          SafeArea(
            bottom: false,
            child: ListView(
              physics:
              const BouncingScrollPhysics(),
              padding: const EdgeInsets.only(
                bottom: 125,
              ),
              children: [
                _buildTopBar(context),
                _buildHero(),
                _buildFeedbackType(),
                _buildRating(),
                _buildMessage(),
                if (_feedbackType ==
                    FeedbackType.bug)
                  _buildBugDetails(),
                _buildAttachment(),
                _buildEmail(),
                _buildPrivacyNote(),
              ],
            ),
          ),

          _buildBottomAction(),
        ],
      ),
    );
  }

  // ===========================================================================
  // TOP BAR
  // ===========================================================================

  Widget _buildTopBar(
      BuildContext context,
      ) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        20,
        10,
        20,
        0,
      ),
      child: Row(
        children: [
          _CircleButton(
            icon: Icons.arrow_back_rounded,
            onTap: () {
              if (widget.onBack != null) {
                widget.onBack!();
              } else {
                Navigator.of(context).maybePop();
              }
            },
          ),

          const SizedBox(width: 13),

          Expanded(
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [
                Text(
                  'ABOUT SIMI',
                  style:
                  AppTextTheme.labelSmall.copyWith(
                    fontSize: 9,
                    letterSpacing: 2,
                    fontWeight:
                    FontWeight.w600,
                    color:
                    AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Send Feedback',
                  style:
                  GoogleFonts.playfairDisplay(
                    fontSize: 20,
                    fontWeight:
                    FontWeight.w600,
                    color:
                    AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),

          Container(
            width: 38,
            height: 38,
            decoration: const BoxDecoration(
              color: Color(0xFFFCE4EC),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.favorite_border_rounded,
              size: 18,
              color: AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }

  // ===========================================================================
  // HERO
  // ===========================================================================

  Widget _buildHero() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        20,
        25,
        20,
        0,
      ),
      child: _AnimatedEntry(
        controller: _animationController,
        begin: 0,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.fromLTRB(
            22,
            23,
            22,
            24,
          ),
          decoration: BoxDecoration(
            gradient:
            const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFF292324),
                Color(0xFF4B383A),
                Color(0xFF60484B),
              ],
            ),
            borderRadius:
            BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                color: Colors.black
                    .withValues(alpha: 0.10),
                blurRadius: 24,
                offset:
                const Offset(0, 9),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment:
            CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 52,
                    height: 52,
                    decoration:
                    BoxDecoration(
                      color: Colors.white
                          .withValues(
                        alpha: 0.09,
                      ),
                      shape:
                      BoxShape.circle,
                      border: Border.all(
                        color: Colors.white
                            .withValues(
                          alpha: 0.12,
                        ),
                      ),
                    ),
                    child:
                    const Icon(
                      Icons
                          .chat_bubble_outline_rounded,
                      size: 22,
                      color: Color(
                        0xFFE8B4B8,
                      ),
                    ),
                  ),

                  const Spacer(),

                  Container(
                    padding:
                    const EdgeInsets
                        .symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration:
                    BoxDecoration(
                      color: Colors.white
                          .withValues(
                        alpha: 0.08,
                      ),
                      borderRadius:
                      BorderRadius.circular(
                        999,
                      ),
                    ),
                    child: Text(
                      'WE\'RE LISTENING',
                      style: AppTextTheme
                          .labelSmall
                          .copyWith(
                        fontSize: 7.5,
                        letterSpacing: 1.2,
                        fontWeight:
                        FontWeight.w600,
                        color: Colors.white
                            .withValues(
                          alpha: 0.62,
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 22),

              Text(
                'TELL US WHAT YOU THINK',
                style: AppTextTheme
                    .labelSmall
                    .copyWith(
                  fontSize: 9,
                  letterSpacing: 2,
                  fontWeight:
                  FontWeight.w600,
                  color: const Color(
                    0xFFE8B4B8,
                  ),
                ),
              ),

              const SizedBox(height: 7),

              Text(
                'We want to hear from you.',
                style: GoogleFonts
                    .playfairDisplay(
                  fontSize: 27,
                  fontWeight:
                  FontWeight.w600,
                  color: Colors.white,
                ),
              ),

              const SizedBox(height: 7),

              Text(
                'A good idea, a tiny complaint, '
                    'something that made you smile — '
                    'send it our way.',
                style: AppTextTheme.bodyMedium
                    .copyWith(
                  fontSize: 11,
                  height: 1.55,
                  color: Colors.white
                      .withValues(
                    alpha: 0.70,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ===========================================================================
  // FEEDBACK TYPE
  // ===========================================================================

  Widget _buildFeedbackType() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        20,
        29,
        20,
        0,
      ),
      child: _AnimatedEntry(
        controller: _animationController,
        begin: 0.10,
        child: Column(
          crossAxisAlignment:
          CrossAxisAlignment.start,
          children: [
            const _SectionLabel(
              text: 'WHAT\'S ON YOUR MIND?',
            ),

            const SizedBox(height: 11),

            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _TypeChip(
                  icon:
                  Icons.lightbulb_outline_rounded,
                  label: 'Idea',
                  selected:
                  _feedbackType ==
                      FeedbackType.idea,
                  onTap: () {
                    setState(() {
                      _feedbackType =
                          FeedbackType.idea;
                    });
                  },
                ),
                _TypeChip(
                  icon:
                  Icons.favorite_border_rounded,
                  label: 'Love it',
                  selected:
                  _feedbackType ==
                      FeedbackType.love,
                  onTap: () {
                    setState(() {
                      _feedbackType =
                          FeedbackType.love;
                    });
                  },
                ),
                _TypeChip(
                  icon:
                  Icons.bug_report_outlined,
                  label: 'Bug',
                  selected:
                  _feedbackType ==
                      FeedbackType.bug,
                  onTap: () {
                    setState(() {
                      _feedbackType =
                          FeedbackType.bug;
                    });
                  },
                ),
                _TypeChip(
                  icon:
                  Icons.chat_outlined,
                  label: 'Something else',
                  selected:
                  _feedbackType ==
                      FeedbackType.other,
                  onTap: () {
                    setState(() {
                      _feedbackType =
                          FeedbackType.other;
                    });
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ===========================================================================
  // RATING
  // ===========================================================================

  Widget _buildRating() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        20,
        27,
        20,
        0,
      ),
      child: _AnimatedEntry(
        controller: _animationController,
        begin: 0.15,
        child: Container(
          width: double.infinity,
          padding:
          const EdgeInsets.all(17),
          decoration: BoxDecoration(
            color: Colors.white
                .withValues(alpha: 0.76),
            borderRadius:
            BorderRadius.circular(22),
            border: Border.all(
              color: AppColors
                  .outlineVariant
                  .withValues(alpha: 0.45),
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment
                      .start,
                  children: [
                    Text(
                      'HOW DOES SIMI FEEL?',
                      style: AppTextTheme
                          .labelSmall
                          .copyWith(
                        fontSize: 8.5,
                        letterSpacing:
                        1.4,
                        fontWeight:
                        FontWeight.w600,
                        color: AppColors
                            .textSecondary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Optional rating',
                      style: AppTextTheme
                          .bodyMedium
                          .copyWith(
                        fontSize: 10,
                        color: AppColors
                            .textSecondary,
                      ),
                    ),
                  ],
                ),
              ),

              Row(
                mainAxisSize:
                MainAxisSize.min,
                children: List.generate(
                  5,
                      (index) {
                    final selected =
                        index <
                            _rating;

                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          _rating =
                              index + 1;
                        });
                      },
                      child: Padding(
                        padding:
                        const EdgeInsets
                            .only(
                          left: 4,
                        ),
                        child: Icon(
                          selected
                              ? Icons
                              .favorite_rounded
                              : Icons
                              .favorite_border_rounded,
                          size: 19,
                          color: selected
                              ? AppColors
                              .primary
                              : AppColors
                              .outlineVariant,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ===========================================================================
  // MESSAGE
  // ===========================================================================

  Widget _buildMessage() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        20,
        27,
        20,
        0,
      ),
      child: _AnimatedEntry(
        controller: _animationController,
        begin: 0.20,
        child: Column(
          crossAxisAlignment:
          CrossAxisAlignment.start,
          children: [
            const _SectionLabel(
              text: 'YOUR MESSAGE',
            ),

            const SizedBox(height: 11),

            Container(
              decoration: BoxDecoration(
                color: Colors.white
                    .withValues(alpha: 0.80),
                borderRadius:
                BorderRadius.circular(22),
                border: Border.all(
                  color: AppColors
                      .outlineVariant
                      .withValues(
                    alpha: 0.48,
                  ),
                ),
              ),
              child: TextField(
                controller:
                _messageController,
                minLines: 5,
                maxLines: 8,
                textCapitalization:
                TextCapitalization.sentences,
                style: AppTextTheme
                    .bodyLarge
                    .copyWith(
                  fontSize: 12,
                  height: 1.5,
                  color: AppColors
                      .textPrimary,
                ),
                decoration:
                InputDecoration(
                  hintText:
                  'Tell us what you\'re thinking...',
                  hintStyle:
                  AppTextTheme
                      .bodyMedium
                      .copyWith(
                    fontSize: 11,
                    color: AppColors
                        .textDisabled,
                  ),
                  border:
                  InputBorder.none,
                  contentPadding:
                  const EdgeInsets
                      .all(16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ===========================================================================
  // BUG DETAILS
  // ===========================================================================

  Widget _buildBugDetails() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        20,
        18,
        20,
        0,
      ),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white
              .withValues(alpha: 0.76),
          borderRadius:
          BorderRadius.circular(21),
          border: Border.all(
            color: AppColors
                .outlineVariant
                .withValues(alpha: 0.42),
          ),
        ),
        child: TextField(
          controller: _detailsController,
          minLines: 3,
          maxLines: 6,
          textCapitalization:
          TextCapitalization.sentences,
          style: AppTextTheme.bodyMedium
              .copyWith(
            fontSize: 11,
            height: 1.5,
            color:
            AppColors.textPrimary,
          ),
          decoration: InputDecoration(
            labelText:
            'What happened?',
            labelStyle:
            AppTextTheme.labelSmall
                .copyWith(
              fontSize: 9,
              color: AppColors
                  .textSecondary,
            ),
            hintText:
            'What were you doing when it happened?',
            hintStyle:
            AppTextTheme.bodyMedium
                .copyWith(
              fontSize: 10,
              color:
              AppColors.textDisabled,
            ),
            border:
            InputBorder.none,
            contentPadding:
            const EdgeInsets.all(16),
          ),
        ),
      ),
    );
  }

  // ===========================================================================
  // ATTACHMENT
  // ===========================================================================

  Widget _buildAttachment() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        20,
        24,
        20,
        0,
      ),
      child: Column(
        crossAxisAlignment:
        CrossAxisAlignment.start,
        children: [
          const _SectionLabel(
            text: 'OPTIONAL ATTACHMENT',
          ),

          const SizedBox(height: 10),

          if (_attachment == null)
            GestureDetector(
              onTap: _pickAttachment,
              child: Container(
                width: double.infinity,
                padding:
                const EdgeInsets.symmetric(
                  horizontal: 15,
                  vertical: 14,
                ),
                decoration: BoxDecoration(
                  color: Colors.white
                      .withValues(
                    alpha: 0.72,
                  ),
                  borderRadius:
                  BorderRadius.circular(
                    19,
                  ),
                  border: Border.all(
                    color: AppColors
                        .outlineVariant
                        .withValues(
                      alpha: 0.50,
                    ),
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 39,
                      height: 39,
                      decoration:
                      const BoxDecoration(
                        color:
                        Color(0xFFF5F1F0),
                        shape:
                        BoxShape.circle,
                      ),
                      child:
                      const Icon(
                        Icons
                            .add_photo_alternate_outlined,
                        size: 18,
                        color:
                        AppColors.primary,
                      ),
                    ),

                    const SizedBox(width: 11),

                    Expanded(
                      child: Column(
                        crossAxisAlignment:
                        CrossAxisAlignment
                            .start,
                        children: [
                          Text(
                            'Add a screenshot',
                            style: AppTextTheme
                                .labelLarge
                                .copyWith(
                              fontSize: 11,
                              fontWeight:
                              FontWeight
                                  .w600,
                              color: AppColors
                                  .textPrimary,
                            ),
                          ),
                          const SizedBox(
                            height: 3,
                          ),
                          Text(
                            'Helpful when reporting a bug.',
                            style: AppTextTheme
                                .labelSmall
                                .copyWith(
                              fontSize: 9,
                              color: AppColors
                                  .textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const Icon(
                      Icons
                          .arrow_forward_ios_rounded,
                      size: 10,
                      color:
                      AppColors.primary,
                    ),
                  ],
                ),
              ),
            )
          else
            _buildAttachmentPreview(),
        ],
      ),
    );
  }

  Widget _buildAttachmentPreview() {
    return Container(
      height: 92,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius:
        BorderRadius.circular(20),
        border: Border.all(
          color: AppColors
              .outlineVariant
              .withValues(alpha: 0.45),
        ),
      ),
      clipBehavior:
      Clip.antiAlias,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.file(
            File(_attachment!.path),
            fit: BoxFit.cover,
          ),

          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient:
                LinearGradient(
                  begin:
                  Alignment.topCenter,
                  end:
                  Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withValues(
                      alpha: 0.42,
                    ),
                  ],
                ),
              ),
            ),
          ),

          Positioned(
            left: 12,
            bottom: 10,
            child: Text(
              'Screenshot attached',
              style: AppTextTheme
                  .labelSmall
                  .copyWith(
                fontSize: 9,
                fontWeight:
                FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),

          Positioned(
            right: 9,
            top: 9,
            child: GestureDetector(
              onTap: _removeAttachment,
              child: Container(
                width: 30,
                height: 30,
                decoration:
                BoxDecoration(
                  color: Colors.black
                      .withValues(
                    alpha: 0.48,
                  ),
                  shape:
                  BoxShape.circle,
                ),
                child: const Icon(
                  Icons.close_rounded,
                  size: 16,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ===========================================================================
  // EMAIL
  // ===========================================================================

  Widget _buildEmail() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        20,
        24,
        20,
        0,
      ),
      child: Column(
        crossAxisAlignment:
        CrossAxisAlignment.start,
        children: [
          const _SectionLabel(
            text: 'EMAIL · OPTIONAL',
          ),

          const SizedBox(height: 10),

          Container(
            decoration: BoxDecoration(
              color: Colors.white
                  .withValues(alpha: 0.78),
              borderRadius:
              BorderRadius.circular(19),
              border: Border.all(
                color: AppColors
                    .outlineVariant
                    .withValues(alpha: 0.45),
              ),
            ),
            child: TextField(
              controller:
              _emailController,
              keyboardType:
              TextInputType.emailAddress,
              style: AppTextTheme
                  .bodyMedium
                  .copyWith(
                fontSize: 11,
                color:
                AppColors.textPrimary,
              ),
              decoration:
              InputDecoration(
                prefixIcon:
                const Icon(
                  Icons
                      .mail_outline_rounded,
                  size: 18,
                  color:
                  AppColors.primary,
                ),
                hintText:
                'you@example.com',
                hintStyle:
                AppTextTheme
                    .bodyMedium
                    .copyWith(
                  fontSize: 10,
                  color:
                  AppColors.textDisabled,
                ),
                border:
                InputBorder.none,
                contentPadding:
                const EdgeInsets
                    .symmetric(
                  horizontal: 12,
                  vertical: 15,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ===========================================================================
  // PRIVACY NOTE
  // ===========================================================================

  Widget _buildPrivacyNote() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        20,
        22,
        20,
        0,
      ),
      child: Container(
        width: double.infinity,
        padding:
        const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: const Color(
            0xFFF5F1F0,
          ),
          borderRadius:
          BorderRadius.circular(18),
        ),
        child: Row(
          crossAxisAlignment:
          CrossAxisAlignment.start,
          children: [
            const Icon(
              Icons
                  .lock_outline_rounded,
              size: 16,
              color:
              AppColors.primary,
            ),

            const SizedBox(width: 9),

            Expanded(
              child: Text(
                'Please avoid sending passwords, '
                    'PINs, financial information, or '
                    'other sensitive information in '
                    'feedback.',
                style: AppTextTheme
                    .labelSmall
                    .copyWith(
                  fontSize: 9,
                  height: 1.45,
                  color:
                  AppColors.textSecondary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ===========================================================================
  // BOTTOM ACTION
  // ===========================================================================

  Widget _buildBottomAction() {
    return Positioned(
      left: 18,
      right: 18,
      bottom: 12,
      child: SafeArea(
        top: false,
        child: Center(
          child: ConstrainedBox(
            constraints:
            const BoxConstraints(
              maxWidth: 540,
            ),
            child: Padding(
              padding:
              const EdgeInsets.symmetric(
                horizontal: 5,
              ),
              child: GestureDetector(
                onTap: _isSubmitting
                    ? null
                    : _submitFeedback,
                child: Container(
                  height: 58,
                  decoration: BoxDecoration(
                    gradient:
                    const LinearGradient(
                      begin:
                      Alignment.topLeft,
                      end:
                      Alignment.bottomRight,
                      colors: [
                        Color(0xFF765457),
                        Color(0xFF966E72),
                      ],
                    ),
                    borderRadius:
                    BorderRadius.circular(
                      29,
                    ),
                    border: Border.all(
                      color: Colors.white
                          .withValues(
                        alpha: 0.14,
                      ),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors
                            .primary
                            .withValues(
                          alpha: 0.23,
                        ),
                        blurRadius: 20,
                        offset:
                        const Offset(
                          0,
                          8,
                        ),
                      ),
                      BoxShadow(
                        color: Colors.black
                            .withValues(
                          alpha: 0.08,
                        ),
                        blurRadius: 12,
                        offset:
                        const Offset(
                          0,
                          4,
                        ),
                      ),
                    ],
                  ),
                  child: _isSubmitting
                      ? const Center(
                    child:
                    SizedBox(
                      width: 21,
                      height: 21,
                      child:
                      CircularProgressIndicator(
                        strokeWidth: 2,
                        color:
                        Colors.white,
                      ),
                    ),
                  )
                      : Row(
                    children: [
                      const SizedBox(
                        width: 7,
                      ),

                      Container(
                        width: 46,
                        height: 46,
                        decoration:
                        BoxDecoration(
                          color: Colors
                              .white
                              .withValues(
                            alpha: 0.13,
                          ),
                          shape:
                          BoxShape
                              .circle,
                        ),
                        child:
                        const Icon(
                          Icons
                              .send_rounded,
                          size: 20,
                          color:
                          Colors.white,
                        ),
                      ),

                      const SizedBox(
                        width: 13,
                      ),

                      Expanded(
                        child: Column(
                          mainAxisAlignment:
                          MainAxisAlignment
                              .center,
                          crossAxisAlignment:
                          CrossAxisAlignment
                              .start,
                          children: [
                            Text(
                              'Send your thoughts',
                              style: GoogleFonts
                                  .playfairDisplay(
                                fontSize: 16,
                                fontWeight:
                                FontWeight
                                    .w600,
                                color: Colors
                                    .white,
                              ),
                            ),
                            const SizedBox(
                              height: 2,
                            ),
                            Text(
                              'Help us make SIMI better',
                              style: AppTextTheme
                                  .labelSmall
                                  .copyWith(
                                fontSize: 9,
                                color: Colors
                                    .white
                                    .withValues(
                                  alpha:
                                  0.68,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      Container(
                        width: 42,
                        height: 42,
                        margin:
                        const EdgeInsets
                            .only(
                          right: 4,
                        ),
                        decoration:
                        BoxDecoration(
                          color: Colors
                              .white
                              .withValues(
                            alpha: 0.11,
                          ),
                          shape:
                          BoxShape
                              .circle,
                        ),
                        child:
                        const Icon(
                          Icons
                              .arrow_forward_rounded,
                          size: 19,
                          color:
                          Colors.white,
                        ),
                      ),

                      const SizedBox(
                        width: 2,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// =============================================================================
// MODEL
// =============================================================================

enum FeedbackType {
  idea,
  love,
  bug,
  other,
}

class FeedbackData {
  const FeedbackData({
    required this.type,
    required this.rating,
    required this.message,
    required this.details,
    required this.email,
    required this.attachment,
  });

  final FeedbackType type;
  final int rating;
  final String message;
  final String details;
  final String email;
  final XFile? attachment;
}

// =============================================================================
// TYPE CHIP
// =============================================================================

class _TypeChip extends StatelessWidget {
  const _TypeChip({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration:
        const Duration(milliseconds: 180),
        padding:
        const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 10,
        ),
        decoration: BoxDecoration(
          color: selected
              ? AppColors.primary
              : Colors.white
              .withValues(alpha: 0.76),
          borderRadius:
          BorderRadius.circular(999),
          border: Border.all(
            color: selected
                ? AppColors.primary
                : AppColors
                .outlineVariant
                .withValues(alpha: 0.45),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 14,
              color: selected
                  ? Colors.white
                  : AppColors.primary,
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: AppTextTheme.labelSmall
                  .copyWith(
                fontSize: 9,
                fontWeight:
                FontWeight.w600,
                color: selected
                    ? Colors.white
                    : AppColors.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// =============================================================================
// SECTION LABEL
// =============================================================================

class _SectionLabel
    extends StatelessWidget {
  const _SectionLabel({
    required this.text,
  });

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style:
      AppTextTheme.labelSmall.copyWith(
        fontSize: 9,
        letterSpacing: 1.8,
        fontWeight:
        FontWeight.w600,
        color:
        AppColors.textSecondary,
      ),
    );
  }
}

// =============================================================================
// CIRCLE BUTTON
// =============================================================================

class _CircleButton
    extends StatelessWidget {
  const _CircleButton({
    required this.icon,
    this.onTap,
  });

  final IconData icon;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 42,
        height: 42,
        decoration: BoxDecoration(
          color: Colors.white
              .withValues(alpha: 0.78),
          shape: BoxShape.circle,
          border: Border.all(
            color: AppColors
                .outlineVariant
                .withValues(alpha: 0.50),
          ),
        ),
        child: Icon(
          icon,
          size: 18,
          color:
          AppColors.textPrimary,
        ),
      ),
    );
  }
}

// =============================================================================
// SHEET HANDLE
// =============================================================================

class _SheetHandle
    extends StatelessWidget {
  const _SheetHandle();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 38,
      height: 4,
      decoration: BoxDecoration(
        color: AppColors
            .outlineVariant
            .withValues(alpha: 0.7),
        borderRadius:
        BorderRadius.circular(999),
      ),
    );
  }
}

// =============================================================================
// BACKGROUND
// =============================================================================

class _FeedbackBackground
    extends StatelessWidget {
  const _FeedbackBackground();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          top: 120,
          right: -120,
          child: ImageFiltered(
            imageFilter:
            ImageFilter.blur(
              sigmaX: 55,
              sigmaY: 55,
            ),
            child: Container(
              width: 290,
              height: 290,
              decoration: BoxDecoration(
                color: const Color(
                  0xFFE8B4B8,
                ).withValues(
                  alpha: 0.055,
                ),
                shape:
                BoxShape.circle,
              ),
            ),
          ),
        ),

        Positioned(
          top: 760,
          left: -130,
          child: ImageFiltered(
            imageFilter:
            ImageFilter.blur(
              sigmaX: 60,
              sigmaY: 60,
            ),
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                color: const Color(
                  0xFF6B6D91,
                ).withValues(
                  alpha: 0.03,
                ),
                shape:
                BoxShape.circle,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// =============================================================================
// ANIMATION
// =============================================================================

class _AnimatedEntry
    extends StatelessWidget {
  const _AnimatedEntry({
    required this.controller,
    required this.begin,
    required this.child,
  });

  final AnimationController controller;
  final double begin;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final animation =
    CurvedAnimation(
      parent: controller,
      curve: Interval(
        begin,
        (begin + 0.34).clamp(
          0.0,
          1.0,
        ),
        curve:
        Curves.easeOutCubic,
      ),
    );

    return AnimatedBuilder(
      animation: animation,
      child: child,
      builder: (
          context,
          child,
          ) {
        return Opacity(
          opacity: animation.value,
          child: Transform.translate(
            offset: Offset(
              0,
              13 *
                  (1 -
                      animation.value),
            ),
            child: child,
          ),
        );
      },
    );
  }
}
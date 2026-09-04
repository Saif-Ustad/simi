import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/config/theme/app_colors.dart';
import '../../../core/config/theme/app_text_theme.dart';

class TodayFeelingScreen extends StatefulWidget {
  const TodayFeelingScreen({
    super.key,
    this.initialMood,
  });

  final String? initialMood;

  @override
  State<TodayFeelingScreen> createState() =>
      _TodayFeelingScreenState();
}

class _TodayFeelingScreenState
    extends State<TodayFeelingScreen> {
  final TextEditingController _noteController =
  TextEditingController();

  String? _selectedMood;
  bool _shareWithPartner = true;

  final List<_MoodOption> _moods = const [
    _MoodOption(
      emoji: '😊',
      title: 'Good',
      subtitle: 'Feeling good',
      background: Color(0xFFF6EEE8),
    ),
    _MoodOption(
      emoji: '😌',
      title: 'Calm',
      subtitle: 'Feeling peaceful',
      background: Color(0xFFF0EFF6),
    ),
    _MoodOption(
      emoji: '🥰',
      title: 'Happy',
      subtitle: 'Feeling happy',
      background: Color(0xFFFFF0E7),
    ),
    _MoodOption(
      emoji: '🥺',
      title: 'Low',
      subtitle: 'Need some comfort',
      background: Color(0xFFFCE4EC),
    ),
    _MoodOption(
      emoji: '😔',
      title: 'Sad',
      subtitle: 'Feeling a little down',
      background: Color(0xFFEDEBF4),
    ),
    _MoodOption(
      emoji: '😤',
      title: 'Irritated',
      subtitle: 'Feeling frustrated',
      background: Color(0xFFF5E9E4),
    ),
  ];

  @override
  void initState() {
    super.initState();

    _selectedMood = widget.initialMood;
  }

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  bool get _canShare =>
      _selectedMood != null ||
          _noteController.text.trim().isNotEmpty;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            _buildTopBar(context),

            Expanded(
              child: SingleChildScrollView(
                physics:
                const BouncingScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(
                  20,
                  10,
                  20,
                  30,
                ),
                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  children: [
                    _buildHeader(),

                    const SizedBox(height: 26),

                    _buildMoodSection(),

                    const SizedBox(height: 28),

                    _buildNoteSection(),

                    const SizedBox(height: 22),

                    _buildPartnerCard(),

                    const SizedBox(height: 24),

                    _buildPreview(),

                    const SizedBox(height: 26),

                    _buildShareButton(),

                    const SizedBox(height: 18),

                    _buildPrivacy(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ==========================================================
  // TOP BAR
  // ==========================================================

  Widget _buildTopBar(BuildContext context) {
    return SizedBox(
      height: 62,
      child: Row(
        children: [
          IconButton(
            onPressed: () => context.pop(),
            icon: const Icon(
              Icons.arrow_back_ios_new_rounded,
              size: 18,
            ),
            color: AppColors.textPrimary,
          ),

          Expanded(
            child: Text(
              'Today',
              textAlign: TextAlign.center,
              style:
              AppTextTheme.headlineSmall.copyWith(
                fontFamily: 'Playfair Display',
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: AppColors.primary,
              ),
            ),
          ),

          const SizedBox(width: 48),
        ],
      ),
    );
  }

  // ==========================================================
  // HEADER
  // ==========================================================

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment:
      CrossAxisAlignment.start,
      children: [
        Text(
          'How are you feeling?',
          style:
          AppTextTheme.headlineMedium.copyWith(
            fontFamily: 'Playfair Display',
            fontSize: 28,
            fontWeight: FontWeight.w600,
            height: 1.15,
            color: AppColors.textPrimary,
          ),
        ),

        const SizedBox(height: 8),

        Text(
          'There is no right or wrong feeling. '
              'Just tell your love what is on your heart.',
          style:
          AppTextTheme.bodyMedium.copyWith(
            fontSize: 12,
            height: 1.5,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }

  // ==========================================================
  // MOODS
  // ==========================================================

  Widget _buildMoodSection() {
    return Column(
      crossAxisAlignment:
      CrossAxisAlignment.start,
      children: [
        Text(
          'CHOOSE A FEELING',
          style:
          AppTextTheme.labelSmall.copyWith(
            fontSize: 9,
            letterSpacing: 1.2,
            fontWeight: FontWeight.w700,
            color: AppColors.primary,
          ),
        ),

        const SizedBox(height: 12),

        GridView.builder(
          shrinkWrap: true,
          physics:
          const NeverScrollableScrollPhysics(),
          itemCount: _moods.length,
          gridDelegate:
          const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 9,
            mainAxisSpacing: 9,
            childAspectRatio: 1.05,
          ),
          itemBuilder: (context, index) {
            final mood = _moods[index];

            final selected =
                _selectedMood == mood.title;

            return _MoodCard(
              mood: mood,
              selected: selected,
              onTap: () {
                setState(() {
                  _selectedMood = mood.title;
                });
              },
            );
          },
        ),
      ],
    );
  }

  // ==========================================================
  // NOTE
  // ==========================================================

  Widget _buildNoteSection() {
    return Column(
      crossAxisAlignment:
      CrossAxisAlignment.start,
      children: [
        Text(
          'A LITTLE NOTE',
          style:
          AppTextTheme.labelSmall.copyWith(
            fontSize: 9,
            letterSpacing: 1.2,
            fontWeight: FontWeight.w700,
            color: AppColors.primary,
          ),
        ),

        const SizedBox(height: 10),

        Container(
          decoration: BoxDecoration(
            color: Colors.white
                .withValues(alpha: 0.82),
            borderRadius:
            BorderRadius.circular(20),
            border: Border.all(
              color: AppColors.outlineVariant
                  .withValues(alpha: 0.65),
            ),
          ),
          child: TextField(
            controller: _noteController,
            minLines: 4,
            maxLines: 6,
            onChanged: (_) => setState(() {}),
            textCapitalization:
            TextCapitalization.sentences,
            style:
            AppTextTheme.bodyMedium.copyWith(
              fontSize: 13,
              color: AppColors.textPrimary,
            ),
            decoration:
            const InputDecoration(
              hintText:
              'Tell your love what is on your mind...',
              border: InputBorder.none,
              contentPadding:
              EdgeInsets.all(16),
            ),
          ),
        ),
      ],
    );
  }

  // ==========================================================
  // PARTNER
  // ==========================================================

  Widget _buildPartnerCard() {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: const Color(0xFFFCE4EC)
            .withValues(alpha: 0.55),
        borderRadius:
        BorderRadius.circular(18),
        border: Border.all(
          color: AppColors.primaryContainer
              .withValues(alpha: 0.45),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration:
            const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.favorite_rounded,
              size: 18,
              color: AppColors.primary,
            ),
          ),

          const SizedBox(width: 11),

          Expanded(
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [
                Text(
                  'Share with my love',
                  style:
                  AppTextTheme.labelLarge
                      .copyWith(
                    fontSize: 12,
                    fontWeight:
                    FontWeight.w600,
                  ),
                ),

                const SizedBox(height: 3),

                Text(
                  'They will receive a private notification.',
                  style:
                  AppTextTheme.labelSmall
                      .copyWith(
                    fontSize: 9,
                    color:
                    AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),

          Switch.adaptive(
            value: _shareWithPartner,
            onChanged: (value) {
              setState(() {
                _shareWithPartner = value;
              });
            },
          ),
        ],
      ),
    );
  }

  // ==========================================================
  // PREVIEW
  // ==========================================================

  Widget _buildPreview() {
    if (!_canShare) {
      return const SizedBox.shrink();
    }

    final mood = _moods.cast<_MoodOption?>().firstWhere(
          (item) =>
      item?.title == _selectedMood,
      orElse: () => null,
    );

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white
            .withValues(alpha: 0.75),
        borderRadius:
        BorderRadius.circular(18),
        border: Border.all(
          color: AppColors.outlineVariant
              .withValues(alpha: 0.5),
        ),
      ),
      child: Column(
        crossAxisAlignment:
        CrossAxisAlignment.start,
        children: [
          Text(
            'YOUR LITTLE UPDATE',
            style:
            AppTextTheme.labelSmall.copyWith(
              fontSize: 8,
              letterSpacing: 1.1,
              fontWeight: FontWeight.w700,
              color: AppColors.textSecondary,
            ),
          ),

          const SizedBox(height: 11),

          Row(
            crossAxisAlignment:
            CrossAxisAlignment.start,
            children: [
              if (mood != null) ...[
                Text(
                  mood.emoji,
                  style: const TextStyle(
                    fontSize: 26,
                  ),
                ),

                const SizedBox(width: 10),
              ],

              Expanded(
                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  children: [
                    if (_selectedMood != null)
                      Text(
                        'Feeling $_selectedMood',
                        style: AppTextTheme
                            .labelLarge
                            .copyWith(
                          fontSize: 12,
                          fontWeight:
                          FontWeight.w600,
                        ),
                      ),

                    if (_noteController.text
                        .trim()
                        .isNotEmpty) ...[
                      const SizedBox(height: 4),

                      Text(
                        _noteController.text
                            .trim(),
                        style: AppTextTheme
                            .bodyMedium
                            .copyWith(
                          fontSize: 10,
                          height: 1.4,
                          color: AppColors
                              .textSecondary,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ==========================================================
  // SHARE BUTTON
  // ==========================================================

  Widget _buildShareButton() {
    final enabled = _canShare;

    return SizedBox(
      width: double.infinity,
      height: 54,
      child: ElevatedButton.icon(
        onPressed: enabled
            ? _shareFeeling
            : null,
        icon: const Icon(
          Icons.favorite_rounded,
          size: 17,
        ),
        label: const Text(
          'Share with my love',
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor:
          AppColors.primary,
          foregroundColor:
          Colors.white,
          disabledBackgroundColor:
          AppColors.outlineVariant,
          disabledForegroundColor:
          AppColors.textDisabled,
          elevation: 0,
          shape:
          RoundedRectangleBorder(
            borderRadius:
            BorderRadius.circular(999),
          ),
        ),
      ),
    );
  }

  // ==========================================================
  // SHARE
  // ==========================================================

  void _shareFeeling() {
    // TODO:
    // 1. Save today's feeling
    // 2. Save note
    // 3. Send notification to partner
    // 4. Navigate back

    ScaffoldMessenger.of(context)
        .showSnackBar(
      const SnackBar(
        content: Text(
          'Your little update was shared ❤️',
        ),
      ),
    );

    context.pop();
  }

  // ==========================================================
  // PRIVACY
  // ==========================================================

  Widget _buildPrivacy() {
    return Row(
      mainAxisAlignment:
      MainAxisAlignment.center,
      children: [
        Icon(
          Icons.lock_outline_rounded,
          size: 13,
          color: AppColors.textSecondary
              .withValues(alpha: 0.7),
        ),

        const SizedBox(width: 6),

        Text(
          'Only you and your love can see this.',
          style:
          AppTextTheme.labelSmall.copyWith(
            fontSize: 9,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }
}

class _MoodOption {
  const _MoodOption({
    required this.emoji,
    required this.title,
    required this.subtitle,
    required this.background,
  });

  final String emoji;
  final String title;
  final String subtitle;
  final Color background;
}


class _MoodCard extends StatelessWidget {
  const _MoodCard({
    required this.mood,
    required this.selected,
    required this.onTap,
  });

  final _MoodOption mood;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius:
        BorderRadius.circular(18),
        child: Ink(
          decoration: BoxDecoration(
            color: mood.background,
            borderRadius:
            BorderRadius.circular(18),
            border: Border.all(
              color: selected
                  ? AppColors.primary
                  : Colors.transparent,
              width: selected ? 1.5 : 0,
            ),
            boxShadow: selected
                ? [
              BoxShadow(
                color: AppColors.primary
                    .withValues(alpha: 0.12),
                blurRadius: 12,
                offset:
                const Offset(0, 5),
              ),
            ]
                : null,
          ),
          child: Stack(
            children: [
              Center(
                child: Column(
                  mainAxisAlignment:
                  MainAxisAlignment.center,
                  children: [
                    Text(
                      mood.emoji,
                      style: const TextStyle(
                        fontSize: 29,
                      ),
                    ),

                    const SizedBox(height: 6),

                    Text(
                      mood.title,
                      style: AppTextTheme
                          .labelLarge
                          .copyWith(
                        fontSize: 10,
                        fontWeight:
                        FontWeight.w600,
                      ),
                    ),

                    const SizedBox(height: 2),

                    Text(
                      mood.subtitle,
                      textAlign:
                      TextAlign.center,
                      style: AppTextTheme
                          .labelSmall
                          .copyWith(
                        fontSize: 7,
                        color: AppColors
                            .textSecondary,
                      ),
                    ),
                  ],
                ),
              ),

              if (selected)
                const Positioned(
                  top: 8,
                  right: 8,
                  child: Icon(
                    Icons.check_circle_rounded,
                    size: 16,
                    color:
                    AppColors.primary,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
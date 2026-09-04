import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../common/widgets/app_main_button.dart';
import '../../../core/config/routes/router.dart';
import '../../../core/config/theme/app_colors.dart';
import '../../../core/config/theme/app_text_theme.dart';

class AddSymptomsScreen extends StatefulWidget {
  const AddSymptomsScreen({
    super.key,
    this.initialDate,
  });

  final DateTime? initialDate;

  @override
  State<AddSymptomsScreen> createState() =>
      _AddSymptomsScreenState();
}

class _AddSymptomsScreenState
    extends State<AddSymptomsScreen> {
  late DateTime _selectedDate;

  final Set<String> _selectedSymptoms = {};

  int _intensity = 3;

  final TextEditingController _notesController =
  TextEditingController();

  @override
  void initState() {
    super.initState();

    _selectedDate =
        widget.initialDate ?? DateTime.now();
  }

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  static const List<_SymptomItem> _symptoms = [
    _SymptomItem(
      name: 'Cramps',
      icon: Icons.blur_circular_outlined,
    ),
    _SymptomItem(
      name: 'Headache',
      icon: Icons.psychology_outlined,
    ),
    _SymptomItem(
      name: 'Bloating',
      icon: Icons.circle_outlined,
    ),
    _SymptomItem(
      name: 'Fatigue',
      icon: Icons.battery_2_bar_outlined,
    ),
    _SymptomItem(
      name: 'Nausea',
      icon: Icons.sick_outlined,
    ),
    _SymptomItem(
      name: 'Backache',
      icon: Icons.accessibility_new_outlined,
    ),
    _SymptomItem(
      name: 'Mood Swings',
      icon: Icons.mood_outlined,
    ),
    _SymptomItem(
      name: 'Tenderness',
      icon: Icons.favorite_border_rounded,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            _buildTopBar(),

            Expanded(
              child: Stack(
                children: [
                  _buildBackground(),

                  SingleChildScrollView(
                    physics:
                    const BouncingScrollPhysics(),
                    padding: const EdgeInsets.fromLTRB(
                      20,
                      8,
                      20,
                      40,
                    ),
                    child: Column(
                      crossAxisAlignment:
                      CrossAxisAlignment.start,
                      children: [
                        _buildHeader(),

                        const SizedBox(height: 24),

                        _buildSymptomsSection(),

                        const SizedBox(height: 16),

                        _buildIntensitySection(),

                        const SizedBox(height: 16),

                        _buildNotesSection(),

                        const SizedBox(height: 18),

                        _buildPrivacyHint(),

                        const SizedBox(height: 26),

                        _buildSaveButton(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ==========================================================
  // BACKGROUND
  // ==========================================================

  Widget _buildBackground() {
    return IgnorePointer(
      child: Stack(
        children: [
          Positioned(
            top: -100,
            right: -80,
            child: Container(
              width: 220,
              height: 220,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFFFCE4EC)
                    .withValues(alpha: 0.50),
              ),
            ),
          ),

          Positioned(
            top: 350,
            left: -130,
            child: Container(
              width: 230,
              height: 230,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFFE8B4B8)
                    .withValues(alpha: 0.08),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================================
  // TOP BAR
  // ==========================================================

  Widget _buildTopBar() {
    return SizedBox(
      height: 60,
      child: Row(
        children: [
          const SizedBox(width: 8),

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
              'Daily symptoms',
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
        Row(
          children: [
            Container(
              width: 42,
              height: 42,
              decoration:
              const BoxDecoration(
                color: Color(0xFFFCE4EC),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.favorite_border_rounded,
                size: 21,
                color: AppColors.primary,
              ),
            ),

            const SizedBox(width: 12),

            Expanded(
              child: Column(
                crossAxisAlignment:
                CrossAxisAlignment.start,
                children: [
                  Text(
                    'Today • ${_formatDate(_selectedDate)}',
                    style: AppTextTheme.labelSmall
                        .copyWith(
                      fontSize: 9,
                      fontWeight:
                      FontWeight.w600,
                      color:
                      AppColors.textSecondary,
                    ),
                  ),

                  const SizedBox(height: 3),

                  Text(
                    'How are you feeling?',
                    style: AppTextTheme
                        .headlineMedium
                        .copyWith(
                      fontFamily:
                      'Playfair Display',
                      fontSize: 24,
                      fontWeight:
                      FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),

        const SizedBox(height: 10),

        Padding(
          padding:
          const EdgeInsets.only(left: 54),
          child: Text(
            'A little check-in helps SIMI understand '
                'your rhythm over time.',
            style:
            AppTextTheme.bodySmall.copyWith(
              color:
              AppColors.textSecondary,
              height: 1.45,
            ),
          ),
        ),
      ],
    );
  }

  // ==========================================================
  // SYMPTOMS
  // ==========================================================

  Widget _buildSymptomsSection() {
    return _SoftCard(
      child: Column(
        crossAxisAlignment:
        CrossAxisAlignment.start,
        children: [
          _SectionTitle(
            title: 'Symptoms',
            subtitle:
            'Select everything you noticed today.',
          ),

          const SizedBox(height: 16),

          Wrap(
            spacing: 8,
            runSpacing: 9,
            children: [
              ..._symptoms.map(
                    (symptom) => _SymptomChip(
                  item: symptom,
                  selected: _selectedSymptoms
                      .contains(symptom.name),
                  onTap: () {
                    setState(() {
                      if (_selectedSymptoms
                          .contains(symptom.name)) {
                        _selectedSymptoms
                            .remove(symptom.name);
                      } else {
                        _selectedSymptoms
                            .add(symptom.name);
                      }
                    });
                  },
                ),
              ),

              _MoreSymptomsChip(
                onTap: _showMoreSymptoms,
              ),
            ],
          ),

          if (_selectedSymptoms.isNotEmpty) ...[
            const SizedBox(height: 16),

            AnimatedContainer(
              duration:
              const Duration(milliseconds: 250),
              padding:
              const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 9,
              ),
              decoration: BoxDecoration(
                color:
                const Color(0xFFFFF5F6),
                borderRadius:
                BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.check_circle_outline_rounded,
                    size: 16,
                    color:
                    AppColors.primary,
                  ),

                  const SizedBox(width: 7),

                  Expanded(
                    child: Text(
                      '${_selectedSymptoms.length} '
                          'symptom${_selectedSymptoms.length == 1 ? '' : 's'} selected',
                      style: AppTextTheme.labelSmall
                          .copyWith(
                        fontSize: 9,
                        fontWeight:
                        FontWeight.w600,
                        color:
                        AppColors.primary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  // ==========================================================
  // INTENSITY
  // ==========================================================

  Widget _buildIntensitySection() {
    return _SoftCard(
      child: Column(
        crossAxisAlignment:
        CrossAxisAlignment.start,
        children: [
          _SectionTitle(
            title: 'Overall intensity',
            subtitle:
            'How noticeable did your symptoms feel?',
          ),

          const SizedBox(height: 18),

          Row(
            mainAxisAlignment:
            MainAxisAlignment.spaceBetween,
            children: List.generate(
              5,
                  (index) {
                final value = index + 1;

                return _IntensityButton(
                  value: value,
                  selected:
                  _intensity == value,
                  onTap: () {
                    setState(() {
                      _intensity = value;
                    });
                  },
                );
              },
            ),
          ),

          const SizedBox(height: 9),

          Row(
            mainAxisAlignment:
            MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Mild',
                style:
                AppTextTheme.labelSmall.copyWith(
                  fontSize: 8,
                  color:
                  AppColors.textSecondary,
                ),
              ),
              Text(
                _intensityLabel,
                style:
                AppTextTheme.labelSmall.copyWith(
                  fontSize: 9,
                  fontWeight:
                  FontWeight.w600,
                  color:
                  AppColors.primary,
                ),
              ),
              Text(
                'Severe',
                style:
                AppTextTheme.labelSmall.copyWith(
                  fontSize: 8,
                  color:
                  AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String get _intensityLabel {
    switch (_intensity) {
      case 1:
        return 'Very mild';
      case 2:
        return 'Mild';
      case 3:
        return 'Moderate';
      case 4:
        return 'Strong';
      case 5:
        return 'Very strong';
      default:
        return 'Moderate';
    }
  }

  // ==========================================================
  // NOTES
  // ==========================================================

  Widget _buildNotesSection() {
    return _SoftCard(
      child: Column(
        crossAxisAlignment:
        CrossAxisAlignment.start,
        children: [
          _SectionTitle(
            title: 'Personal note',
            subtitle:
            'Anything else you want to remember?',
          ),

          const SizedBox(height: 14),

          TextField(
            controller: _notesController,
            minLines: 4,
            maxLines: 6,
            textCapitalization:
            TextCapitalization.sentences,
            style:
            AppTextTheme.bodyMedium.copyWith(
              fontSize: 12,
              color:
              AppColors.textPrimary,
            ),
            decoration: InputDecoration(
              hintText:
              'Write a little note for your future self...',
              hintStyle:
              AppTextTheme.bodySmall.copyWith(
                fontSize: 11,
                color:
                AppColors.textDisabled,
              ),
              filled: true,
              fillColor:
              const Color(0xFFFFFAFA),
              contentPadding:
              const EdgeInsets.all(14),
              border: OutlineInputBorder(
                borderRadius:
                BorderRadius.circular(14),
                borderSide: BorderSide(
                  color: AppColors
                      .outlineVariant
                      .withValues(alpha: 0.7),
                ),
              ),
              enabledBorder:
              OutlineInputBorder(
                borderRadius:
                BorderRadius.circular(14),
                borderSide: BorderSide(
                  color: AppColors
                      .outlineVariant
                      .withValues(alpha: 0.7),
                ),
              ),
              focusedBorder:
              OutlineInputBorder(
                borderRadius:
                BorderRadius.circular(14),
                borderSide:
                const BorderSide(
                  color:
                  AppColors.primary,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================================
  // PRIVACY
  // ==========================================================

  Widget _buildPrivacyHint() {
    return Row(
      mainAxisAlignment:
      MainAxisAlignment.center,
      children: [
        Icon(
          Icons.lock_outline_rounded,
          size: 13,
          color: AppColors.textSecondary
              .withValues(alpha: 0.8),
        ),

        const SizedBox(width: 6),

        Text(
          'Private to you and your SIMI space',
          style:
          AppTextTheme.labelSmall.copyWith(
            fontSize: 9,
            color:
            AppColors.textSecondary,
          ),
        ),
      ],
    );
  }

  // ==========================================================
  // SAVE
  // ==========================================================

  Widget _buildSaveButton() {
    return SizedBox(
      width: double.infinity,
      child: AppMainButton(
        text: 'Save Symptoms',
        onPressed: _saveSymptoms,
        height: 52,
        borderRadius: 8,
      ),
    );
  }

  void _saveSymptoms() {
    context.push(AppRoutes.symptomsSaved);
  }

  // ==========================================================
  // MORE SYMPTOMS
  // ==========================================================

  void _showMoreSymptoms() {
    final additional = [
      'Dizziness',
      'Acne',
      'Chills',
      'Constipation',
      'Diarrhea',
      'Food cravings',
      'Insomnia',
      'Low energy',
    ];

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          padding:
          const EdgeInsets.fromLTRB(
            20,
            12,
            20,
            30,
          ),
          decoration:
          const BoxDecoration(
            color: AppColors.surface,
            borderRadius:
            BorderRadius.vertical(
              top: Radius.circular(28),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color:
                  AppColors.outlineVariant,
                  borderRadius:
                  BorderRadius.circular(999),
                ),
              ),

              const SizedBox(height: 20),

              Text(
                'More symptoms',
                style: AppTextTheme
                    .headlineSmall
                    .copyWith(
                  fontFamily:
                  'Playfair Display',
                  fontSize: 20,
                  fontWeight:
                  FontWeight.w600,
                ),
              ),

              const SizedBox(height: 16),

              Wrap(
                spacing: 8,
                runSpacing: 9,
                children: additional.map(
                      (symptom) {
                    final selected =
                    _selectedSymptoms
                        .contains(symptom);

                    return _SimpleChoiceChip(
                      label: symptom,
                      selected: selected,
                      onTap: () {
                        setState(() {
                          if (selected) {
                            _selectedSymptoms
                                .remove(symptom);
                          } else {
                            _selectedSymptoms
                                .add(symptom);
                          }
                        });

                        Navigator.pop(context);
                      },
                    );
                  },
                ).toList(),
              ),
            ],
          ),
        );
      },
    );
  }

  String _formatDate(DateTime date) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];

    return '${months[date.month - 1]} ${date.day}';
  }
}

class _SoftCard extends StatelessWidget {
  const _SoftCard({
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(
          alpha: 0.84,
        ),
        borderRadius:
        BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.outlineVariant
              .withValues(alpha: 0.65),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(
              alpha: 0.025,
            ),
            blurRadius: 15,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: child,
    );
  }
}


class _SectionTitle extends StatelessWidget {
  const _SectionTitle({
    required this.title,
    required this.subtitle,
  });

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment:
      CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style:
          AppTextTheme.labelLarge.copyWith(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 3),
        Text(
          subtitle,
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

class _SymptomItem {
  const _SymptomItem({
    required this.name,
    required this.icon,
  });

  final String name;
  final IconData icon;
}

class _SymptomChip extends StatelessWidget {
  const _SymptomChip({
    required this.item,
    required this.selected,
    required this.onTap,
  });

  final _SymptomItem item;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration:
      const Duration(milliseconds: 180),
      curve: Curves.easeOut,
      decoration: BoxDecoration(
        color: selected
            ? AppColors.primary
            : const Color(0xFFFFFAFA),
        borderRadius:
        BorderRadius.circular(999),
        border: Border.all(
          color: selected
              ? AppColors.primary
              : AppColors.outlineVariant,
        ),
        boxShadow: selected
            ? [
          BoxShadow(
            color: AppColors.primary
                .withValues(alpha: 0.16),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ]
            : null,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius:
          BorderRadius.circular(999),
          child: Padding(
            padding:
            const EdgeInsets.symmetric(
              horizontal: 11,
              vertical: 8,
            ),
            child: Row(
              mainAxisSize:
              MainAxisSize.min,
              children: [
                Icon(
                  selected
                      ? Icons.check_rounded
                      : item.icon,
                  size: 13,
                  color: selected
                      ? Colors.white
                      : AppColors.primary,
                ),

                const SizedBox(width: 5),

                Text(
                  item.name,
                  style: AppTextTheme.labelSmall
                      .copyWith(
                    fontSize: 10,
                    fontWeight:
                    FontWeight.w500,
                    color: selected
                        ? Colors.white
                        : AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}


class _MoreSymptomsChip
    extends StatelessWidget {
  const _MoreSymptomsChip({
    required this.onTap,
  });

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius:
        BorderRadius.circular(999),
        child: Container(
          padding:
          const EdgeInsets.symmetric(
            horizontal: 11,
            vertical: 8,
          ),
          decoration: BoxDecoration(
            color: const Color(0xFFF8F3F2),
            borderRadius:
            BorderRadius.circular(999),
            border: Border.all(
              color: AppColors.outlineVariant,
            ),
          ),
          child: Row(
            mainAxisSize:
            MainAxisSize.min,
            children: [
              const Icon(
                Icons.add_rounded,
                size: 14,
                color: AppColors.primary,
              ),
              const SizedBox(width: 4),
              Text(
                'More',
                style: AppTextTheme.labelSmall
                    .copyWith(
                  fontSize: 10,
                  fontWeight:
                  FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


class _IntensityButton
    extends StatelessWidget {
  const _IntensityButton({
    required this.value,
    required this.selected,
    required this.onTap,
  });

  final int value;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration:
        const Duration(milliseconds: 180),
        width: 42,
        height: 42,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: selected
              ? AppColors.primary
              : Colors.white,
          border: Border.all(
            color: selected
                ? AppColors.primary
                : AppColors.outlineVariant,
          ),
          boxShadow: selected
              ? [
            BoxShadow(
              color: AppColors.primary
                  .withValues(alpha: 0.18),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ]
              : null,
        ),
        child: Center(
          child: Text(
            '$value',
            style:
            AppTextTheme.labelLarge.copyWith(
              fontSize: 11,
              fontWeight:
              FontWeight.w600,
              color: selected
                  ? Colors.white
                  : AppColors.textPrimary,
            ),
          ),
        ),
      ),
    );
  }
}

class _SimpleChoiceChip
    extends StatelessWidget {
  const _SimpleChoiceChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius:
      BorderRadius.circular(999),
      child: Container(
        padding:
        const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 9,
        ),
        decoration: BoxDecoration(
          color: selected
              ? AppColors.primary
              : Colors.white,
          borderRadius:
          BorderRadius.circular(999),
          border: Border.all(
            color: selected
                ? AppColors.primary
                : AppColors.outlineVariant,
          ),
        ),
        child: Text(
          label,
          style:
          AppTextTheme.labelSmall.copyWith(
            fontSize: 10,
            color: selected
                ? Colors.white
                : AppColors.textPrimary,
          ),
        ),
      ),
    );
  }
}
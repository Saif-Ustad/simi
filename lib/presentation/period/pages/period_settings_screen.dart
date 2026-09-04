import 'package:flutter/material.dart';

import '../../../core/config/theme/app_colors.dart';
import '../../../core/config/theme/app_text_theme.dart';
import 'package:go_router/go_router.dart';

import '../../../common/widgets/app_main_button.dart';

class PeriodSettingsScreen extends StatefulWidget {
  const PeriodSettingsScreen({
    super.key,
    this.lastPeriodDate,
    this.cycleLength = 28,
    this.periodLength = 5,
  });

  final DateTime? lastPeriodDate;
  final int cycleLength;
  final int periodLength;

  @override
  State<PeriodSettingsScreen> createState() =>
      _PeriodSettingsScreenState();
}

class _PeriodSettingsScreenState
    extends State<PeriodSettingsScreen> {
  late DateTime? _lastPeriodDate;
  late int _cycleLength;
  late int _periodLength;

  bool _smartPredictions = true;

  bool _periodApproachingReminder = true;
  bool _expectedPeriodReminder = true;
  bool _dailySymptomsReminder = false;

  bool _appLock = false;

  TimeOfDay _reminderTime =
  const TimeOfDay(hour: 9, minute: 0);

  @override
  void initState() {
    super.initState();

    _lastPeriodDate = widget.lastPeriodDate;
    _cycleLength = widget.cycleLength;
    _periodLength = widget.periodLength;
  }

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

                        _buildCycleDetails(),

                        const SizedBox(height: 16),

                        _buildPredictionSection(),

                        const SizedBox(height: 16),

                        _buildReminderSection(),

                        const SizedBox(height: 16),

                        _buildTrackingSection(),

                        const SizedBox(height: 16),

                        _buildPrivacySection(),

                        const SizedBox(height: 28),

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
                    .withValues(alpha: 0.45),
              ),
            ),
          ),

          Positioned(
            top: 300,
            left: -120,
            child: Container(
              width: 200,
              height: 200,
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
              'Period settings',
              textAlign: TextAlign.center,
              style: AppTextTheme.headlineSmall.copyWith(
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
          'Make it yours.',
          style: AppTextTheme.headlineMedium.copyWith(
            fontFamily: 'Playfair Display',
            fontSize: 26,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),

        const SizedBox(height: 7),

        Text(
          'Manage your cycle, reminders and '
              'privacy preferences in one place.',
          style: AppTextTheme.bodyMedium.copyWith(
            color: AppColors.textSecondary,
            height: 1.5,
          ),
        ),
      ],
    );
  }

  // ==========================================================
  // CYCLE DETAILS
  // ==========================================================

  Widget _buildCycleDetails() {
    return _SettingsSection(
      label: 'CYCLE DETAILS',
      child: Column(
        children: [
          _SettingsRow(
            icon: Icons.calendar_month_outlined,
            title: 'Last period started',
            subtitle: _lastPeriodDate == null
                ? 'Not added yet'
                : _formatDate(_lastPeriodDate!),
            trailing:
            Icons.chevron_right_rounded,
            onTap: _pickLastPeriodDate,
          ),

          _divider(),

          _SettingsRow(
            icon: Icons.sync_rounded,
            title: 'Average cycle length',
            subtitle:
            'Used to predict your next period',
            value: '$_cycleLength days',
            trailing:
            Icons.chevron_right_rounded,
            onTap: () => _showCycleLengthPicker(),
          ),

          _divider(),

          _SettingsRow(
            icon: Icons.water_drop_outlined,
            title: 'Average period length',
            subtitle:
            'Typical duration of bleeding',
            value: '$_periodLength days',
            trailing:
            Icons.chevron_right_rounded,
            onTap: () => _showPeriodLengthPicker(),
          ),
        ],
      ),
    );
  }

  // ==========================================================
  // PREDICTIONS
  // ==========================================================

  Widget _buildPredictionSection() {
    return _SettingsSection(
      label: 'PREDICTIONS',
      child: _SettingsToggleRow(
        icon: Icons.auto_awesome_outlined,
        title: 'Smart predictions',
        subtitle:
        'Use your past data to improve accuracy.',
        value: _smartPredictions,
        onChanged: (value) {
          setState(() {
            _smartPredictions = value;
          });
        },
      ),
    );
  }

  // ==========================================================
  // REMINDERS
  // ==========================================================

  Widget _buildReminderSection() {
    return _SettingsSection(
      label: 'REMINDERS',
      child: Column(
        children: [
          _SettingsToggleRow(
            icon: Icons.notifications_none_rounded,
            title: 'Period approaching',
            subtitle:
            'Get notified a few days before.',
            value: _periodApproachingReminder,
            onChanged: (value) {
              setState(() {
                _periodApproachingReminder =
                    value;
              });
            },
          ),

          _divider(),

          _SettingsToggleRow(
            icon: Icons.event_available_outlined,
            title: 'Expected period',
            subtitle:
            'A gentle nudge on the expected day.',
            value: _expectedPeriodReminder,
            onChanged: (value) {
              setState(() {
                _expectedPeriodReminder =
                    value;
              });
            },
          ),

          _divider(),

          _SettingsToggleRow(
            icon: Icons.favorite_border_rounded,
            title: 'Daily symptoms',
            subtitle:
            'Remember to log how you are feeling.',
            value: _dailySymptomsReminder,
            onChanged: (value) {
              setState(() {
                _dailySymptomsReminder =
                    value;
              });
            },
          ),

          _divider(),

          _SettingsRow(
            icon: Icons.schedule_outlined,
            title: 'Reminder time',
            subtitle:
            'When should SIMI remind you?',
            value: _formatTime(_reminderTime),
            trailing:
            Icons.chevron_right_rounded,
            onTap: _pickReminderTime,
          ),
        ],
      ),
    );
  }

  // ==========================================================
  // TRACKING
  // ==========================================================

  Widget _buildTrackingSection() {
    return _SettingsSection(
      label: 'TRACKING',
      child: _SettingsRow(
        icon: Icons.tune_rounded,
        title: 'Tracked symptoms',
        subtitle:
        'Choose what you want to log daily.',
        trailing:
        Icons.chevron_right_rounded,
        onTap: _showTrackedSymptoms,
      ),
    );
  }

  // ==========================================================
  // PRIVACY
  // ==========================================================

  Widget _buildPrivacySection() {
    return _SettingsSection(
      label: 'PRIVACY & DATA',
      child: Column(
        children: [
          _SettingsToggleRow(
            icon: Icons.lock_outline_rounded,
            title: 'App lock',
            subtitle:
            'Require Face ID / PIN to open SIMI.',
            value: _appLock,
            onChanged: (value) {
              setState(() {
                _appLock = value;
              });
            },
          ),

          const SizedBox(height: 14),

          _DeleteDataButton(),

          // Space after delete button
          const SizedBox(height: 8),
        ],
      ),
    );
  }
  // ==========================================================
  // SAVE
  // ==========================================================

  Widget _buildSaveButton() {
    return SizedBox(
      width: double.infinity,
      child: AppMainButton(
        text: 'Save Preferences',
        onPressed: _saveSettings,
        height: 52,
        borderRadius: 8,
      ),
    );
  }

  // ==========================================================
  // DATE PICKER
  // ==========================================================

  Future<void> _pickLastPeriodDate() async {
    final now = DateTime.now();

    final picked = await showDatePicker(
      context: context,
      initialDate:
      _lastPeriodDate ?? now,
      firstDate: DateTime(
        now.year - 2,
        now.month,
        now.day,
      ),
      lastDate: now,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme:
            Theme.of(context).colorScheme.copyWith(
              primary: AppColors.primary,
              surface: AppColors.surface,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _lastPeriodDate = picked;
      });
    }
  }

  // ==========================================================
  // CYCLE LENGTH PICKER
  // ==========================================================

  void _showCycleLengthPicker() {
    _showNumberPicker(
      title: 'Average cycle length',
      currentValue: _cycleLength,
      min: 21,
      max: 40,
      suffix: 'days',
      onSelected: (value) {
        setState(() {
          _cycleLength = value;
        });
      },
    );
  }

  // ==========================================================
  // PERIOD LENGTH PICKER
  // ==========================================================

  void _showPeriodLengthPicker() {
    _showNumberPicker(
      title: 'Average period length',
      currentValue: _periodLength,
      min: 2,
      max: 10,
      suffix: 'days',
      onSelected: (value) {
        setState(() {
          _periodLength = value;
        });
      },
    );
  }

  // ==========================================================
  // NUMBER PICKER
  // ==========================================================

  void _showNumberPicker({
    required String title,
    required int currentValue,
    required int min,
    required int max,
    required String suffix,
    required ValueChanged<int> onSelected,
  }) {
    int selected = currentValue;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            return Container(
              padding: const EdgeInsets.fromLTRB(
                20,
                10,
                20,
                30,
              ),
              decoration: const BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.vertical(
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

                  const SizedBox(height: 22),

                  Text(
                    title,
                    style:
                    AppTextTheme.headlineSmall.copyWith(
                      fontFamily:
                      'Playfair Display',
                      fontSize: 20,
                      fontWeight:
                      FontWeight.w600,
                    ),
                  ),

                  const SizedBox(height: 20),

                  Row(
                    mainAxisAlignment:
                    MainAxisAlignment.center,
                    children: [
                      _RoundPickerButton(
                        icon: Icons.remove_rounded,
                        enabled: selected > min,
                        onTap: () {
                          if (selected > min) {
                            setSheetState(() {
                              selected--;
                            });
                          }
                        },
                      ),

                      const SizedBox(width: 24),

                      Column(
                        children: [
                          Text(
                            '$selected',
                            style: AppTextTheme
                                .headlineMedium
                                .copyWith(
                              fontFamily:
                              'Playfair Display',
                              fontSize: 34,
                              fontWeight:
                              FontWeight.w600,
                              color:
                              AppColors.primary,
                            ),
                          ),
                          Text(
                            suffix,
                            style:
                            AppTextTheme.labelSmall,
                          ),
                        ],
                      ),

                      const SizedBox(width: 24),

                      _RoundPickerButton(
                        icon: Icons.add_rounded,
                        enabled: selected < max,
                        onTap: () {
                          if (selected < max) {
                            setSheetState(() {
                              selected++;
                            });
                          }
                        },
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  SizedBox(
                    width: double.infinity,
                    child: AppMainButton(
                      text: 'Done',
                      onPressed: () {
                        onSelected(selected);
                        Navigator.pop(context);
                      },
                      height: 50,
                      borderRadius: 8,
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  // ==========================================================
  // REMINDER TIME
  // ==========================================================

  Future<void> _pickReminderTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _reminderTime,
    );

    if (picked != null) {
      setState(() {
        _reminderTime = picked;
      });
    }
  }

  // ==========================================================
  // TRACKED SYMPTOMS
  // ==========================================================

  void _showTrackedSymptoms() {
    final symptoms = [
      'Cramps',
      'Headache',
      'Bloating',
      'Mood',
      'Energy',
      'Back pain',
      'Tender breasts',
    ];

    final selected = <String>{
      'Cramps',
      'Mood',
      'Energy',
    };

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            return Container(
              padding: const EdgeInsets.fromLTRB(
                20,
                12,
                20,
                30,
              ),
              decoration: const BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.vertical(
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
                    'Tracked symptoms',
                    style:
                    AppTextTheme.headlineSmall.copyWith(
                      fontFamily:
                      'Playfair Display',
                      fontSize: 20,
                      fontWeight:
                      FontWeight.w600,
                    ),
                  ),

                  const SizedBox(height: 6),

                  Text(
                    'Choose what you would like '
                        'to see in your daily journal.',
                    textAlign: TextAlign.center,
                    style:
                    AppTextTheme.bodySmall.copyWith(
                      color:
                      AppColors.textSecondary,
                    ),
                  ),

                  const SizedBox(height: 18),

                  ...symptoms.map(
                        (symptom) {
                      final isSelected =
                      selected.contains(
                        symptom,
                      );

                      return CheckboxListTile(
                        value: isSelected,
                        onChanged: (value) {
                          setSheetState(() {
                            if (value == true) {
                              selected.add(
                                symptom,
                              );
                            } else {
                              selected.remove(
                                symptom,
                              );
                            }
                          });
                        },
                        activeColor:
                        AppColors.primary,
                        checkboxShape:
                        RoundedRectangleBorder(
                          borderRadius:
                          BorderRadius.circular(6),
                        ),
                        title: Text(
                          symptom,
                          style: AppTextTheme
                              .labelLarge
                              .copyWith(
                            fontSize: 13,
                          ),
                        ),
                        contentPadding:
                        EdgeInsets.zero,
                      );
                    },
                  ),

                  const SizedBox(height: 10),

                  SizedBox(
                    width: double.infinity,
                    child: AppMainButton(
                      text: 'Save Symptoms',
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      height: 50,
                      borderRadius: 8,
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  // ==========================================================
  // DELETE DATA
  // ==========================================================

  void _deleteCycleData() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: AppColors.surface,
          title: Text(
            'Delete cycle data?',
            style:
            AppTextTheme.headlineSmall.copyWith(
              fontFamily: 'Playfair Display',
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
          content: Text(
            'This will permanently remove your '
                'period history, symptoms and cycle data.',
            style:
            AppTextTheme.bodyMedium.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () =>
                  Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);

                // TODO:
                // Delete cycle data.
              },
              child: const Text(
                'Delete',
                style: TextStyle(
                  color: Colors.redAccent,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  // ==========================================================
  // SAVE SETTINGS
  // ==========================================================

  void _saveSettings() {
    // TODO:
    // Persist:
    //
    // _lastPeriodDate
    // _cycleLength
    // _periodLength
    // _smartPredictions
    // _periodApproachingReminder
    // _expectedPeriodReminder
    // _dailySymptomsReminder
    // _reminderTime
    // _appLock

    ScaffoldMessenger.of(context)
        .showSnackBar(
      const SnackBar(
        content: Text(
          'Period preferences saved',
        ),
      ),
    );

    context.pop();
  }

  // ==========================================================
  // HELPERS
  // ==========================================================

  Widget _divider() {
    return Divider(
      height: 1,
      color: AppColors.outlineVariant
          .withValues(alpha: 0.45),
    );
  }

  String _formatDate(DateTime date) {
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];

    return '${months[date.month - 1]} '
        '${date.day}, ${date.year}';
  }

  String _formatTime(TimeOfDay time) {
    final hour = time.hourOfPeriod == 0
        ? 12
        : time.hourOfPeriod;

    final minute =
    time.minute.toString().padLeft(2, '0');

    final period =
    time.period == DayPeriod.am ? 'AM' : 'PM';

    return '$hour:$minute $period';
  }
}

class _SettingsSection extends StatelessWidget {
  const _SettingsSection({
    required this.label,
    required this.child,
  });

  final String label;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment:
      CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(
            left: 2,
            bottom: 8,
          ),
          child: Text(
            label,
            style: AppTextTheme.labelSmall.copyWith(
              fontSize: 9,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.15,
              color: AppColors.primary,
            ),
          ),
        ),

        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white.withValues(
              alpha: 0.82,
            ),
            borderRadius:
            BorderRadius.circular(18),
            border: Border.all(
              color: AppColors.outlineVariant
                  .withValues(alpha: 0.65),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(
                  alpha: 0.025,
                ),
                blurRadius: 14,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 4,
            ),
            child: child,
          ),
        ),
      ],
    );
  }
}

// ============================================================
// SETTINGS ROW
// ============================================================

class _SettingsRow extends StatelessWidget {
  const _SettingsRow({
    required this.icon,
    required this.title,
    required this.subtitle,
    this.value,
    this.trailing,
    this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final String? value;
  final IconData? trailing;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius:
        BorderRadius.circular(14),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 13,
            horizontal: 2,
          ),
          child: Row(
            children: [
              Container(
                width: 34,
                height: 34,
                decoration:
                const BoxDecoration(
                  color: Color(0xFFFCE4EC),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  size: 17,
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
                      title,
                      style:
                      AppTextTheme.labelLarge.copyWith(
                        fontSize: 12,
                        fontWeight:
                        FontWeight.w600,
                        color:
                        AppColors.textPrimary,
                      ),
                    ),

                    const SizedBox(height: 3),

                    Text(
                      subtitle,
                      maxLines: 2,
                      overflow:
                      TextOverflow.ellipsis,
                      style:
                      AppTextTheme.labelSmall
                          .copyWith(
                        fontSize: 9,
                        height: 1.3,
                        color:
                        AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),

              if (value != null) ...[
                const SizedBox(width: 8),

                Text(
                  value!,
                  style:
                  AppTextTheme.labelSmall
                      .copyWith(
                    fontSize: 10,
                    fontWeight:
                    FontWeight.w600,
                    color:
                    AppColors.textSecondary,
                  ),
                ),
              ],

              if (trailing != null) ...[
                const SizedBox(width: 5),

                Icon(
                  trailing,
                  size: 18,
                  color:
                  AppColors.textSecondary,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}


// ============================================================
// TOGGLE ROW
// ============================================================

class _SettingsToggleRow
    extends StatelessWidget {
  const _SettingsToggleRow({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 12,
        horizontal: 2,
      ),
      child: Row(
        children: [
          Container(
            width: 34,
            height: 34,
            decoration:
            const BoxDecoration(
              color: Color(0xFFFCE4EC),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              size: 17,
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
                  title,
                  style:
                  AppTextTheme.labelLarge
                      .copyWith(
                    fontSize: 12,
                    fontWeight:
                    FontWeight.w600,
                    color:
                    AppColors.textPrimary,
                  ),
                ),

                const SizedBox(height: 3),

                Text(
                  subtitle,
                  maxLines: 2,
                  overflow:
                  TextOverflow.ellipsis,
                  style:
                  AppTextTheme.labelSmall
                      .copyWith(
                    fontSize: 9,
                    height: 1.3,
                    color:
                    AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 10),

          Switch.adaptive(
            value: value,
            onChanged: onChanged,
            activeTrackColor: AppColors.primary,
            thumbColor: WidgetStatePropertyAll(
              Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}


// ============================================================
// DELETE DATA
// ============================================================

class _DeleteDataButton
    extends StatelessWidget {
  const _DeleteDataButton();

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        final state = context.findAncestorStateOfType<
            _PeriodSettingsScreenState>();

        state?._deleteCycleData();
      },
      borderRadius:
      BorderRadius.circular(12),
      child: Container(
        width: double.infinity,
        padding:
        const EdgeInsets.symmetric(
          vertical: 12,
        ),
        decoration: BoxDecoration(
          color: const Color(0xFFFFF7F7),
          borderRadius:
          BorderRadius.circular(12),
          border: Border.all(
            color: const Color(0xFFF0D5D5),
          ),
        ),
        child: Row(
          mainAxisAlignment:
          MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.delete_outline_rounded,
              size: 16,
              color: Color(0xFFB05C5C),
            ),

            const SizedBox(width: 7),

            Text(
              'Delete all cycle data',
              style:
              AppTextTheme.labelSmall.copyWith(
                fontSize: 10,
                fontWeight:
                FontWeight.w600,
                color:
                const Color(0xFFB05C5C),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


// ============================================================
// ROUND PICKER BUTTON
// ============================================================

class _RoundPickerButton
    extends StatelessWidget {
  const _RoundPickerButton({
    required this.icon,
    required this.enabled,
    required this.onTap,
  });

  final IconData icon;
  final bool enabled;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: enabled
          ? const Color(0xFFFCE4EC)
          : const Color(0xFFF3EFEE),
      shape: const CircleBorder(),
      child: InkWell(
        onTap: enabled ? onTap : null,
        customBorder:
        const CircleBorder(),
        child: SizedBox(
          width: 44,
          height: 44,
          child: Icon(
            icon,
            size: 18,
            color: enabled
                ? AppColors.primary
                : AppColors.textDisabled,
          ),
        ),
      ),
    );
  }
}
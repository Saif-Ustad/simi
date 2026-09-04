import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/config/routes/router.dart';
import '../../../core/config/theme/app_colors.dart';
import '../../../core/config/theme/app_text_theme.dart';

class AddPeriodRecordScreen extends StatefulWidget {
  const AddPeriodRecordScreen({
    super.key,
    this.initialStartDate,
    this.onSave,
  });

  final DateTime? initialStartDate;

  final void Function({
  required DateTime startDate,
  DateTime? endDate,
  required String flowIntensity,
  String? notes,
  })? onSave;

  @override
  State<AddPeriodRecordScreen> createState() =>
      _AddPeriodRecordScreenState();
}

class _AddPeriodRecordScreenState
    extends State<AddPeriodRecordScreen> {
  late DateTime _startDate;

  DateTime? _endDate;

  String _flowIntensity = 'Medium';

  final TextEditingController _notesController =
  TextEditingController();

  @override
  void initState() {
    super.initState();

    _startDate =
        widget.initialStartDate ?? DateTime.now();
  }

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  // ============================================================
  // DATE FORMAT
  // ============================================================

  String _formatDate(DateTime date) {
    return '${date.month.toString().padLeft(2, '0')}/'
        '${date.day.toString().padLeft(2, '0')}/'
        '${date.year}';
  }

  // ============================================================
  // DATE PICKER
  // ============================================================

  Future<void> _selectStartDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _startDate,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF7C5357),
              onPrimary: Colors.white,
              surface: Color(0xFFFFF8F5),
              onSurface: Color(0xFF322F2E),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked == null) return;

    setState(() {
      _startDate = picked;

      // End date cannot be before start date.
      if (_endDate != null &&
          _endDate!.isBefore(_startDate)) {
        _endDate = null;
      }
    });
  }

  Future<void> _selectEndDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _endDate ?? _startDate,
      firstDate: _startDate,
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF7C5357),
              onPrimary: Colors.white,
              surface: Color(0xFFFFF8F5),
              onSurface: Color(0xFF322F2E),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked == null) return;

    setState(() {
      _endDate = picked;
    });
  }

  // ============================================================
  // SAVE
  // ============================================================

  void _savePeriod() {
    // Save the period data first.
    widget.onSave?.call(
      startDate: _startDate,
      endDate: _endDate,
      flowIntensity: _flowIntensity,
      notes: _notesController.text.trim().isEmpty
          ? null
          : _notesController.text.trim(),
    );

    if (!mounted) return;

    // Open the success page.
    context.push(
      AppRoutes.periodSavedSuccess,
      extra: _startDate,
    );
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      body: SafeArea(
        child: Column(
          children: [
            // ====================================================
            // TOP BAR
            // ====================================================

            _buildTopBar(),

            // ====================================================
            // CONTENT
            // ====================================================

            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(
                  16,
                  8,
                  16,
                  32,
                ),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(
                      maxWidth: 448,
                    ),
                    child: _buildCard(),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // TOP BAR
  // ============================================================

  Widget _buildTopBar() {
    return Container(
      width: double.infinity,
      color: AppColors.surface.withValues(alpha: 0.80),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 8,
        ),
        child: Row(
          children: [
            IconButton(
              onPressed: () => context.pop(),
              icon: const Icon(
                Icons.close_rounded,
                size: 20,
              ),
              color: AppColors.textPrimary,
              splashRadius: 20,
            ),

            Expanded(
              child: Text(
                'Record Period',
                textAlign: TextAlign.center,
                style: AppTextTheme.headlineSmall.copyWith(
                  color: const Color(0xFF7C5357),
                  fontWeight: FontWeight.w700,
                  fontSize: 20,
                ),
              ),
            ),

            // Keeps title perfectly centered.
            const SizedBox(width: 48),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // CARD
  // ============================================================

  Widget _buildCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0x4CD4C2C3),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ======================================================
          // DESCRIPTION
          // ======================================================

          Center(
            child: Text(
              'Log the details of your recent cycle.',
              textAlign: TextAlign.center,
              style: AppTextTheme.bodyMediumSecondary.copyWith(
                color: const Color(0xFF504444),
                height: 1.5,
              ),
            ),
          ),

          const SizedBox(height: 20),

          // ======================================================
          // DATES
          // ======================================================

          _buildSectionTitle('DATES'),

          const SizedBox(height: 16),

          Row(
            children: [
              Expanded(
                child: _buildDateField(
                  label: 'Start Date',
                  value: _formatDate(_startDate),
                  onTap: _selectStartDate,
                ),
              ),

              const SizedBox(width: 12),

              Expanded(
                child: _buildDateField(
                  label: 'End Date',
                  value: _endDate == null
                      ? 'mm/dd/yyyy'
                      : _formatDate(_endDate!),
                  placeholder: _endDate == null,
                  onTap: _selectEndDate,
                ),
              ),
            ],
          ),

          const SizedBox(height: 28),

          // ======================================================
          // FLOW INTENSITY
          // ======================================================

          _buildSectionTitle('FLOW INTENSITY'),

          const SizedBox(height: 12),

          Row(
            children: [
              Expanded(
                child: _buildFlowOption(
                  label: 'Light',
                  icon: Icons.water_drop_outlined,
                ),
              ),

              const SizedBox(width: 8),

              Expanded(
                child: _buildFlowOption(
                  label: 'Medium',
                  icon: Icons.water_drop,
                ),
              ),

              const SizedBox(width: 8),

              Expanded(
                child: _buildFlowOption(
                  label: 'Heavy',
                  icon: Icons.water_drop,
                  multipleDrops: true,
                ),
              ),
            ],
          ),

          const SizedBox(height: 28),

          // ======================================================
          // NOTES
          // ======================================================

          _buildSectionTitle('NOTES'),

          const SizedBox(height: 12),

          _buildNotesField(),

          const SizedBox(height: 28),

          // ======================================================
          // SAVE
          // ======================================================

          SizedBox(
            width: double.infinity,
            height: 48,
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [
                    Color(0xFF7C5357),
                    Color(0xFF8C6064),
                  ],
                ),
                borderRadius: BorderRadius.circular(999),
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(999),
                  onTap: _savePeriod,
                  child: const Center(
                    child: Text(
                      'Save Period',
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'Inter',
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(height: 12),

          // ======================================================
          // CANCEL
          // ======================================================

          SizedBox(
            width: double.infinity,
            height: 48,
            child: OutlinedButton(
              onPressed: () => context.pop(),
              style: OutlinedButton.styleFrom(
                foregroundColor: const Color(0xFF7C5357),
                side: const BorderSide(
                  color: Color(0xFF7C5357),
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
              child: const Text(
                'Cancel',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // SECTION TITLE
  // ============================================================

  Widget _buildSectionTitle(String title) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(bottom: 8),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Color(0x33D4C2C3),
          ),
        ),
      ),
      child: Text(
        title,
        style: AppTextTheme.labelLarge.copyWith(
          color: const Color(0xFF1E1B18),
          fontSize: 12,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.7,
        ),
      ),
    );
  }

  // ============================================================
  // DATE FIELD
  // ============================================================

  Widget _buildDateField({
    required String label,
    required String value,
    required VoidCallback onTap,
    bool placeholder = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextTheme.labelSmall.copyWith(
            color: const Color(0xFF504444),
            fontSize: 10,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.6,
          ),
        ),

        const SizedBox(height: 8),

        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(4),
          child: Container(
            height: 40,
            padding: const EdgeInsets.symmetric(
              horizontal: 8,
            ),
            decoration: BoxDecoration(
              border: Border.all(
                color: AppColors.surfaceDim,
              ),
              borderRadius: BorderRadius.circular(4),
            ),
            alignment: Alignment.centerLeft,
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    value,
                    style: TextStyle(
                      color: placeholder
                          ? const Color(0xFF827474)
                          : const Color(0xFF1E1B18),
                      fontFamily: 'Inter',
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),

                const Icon(
                  Icons.calendar_today_outlined,
                  size: 15,
                  color: Color(0xFF827474),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // ============================================================
  // FLOW OPTION
  // ============================================================

  Widget _buildFlowOption({
    required String label,
    required IconData icon,
    bool multipleDrops = false,
  }) {
    final selected = _flowIntensity == label;

    return InkWell(
      onTap: () {
        setState(() {
          _flowIntensity = label;
        });
      },
      borderRadius: BorderRadius.circular(8),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        height: 76,
        decoration: BoxDecoration(
          color: selected
              ? const Color(0x4CE8B4B8)
              : AppColors.surface,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: selected
                ? const Color(0xFF7C5357)
                : const Color(0x7FD4C2C3),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (multipleDrops)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    icon,
                    size: 13,
                    color: const Color(0xFF827474),
                  ),
                  Icon(
                    icon,
                    size: 16,
                    color: const Color(0xFF827474),
                  ),
                  Icon(
                    icon,
                    size: 13,
                    color: const Color(0xFF827474),
                  ),
                ],
              )
            else
              Icon(
                icon,
                size: 17,
                color: const Color(0xFF827474),
              ),

            const SizedBox(height: 6),

            Text(
              label,
              style: TextStyle(
                color: selected
                    ? const Color(0xFF7C5357)
                    : const Color(0xFF1E1B18),
                fontFamily: 'Inter',
                fontSize: 11,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // NOTES
  // ============================================================

  Widget _buildNotesField() {
    return Container(
      height: 85,
      decoration: BoxDecoration(
        border: Border.all(
          color: const Color(0x7FD4C2C3),
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: TextField(
        controller: _notesController,
        maxLines: null,
        expands: true,
        textAlignVertical: TextAlignVertical.top,
        style: const TextStyle(
          fontFamily: 'Inter',
          fontSize: 12,
          color: Color(0xFF322F2E),
        ),
        decoration: const InputDecoration(
          hintText: 'How are you feeling? Any\nsymptoms?',
          hintStyle: TextStyle(
            color: Color(0xFF827474),
            fontFamily: 'Inter',
            fontSize: 12,
            height: 1.4,
          ),
          contentPadding: EdgeInsets.all(10),
          border: InputBorder.none,
        ),
      ),
    );
  }
}
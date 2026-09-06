import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

import '../../../core/config/theme/app_colors.dart';
import '../../../core/config/theme/app_text_theme.dart';

import 'dart:async';
import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';

/// ---------------------------------------------------------------------------
/// CREATE FUTURE MESSAGE DATA
/// ---------------------------------------------------------------------------

class CreateFutureMessageData {
  const CreateFutureMessageData({
    required this.title,
    required this.message,
    required this.openDate,
    required this.openTime,
    required this.photos,
    required this.voiceNote,
  });

  final String title;
  final String message;
  final DateTime openDate;
  final TimeOfDay openTime;
  final List<XFile> photos;

  /// For now this is a boolean.
  ///
  /// Later, when we add actual audio recording/storage, this can become:
  /// XFile? voiceNote
  final XFile? voiceNote;
}

/// ---------------------------------------------------------------------------
/// SCREEN
/// ---------------------------------------------------------------------------

class CreateFutureMessageScreen extends StatefulWidget {
  const CreateFutureMessageScreen({
    super.key,
    this.initialTitle = '',
    this.onBack,
    this.onSave,
  });

  final String initialTitle;

  final VoidCallback? onBack;
  final ValueChanged<CreateFutureMessageData>? onSave;

  @override
  State<CreateFutureMessageScreen> createState() =>
      _CreateFutureMessageScreenState();
}

class _CreateFutureMessageScreenState
    extends State<CreateFutureMessageScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;

  final ImagePicker _picker = ImagePicker();

  late final TextEditingController _titleController;
  late final TextEditingController _messageController;

  final List<XFile> _photos = [];

  late DateTime _openDate;
  TimeOfDay _openTime = const TimeOfDay(
    hour: 0,
    minute: 0,
  );

  final AudioRecorder _audioRecorder = AudioRecorder();

  XFile? _voiceNote;

  bool _isRecording = false;

  Duration _recordingDuration = Duration.zero;

  Timer? _recordingTimer;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 850),
    )..forward();

    _titleController = TextEditingController(
      text: widget.initialTitle,
    );

    _messageController = TextEditingController();

    final tomorrow = DateTime.now().add(
      const Duration(days: 1),
    );

    _openDate = DateTime(
      tomorrow.year,
      tomorrow.month,
      tomorrow.day,
    );
  }

  @override
  void dispose() {
    _recordingTimer?.cancel();

    _audioRecorder.dispose();

    _animationController.dispose();
    _titleController.dispose();
    _messageController.dispose();

    super.dispose();
  }

  /// -------------------------------------------------------------------------
  /// SAVE
  /// -------------------------------------------------------------------------

  void _sealMessage() {
    final title = _titleController.text.trim();
    final message = _messageController.text.trim();

    if (title.isEmpty) {
      _showMessage('Give your time capsule a little name.');
      return;
    }

    if (message.isEmpty &&
        _photos.isEmpty &&
        _voiceNote == null) {
      _showMessage(
        'Add a little something before sealing it.',
      );
      return;
    }

    final now = DateTime.now();

    final selectedDateTime = DateTime(
      _openDate.year,
      _openDate.month,
      _openDate.day,
      _openTime.hour,
      _openTime.minute,
    );

    if (!selectedDateTime.isAfter(now)) {
      _showMessage(
        'Choose a future date and time.',
      );
      return;
    }

    final data = CreateFutureMessageData(
      title: title,
      message: message,
      openDate: _openDate,
      openTime: _openTime,
      photos: List.unmodifiable(_photos),
      voiceNote: _voiceNote,
    );

    widget.onSave?.call(data);
  }

  /// -------------------------------------------------------------------------
  /// DATE
  /// -------------------------------------------------------------------------

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _openDate.isAfter(DateTime.now())
          ? _openDate
          : DateTime.now().add(
        const Duration(days: 1),
      ),
      firstDate: DateTime.now().add(
        const Duration(days: 1),
      ),
      lastDate: DateTime.now().add(
        const Duration(days: 3650),
      ),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.primary,
              onPrimary: Colors.white,
              surface: AppColors.surface,
              onSurface: AppColors.textPrimary,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked == null || !mounted) return;

    setState(() {
      _openDate = picked;
    });
  }

  /// -------------------------------------------------------------------------
  /// TIME
  /// -------------------------------------------------------------------------

  Future<void> _pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _openTime,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.primary,
              onPrimary: Colors.white,
              surface: AppColors.surface,
              onSurface: AppColors.textPrimary,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked == null || !mounted) return;

    setState(() {
      _openTime = picked;
    });
  }

  /// -------------------------------------------------------------------------
  /// PHOTOS
  /// -------------------------------------------------------------------------

  Future<void> _pickPhotos() async {
    try {
      final images = await _picker.pickMultiImage(
        imageQuality: 90,
      );

      if (images.isEmpty || !mounted) return;

      setState(() {
        _photos.addAll(images);
      });
    } catch (_) {
      _showMessage(
        'Could not open your photos.',
      );
    }
  }

  void _removePhoto(int index) {
    setState(() {
      _photos.removeAt(index);
    });
  }

  /// -------------------------------------------------------------------------
  /// VOICE NOTE
  /// -------------------------------------------------------------------------

  // void _toggleVoiceNote() {
  //   /*
  //    * This is intentionally a UI placeholder for now.
  //    *
  //    * When we build the actual voice recorder, replace this method
  //    * with the recorder implementation.
  //    */
  //   setState(() {
  //     _voiceNoteAdded = !_voiceNoteAdded;
  //   });
  //
  //   if (_voiceNoteAdded) {
  //     _showMessage(
  //       'Voice note added. Recording will be connected next.',
  //     );
  //   }
  // }


  Future<void> _toggleVoiceRecording() async {
    if (_isRecording) {
      await _stopVoiceRecording();
    } else {
      await _startVoiceRecording();
    }
  }

  Future<void> _startVoiceRecording() async {
    try {
      final hasPermission =
      await _audioRecorder.hasPermission();

      if (!hasPermission) {
        _showMessage(
          'Microphone permission is required.',
        );
        return;
      }

      final directory =
      await getTemporaryDirectory();

      final filePath =
          '${directory.path}/simi_voice_${DateTime.now().millisecondsSinceEpoch}.m4a';

      await _audioRecorder.start(
        const RecordConfig(
          encoder: AudioEncoder.aacLc,
          bitRate: 128000,
          sampleRate: 44100,
        ),
        path: filePath,
      );

      if (!mounted) return;

      setState(() {
        _isRecording = true;
        _recordingDuration = Duration.zero;
      });

      _recordingTimer?.cancel();

      _recordingTimer = Timer.periodic(
        const Duration(seconds: 1),
            (_) {
          if (!mounted) return;

          setState(() {
            _recordingDuration +=
            const Duration(seconds: 1);
          });
        },
      );
    } catch (e) {
      debugPrint(
        'VOICE RECORD ERROR: $e',
      );

      _showMessage(
        'Could not start recording.',
      );
    }
  }


  Future<void> _stopVoiceRecording() async {
    try {
      _recordingTimer?.cancel();
      _recordingTimer = null;

      final path = await _audioRecorder.stop();

      if (!mounted) return;

      setState(() {
        _isRecording = false;
      });

      if (path == null || path.isEmpty) {
        _showMessage(
          'No voice recording was created.',
        );
        return;
      }

      final file = File(path);

      if (!file.existsSync()) {
        _showMessage(
          'Voice recording could not be saved.',
        );
        return;
      }

      setState(() {
        _voiceNote = XFile(path);
      });

      _showMessage(
        'Voice note recorded ❤️',
      );
    } catch (e) {
      debugPrint(
        'VOICE STOP ERROR: $e',
      );

      if (!mounted) return;

      setState(() {
        _isRecording = false;
      });

      _showMessage(
        'Could not save the voice note.',
      );
    }
  }

  Future<void> _removeVoiceNote() async {
    final path = _voiceNote?.path;

    setState(() {
      _voiceNote = null;
      _recordingDuration = Duration.zero;
    });

    if (path != null) {
      try {
        final file = File(path);

        if (await file.exists()) {
          await file.delete();
        }
      } catch (_) {
        // Temporary file cleanup failure can safely be ignored.
      }
    }
  }

  /// -------------------------------------------------------------------------
  /// MESSAGE
  /// -------------------------------------------------------------------------

  void _showMessage(String message) {
    if (!mounted) return;

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          behavior: SnackBarBehavior.floating,
          backgroundColor: AppColors.textPrimary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
      );
  }

  /// -------------------------------------------------------------------------
  /// BUILD
  /// -------------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      body: Stack(
        children: [
          const Positioned.fill(
            child: _CreateFutureMessageBackground(),
          ),

          SafeArea(
            bottom: false,
            child: ListView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.only(
                bottom: 150,
              ),
              children: [
                _buildTopBar(context),
                // _buildProgress(),
                _buildIntro(),
                _buildTitleSection(),
                _buildLetterSection(),
                _buildAttachmentsSection(),
                _buildOpeningSection(),
                _buildPreview(),
                _buildPrivacyNote(),
              ],
            ),
          ),

          _buildBottomAction(),
        ],
      ),
    );
  }

  /// -------------------------------------------------------------------------
  /// TOP BAR
  /// -------------------------------------------------------------------------

  Widget _buildTopBar(BuildContext context) {
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
            icon: Icons.close_rounded,
            onTap: widget.onBack ??
                    () => Navigator.maybePop(context),
          ),

          const Spacer(),

          Column(
            children: [
              Text(
                'FUTURE MESSAGES',
                style: AppTextTheme.labelSmall.copyWith(
                  fontSize: 8,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1.5,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                'My Love ❤️',
                style: GoogleFonts.playfairDisplay(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),

          const Spacer(),

          _CircleButton(
            icon: Icons.lock_outline_rounded,
            onTap: () {},
          ),
        ],
      ),
    );
  }

  /// -------------------------------------------------------------------------
  /// PROGRESS
  /// -------------------------------------------------------------------------

  Widget _buildProgress() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        20,
        18,
        20,
        0,
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: 3,
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(999),
              ),
            ),
          ),
          const SizedBox(width: 5),
          Expanded(
            child: Container(
              height: 3,
              decoration: BoxDecoration(
                color: AppColors.primary
                    .withValues(alpha: 0.18),
                borderRadius: BorderRadius.circular(999),
              ),
            ),
          ),
          const SizedBox(width: 5),
          Expanded(
            child: Container(
              height: 3,
              decoration: BoxDecoration(
                color: AppColors.primary
                    .withValues(alpha: 0.18),
                borderRadius: BorderRadius.circular(999),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// -------------------------------------------------------------------------
  /// INTRO
  /// -------------------------------------------------------------------------

  Widget _buildIntro() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        20,
        28,
        20,
        20,
      ),
      child: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          final value = Curves.easeOut.transform(
            _animationController.value,
          );

          return Opacity(
            opacity: value,
            child: Transform.translate(
              offset: Offset(
                0,
                15 * (1 - value),
              ),
              child: child,
            ),
          );
        },
        child: Column(
          crossAxisAlignment:
          CrossAxisAlignment.start,
          children: [
            Text(
              'A LITTLE SOMETHING FOR LATER',
              style: AppTextTheme.labelSmall.copyWith(
                fontSize: 9,
                fontWeight: FontWeight.w600,
                letterSpacing: 1.8,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 7),
            Text(
              'Seal a memory.',
              style: GoogleFonts.playfairDisplay(
                fontSize: 30,
                height: 1.1,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "Write something for the future. "
                  "We'll keep it safe until the time is right.",
              style: AppTextTheme.bodyMedium.copyWith(
                color: AppColors.textSecondary,
                height: 1.55,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// -------------------------------------------------------------------------
  /// TITLE
  /// -------------------------------------------------------------------------

  Widget _buildTitleSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
      ),
      child: _SectionCard(
        child: Column(
          crossAxisAlignment:
          CrossAxisAlignment.start,
          children: [
            _SectionLabel(
              title: 'TITLE',
              subtitle: 'Give this little moment a name.',
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _titleController,
              textInputAction: TextInputAction.next,
              style: GoogleFonts.playfairDisplay(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
              decoration: _inputDecoration(
                hintText: 'e.g. Our First Anniversary',
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// -------------------------------------------------------------------------
  /// LETTER
  /// -------------------------------------------------------------------------

  Widget _buildLetterSection() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        20,
        14,
        20,
        0,
      ),
      child: _SectionCard(
        padding: const EdgeInsets.fromLTRB(
          16,
          16,
          16,
          14,
        ),
        child: Column(
          crossAxisAlignment:
          CrossAxisAlignment.start,
          children: [
            _SectionLabel(
              title: 'THE LETTER',
              subtitle: 'Say what you want them to know.',
            ),

            const SizedBox(height: 12),

            Container(
              decoration: BoxDecoration(
                color: const Color(0xFFFFFCFB),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: AppColors.outlineVariant
                      .withValues(alpha: 0.42),
                ),
              ),
              child: TextField(
                controller: _messageController,
                minLines: 8,
                maxLines: 14,
                textCapitalization:
                TextCapitalization.sentences,
                style: AppTextTheme.bodyMedium.copyWith(
                  fontSize: 13,
                  height: 1.65,
                  color: AppColors.textPrimary,
                ),
                decoration: InputDecoration(
                  hintText:
                  'My dearest...\n\nWrite something '
                      'you want them to read someday.',
                  hintStyle:
                  AppTextTheme.bodyMedium.copyWith(
                    fontSize: 13,
                    height: 1.65,
                    color: AppColors.textDisabled,
                  ),
                  border: InputBorder.none,
                  contentPadding:
                  const EdgeInsets.fromLTRB(
                    14,
                    14,
                    14,
                    14,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// -------------------------------------------------------------------------
  /// ATTACHMENTS
  /// -------------------------------------------------------------------------

  Widget _buildAttachmentsSection() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        20,
        14,
        20,
        0,
      ),
      child: Column(
        crossAxisAlignment:
        CrossAxisAlignment.start,
        children: [
          _SectionLabel(
            title: 'ADD TO YOUR CAPSULE',
            subtitle:
            'Keep a few little pieces of today with it.',
          ),

          const SizedBox(height: 12),

          Row(
            children: [
              Expanded(
                child: _AttachmentButton(
                  icon: Icons.add_photo_alternate_outlined,
                  title: 'Add Photo',
                  subtitle: _photos.isEmpty
                      ? 'A moment to keep'
                      : '${_photos.length} added',
                  onTap: _pickPhotos,
                  selected: _photos.isNotEmpty,
                ),
              ),

              const SizedBox(width: 10),

              Expanded(
                child: _AttachmentButton(
                  icon: _isRecording
                      ? Icons.stop_rounded
                      : _voiceNote != null
                      ? Icons.graphic_eq_rounded
                      : Icons.mic_none_rounded,

                  title: _isRecording
                      ? 'Recording...'
                      : _voiceNote != null
                      ? 'Voice Added'
                      : 'Record Voice',

                  subtitle: _isRecording
                      ? _formatRecordingDuration(
                    _recordingDuration,
                  )
                      : _voiceNote != null
                      ? _formatRecordingDuration(
                    _recordingDuration,
                  )
                      : 'Leave your voice',

                  onTap: _toggleVoiceRecording,

                  selected:
                  _isRecording || _voiceNote != null,
                ),
              ),
            ],
          ),

          if (_photos.isNotEmpty) ...[
            const SizedBox(height: 12),
            _buildPhotoStrip(),
          ],

          if (_voiceNote != null) ...[
            const SizedBox(height: 12),
            _buildVoicePreview(),
          ],
        ],
      ),
    );
  }

  /// -------------------------------------------------------------------------
  /// PHOTOS
  /// -------------------------------------------------------------------------

  Widget _buildPhotoStrip() {
    return SizedBox(
      height: 82,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: _photos.length,
        separatorBuilder: (_, __) =>
        const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final photo = _photos[index];

          return Stack(
            children: [
              ClipRRect(
                borderRadius:
                BorderRadius.circular(14),
                child: Image.file(
                  File(photo.path),
                  width: 82,
                  height: 82,
                  fit: BoxFit.cover,
                ),
              ),

              Positioned(
                top: 5,
                right: 5,
                child: GestureDetector(
                  onTap: () => _removePhoto(index),
                  child: Container(
                    width: 22,
                    height: 22,
                    decoration:
                    const BoxDecoration(
                      color: Colors.black54,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.close_rounded,
                      size: 13,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  /// -------------------------------------------------------------------------
  /// VOICE PREVIEW
  /// -------------------------------------------------------------------------

  Widget _buildVoicePreview() {
    return Container(
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(17),
        border: Border.all(
          color: AppColors.outlineVariant
              .withValues(alpha: 0.45),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: const BoxDecoration(
              color: Color(0xFFFCE4EC),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.graphic_eq_rounded,
              color: AppColors.primary,
              size: 20,
            ),
          ),

          const SizedBox(width: 11),

          Expanded(
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [
                Text(
                  'Voice memory',
                  style:
                  AppTextTheme.labelLarge.copyWith(
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  _formatRecordingDuration(
                    _recordingDuration,
                  ),
                  style:
                  AppTextTheme.labelSmall.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),

          GestureDetector(
            onTap: _removeVoiceNote,
            child: const Icon(
              Icons.delete_outline_rounded,
              size: 19,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  String _formatRecordingDuration(
      Duration duration,
      ) {
    final minutes =
    duration.inMinutes.toString().padLeft(2, '0');

    final seconds =
    (duration.inSeconds % 60)
        .toString()
        .padLeft(2, '0');

    return '$minutes:$seconds';
  }

  /// -------------------------------------------------------------------------
  /// OPENING DATE
  /// -------------------------------------------------------------------------

  Widget _buildOpeningSection() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        20,
        26,
        20,
        0,
      ),
      child: _SectionCard(
        padding: const EdgeInsets.fromLTRB(
          16,
          17,
          16,
          16,
        ),
        child: Column(
          crossAxisAlignment:
          CrossAxisAlignment.start,
          children: [
            _SectionLabel(
              title: 'WHEN SHOULD IT OPEN?',
              subtitle:
              'Choose the moment they can finally see it.',
            ),

            const SizedBox(height: 14),

            Row(
              children: [
                Expanded(
                  child: _DateTimeTile(
                    icon: Icons.calendar_today_outlined,
                    label: 'OPEN DATE',
                    value: _formatDate(_openDate),
                    onTap: _pickDate,
                  ),
                ),

                const SizedBox(width: 10),

                Expanded(
                  child: _DateTimeTile(
                    icon: Icons.schedule_outlined,
                    label: 'OPEN TIME',
                    value: _formatTime(_openTime),
                    onTap: _pickTime,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 11,
              ),
              decoration: BoxDecoration(
                color: const Color(0xFFF7F1F0),
                borderRadius:
                BorderRadius.circular(14),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.lock_clock_outlined,
                    size: 16,
                    color: AppColors.primary,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Once sealed, the message stays private '
                          'until this moment.',
                      style:
                      AppTextTheme.labelSmall.copyWith(
                        fontSize: 9.5,
                        color:
                        AppColors.textSecondary,
                        height: 1.35,
                      ),
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

  /// -------------------------------------------------------------------------
  /// PREVIEW
  /// -------------------------------------------------------------------------

  Widget _buildPreview() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        20,
        26,
        20,
        0,
      ),
      child: _CapsulePreview(
        title: _titleController.text.trim().isEmpty
            ? 'A little message for later'
            : _titleController.text.trim(),
        openDate: _openDate,
        openTime: _openTime,
        photoCount: _photos.length,
        voiceAdded: _voiceNote != null,
      ),
    );
  }

  /// -------------------------------------------------------------------------
  /// PRIVACY
  /// -------------------------------------------------------------------------

  Widget _buildPrivacyNote() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        20,
        18,
        20,
        0,
      ),
      child: Row(
        crossAxisAlignment:
        CrossAxisAlignment.start,
        children: [
          Container(
            width: 30,
            height: 30,
            decoration: const BoxDecoration(
              color: Color(0xFFFCE4EC),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.lock_outline_rounded,
              size: 15,
              color: AppColors.primary,
            ),
          ),

          const SizedBox(width: 10),

          Expanded(
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [
                Text(
                  'Just between us.',
                  style:
                  AppTextTheme.labelLarge.copyWith(
                    fontSize: 12,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  'Your capsule stays private and hidden '
                      'until it is ready to open.',
                  style:
                  AppTextTheme.labelSmall.copyWith(
                    fontSize: 9.5,
                    color: AppColors.textSecondary,
                    height: 1.45,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// -------------------------------------------------------------------------
  /// BOTTOM CTA
  /// -------------------------------------------------------------------------

  Widget _buildBottomAction() {
    return Positioned(
      left: 18,
      right: 18,
      bottom: 14,
      child: SafeArea(
        top: false,
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: 540,
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 6,
              ),
              child: GestureDetector(
                onTap: _sealMessage,
                child: Container(
                  height: 58,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Color(0xFF765457),
                        Color(0xFF966E72),
                      ],
                    ),
                    borderRadius:
                    BorderRadius.circular(29),
                    border: Border.all(
                      color: Colors.white.withValues(
                        alpha: 0.15,
                      ),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color:
                        AppColors.primary.withValues(
                          alpha: 0.22,
                        ),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                      ),
                      BoxShadow(
                        color:
                        Colors.black.withValues(
                          alpha: 0.08,
                        ),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      const SizedBox(width: 7),

                      Container(
                        width: 46,
                        height: 46,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(
                            alpha: 0.14,
                          ),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.lock_outline_rounded,
                          size: 21,
                          color: Colors.white,
                        ),
                      ),

                      const SizedBox(width: 13),

                      Expanded(
                        child: Column(
                          mainAxisAlignment:
                          MainAxisAlignment.center,
                          crossAxisAlignment:
                          CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Seal My Message',
                              maxLines: 1,
                              overflow:
                              TextOverflow.ellipsis,
                              style:
                              GoogleFonts.playfairDisplay(
                                fontSize: 17,
                                fontWeight:
                                FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 3),
                            Text(
                              'Keep it safe until the right moment',
                              maxLines: 1,
                              overflow:
                              TextOverflow.ellipsis,
                              style:
                              AppTextTheme.labelSmall
                                  .copyWith(
                                fontSize: 9.5,
                                color: Colors.white
                                    .withValues(
                                  alpha: 0.70,
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
                        const EdgeInsets.only(right: 4),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(
                            alpha: 0.12,
                          ),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.arrow_forward_rounded,
                          size: 19,
                          color: Colors.white,
                        ),
                      ),

                      const SizedBox(width: 2),
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

  /// -------------------------------------------------------------------------
  /// HELPERS
  /// -------------------------------------------------------------------------

  InputDecoration _inputDecoration({
    required String hintText,
  }) {
    return InputDecoration(
      hintText: hintText,
      hintStyle: GoogleFonts.playfairDisplay(
        fontSize: 16,
        color: AppColors.textDisabled,
      ),
      filled: true,
      fillColor: const Color(0xFFFFFCFB),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(
          color: AppColors.outlineVariant
              .withValues(alpha: 0.42),
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(
          color: AppColors.outlineVariant
              .withValues(alpha: 0.42),
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(
          color: AppColors.primary,
        ),
      ),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 14,
        vertical: 14,
      ),
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

    return '${months[date.month - 1]} '
        '${date.day}, ${date.year}';
  }

  String _formatTime(TimeOfDay time) {
    final hour = time.hourOfPeriod == 0
        ? 12
        : time.hourOfPeriod;

    final minute = time.minute
        .toString()
        .padLeft(2, '0');

    final period =
    time.period == DayPeriod.am ? 'AM' : 'PM';

    return '$hour:$minute $period';
  }
}

/// ---------------------------------------------------------------------------
/// SECTION CARD
/// ---------------------------------------------------------------------------

class _SectionCard extends StatelessWidget {
  const _SectionCard({
    required this.child,
    this.padding = const EdgeInsets.all(16),
  });

  final Widget child;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: padding,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.84),
        borderRadius: BorderRadius.circular(21),
        border: Border.all(
          color: AppColors.outlineVariant
              .withValues(alpha: 0.48),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(
              alpha: 0.035,
            ),
            blurRadius: 14,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: child,
    );
  }
}

/// ---------------------------------------------------------------------------
/// SECTION LABEL
/// ---------------------------------------------------------------------------

class _SectionLabel extends StatelessWidget {
  const _SectionLabel({
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
          style: AppTextTheme.labelSmall.copyWith(
            fontSize: 9,
            fontWeight: FontWeight.w600,
            letterSpacing: 1.5,
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 3),
        Text(
          subtitle,
          style: AppTextTheme.labelSmall.copyWith(
            fontSize: 9.5,
            color: AppColors.textDisabled,
          ),
        ),
      ],
    );
  }
}

/// ---------------------------------------------------------------------------
/// ATTACHMENT BUTTON
/// ---------------------------------------------------------------------------

class _AttachmentButton extends StatelessWidget {
  const _AttachmentButton({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.selected = false,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration:
        const Duration(milliseconds: 180),
        height: 74,
        padding: const EdgeInsets.symmetric(
          horizontal: 12,
        ),
        decoration: BoxDecoration(
          color: selected
              ? const Color(0xFFFCE4EC)
              : Colors.white.withValues(
            alpha: 0.78,
          ),
          borderRadius: BorderRadius.circular(17),
          border: Border.all(
            color: selected
                ? AppColors.primary
                .withValues(alpha: 0.35)
                : AppColors.outlineVariant
                .withValues(alpha: 0.45),
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: selected
                    ? Colors.white
                    : const Color(0xFFF7F1F0),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: 17,
                color: AppColors.primary,
              ),
            ),

            const SizedBox(width: 9),

            Expanded(
              child: Column(
                mainAxisAlignment:
                MainAxisAlignment.center,
                crossAxisAlignment:
                CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    maxLines: 1,
                    overflow:
                    TextOverflow.ellipsis,
                    style:
                    AppTextTheme.labelLarge.copyWith(
                      fontSize: 11,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    subtitle,
                    maxLines: 1,
                    overflow:
                    TextOverflow.ellipsis,
                    style:
                    AppTextTheme.labelSmall.copyWith(
                      fontSize: 8,
                      color: AppColors.textSecondary,
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
}

/// ---------------------------------------------------------------------------
/// DATE / TIME TILE
/// ---------------------------------------------------------------------------

class _DateTimeTile extends StatelessWidget {
  const _DateTimeTile({
    required this.icon,
    required this.label,
    required this.value,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final String value;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.fromLTRB(
          12,
          11,
          10,
          11,
        ),
        decoration: BoxDecoration(
          color: const Color(0xFFFFFCFB),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: AppColors.outlineVariant
                .withValues(alpha: 0.45),
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 30,
              height: 30,
              decoration: const BoxDecoration(
                color: Color(0xFFFCE4EC),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: 14,
                color: AppColors.primary,
              ),
            ),

            const SizedBox(width: 8),

            Expanded(
              child: Column(
                crossAxisAlignment:
                CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    maxLines: 1,
                    overflow:
                    TextOverflow.ellipsis,
                    style:
                    AppTextTheme.labelSmall.copyWith(
                      fontSize: 7,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.7,
                      color:
                      AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    value,
                    maxLines: 1,
                    overflow:
                    TextOverflow.ellipsis,
                    style:
                    AppTextTheme.labelLarge.copyWith(
                      fontSize: 10,
                      color:
                      AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
            ),

            const Icon(
              Icons.keyboard_arrow_down_rounded,
              size: 17,
              color: AppColors.textSecondary,
            ),
          ],
        ),
      ),
    );
  }
}

/// ---------------------------------------------------------------------------
/// CAPSULE PREVIEW
/// ---------------------------------------------------------------------------

class _CapsulePreview extends StatelessWidget {
  const _CapsulePreview({
    required this.title,
    required this.openDate,
    required this.openTime,
    required this.photoCount,
    required this.voiceAdded,
  });

  final String title;
  final DateTime openDate;
  final TimeOfDay openTime;
  final int photoCount;
  final bool voiceAdded;

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

    return '${months[date.month - 1]} '
        '${date.day}, ${date.year}';
  }

  String _formatTime(TimeOfDay time) {
    final hour = time.hourOfPeriod == 0
        ? 12
        : time.hourOfPeriod;

    final minute = time.minute
        .toString()
        .padLeft(2, '0');

    final period =
    time.period == DayPeriod.am ? 'AM' : 'PM';

    return '$hour:$minute $period';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.antiAlias,
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF332A2B),
            Color(0xFF4A3639),
          ],
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(
              alpha: 0.12,
            ),
            blurRadius: 20,
            offset: const Offset(0, 9),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            right: -50,
            top: -65,
            child: Container(
              width: 170,
              height: 170,
              decoration: BoxDecoration(
                color: Colors.white.withValues(
                  alpha: 0.055,
                ),
                shape: BoxShape.circle,
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.fromLTRB(
              20,
              19,
              20,
              19,
            ),
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 34,
                      height: 34,
                      decoration: BoxDecoration(
                        color: Colors.white
                            .withValues(alpha: 0.11),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.lock_outline_rounded,
                        size: 17,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(width: 9),
                    Text(
                      'SEALED CAPSULE',
                      style:
                      AppTextTheme.labelSmall.copyWith(
                        fontSize: 8,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1.4,
                        color: Colors.white
                            .withValues(alpha: 0.64),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                Text(
                  title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style:
                  GoogleFonts.playfairDisplay(
                    fontSize: 23,
                    height: 1.16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),

                const SizedBox(height: 7),

                Text(
                  'Will open on',
                  style:
                  AppTextTheme.labelSmall.copyWith(
                    fontSize: 8.5,
                    color: Colors.white
                        .withValues(alpha: 0.55),
                  ),
                ),

                const SizedBox(height: 3),

                Text(
                  _formatDate(openDate),
                  style:
                  AppTextTheme.labelLarge.copyWith(
                    fontSize: 12,
                    color: Colors.white,
                  ),
                ),

                const SizedBox(height: 2),

                Text(
                  _formatTime(openTime),
                  style:
                  AppTextTheme.labelSmall.copyWith(
                    fontSize: 9,
                    color: Colors.white
                        .withValues(alpha: 0.62),
                  ),
                ),

                const SizedBox(height: 17),

                Row(
                  children: [
                    if (photoCount > 0)
                      _PreviewPill(
                        icon:
                        Icons.photo_outlined,
                        text:
                        '$photoCount photo${photoCount == 1 ? '' : 's'}',
                      ),

                    if (photoCount > 0 &&
                        voiceAdded)
                      const SizedBox(width: 7),

                    if (voiceAdded)
                      const _PreviewPill(
                        icon:
                        Icons.mic_none_rounded,
                        text: 'Voice note',
                      ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PreviewPill extends StatelessWidget {
  const _PreviewPill({
    required this.icon,
    required this.text,
  });

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 6,
      ),
      decoration: BoxDecoration(
        color: Colors.white.withValues(
          alpha: 0.10,
        ),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 11,
            color: Colors.white
                .withValues(alpha: 0.75),
          ),
          const SizedBox(width: 4),
          Text(
            text,
            style:
            AppTextTheme.labelSmall.copyWith(
              fontSize: 8,
              color: Colors.white
                  .withValues(alpha: 0.70),
            ),
          ),
        ],
      ),
    );
  }
}

/// ---------------------------------------------------------------------------
/// CIRCLE BUTTON
/// ---------------------------------------------------------------------------

class _CircleButton extends StatelessWidget {
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
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: Colors.white.withValues(
            alpha: 0.72,
          ),
          shape: BoxShape.circle,
          border: Border.all(
            color: AppColors.outlineVariant
                .withValues(alpha: 0.45),
          ),
        ),
        child: Icon(
          icon,
          size: 18,
          color: AppColors.textPrimary,
        ),
      ),
    );
  }
}

/// ---------------------------------------------------------------------------
/// BACKGROUND
/// ---------------------------------------------------------------------------

class _CreateFutureMessageBackground
    extends StatelessWidget {
  const _CreateFutureMessageBackground();

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Stack(
        children: [
          Positioned(
            top: -80,
            right: -70,
            child: _BlurCircle(
              size: 210,
              color: const Color(0xFFE8B4B8),
            ),
          ),
          Positioned(
            top: 350,
            left: -110,
            child: _BlurCircle(
              size: 220,
              color: const Color(0xFFDCD9E8),
            ),
          ),
          Positioned(
            bottom: 100,
            right: -80,
            child: _BlurCircle(
              size: 190,
              color: const Color(0xFFF2D9DC),
            ),
          ),
        ],
      ),
    );
  }
}

class _BlurCircle extends StatelessWidget {
  const _BlurCircle({
    required this.size,
    required this.color,
  });

  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return ImageFiltered(
      imageFilter: ImageFilter.blur(
        sigmaX: 35,
        sigmaY: 35,
      ),
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: color.withValues(
            alpha: 0.17,
          ),
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}
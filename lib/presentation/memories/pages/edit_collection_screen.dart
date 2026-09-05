import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

import '../../../core/config/theme/app_colors.dart';
import '../../../core/config/theme/app_text_theme.dart';
import 'memories_screen.dart';

class EditCollectionScreen extends StatefulWidget {
  const EditCollectionScreen({
    super.key,
    required this.collection,
  });

  final MemoryFolder collection;

  @override
  State<EditCollectionScreen> createState() =>
      _EditCollectionScreenState();
}

class _EditCollectionScreenState
    extends State<EditCollectionScreen> {
  final ImagePicker _picker = ImagePicker();

  late final TextEditingController _nameController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _tagController;

  final List<String> _tags = [];

  XFile? _newCoverPhoto;

  @override
  void initState() {
    super.initState();

    _nameController =
        TextEditingController(
          text: widget.collection.name,
        );

    _descriptionController =
        TextEditingController(
          text: widget.collection.description,
        );

    _tagController =
        TextEditingController();

    _tags.addAll(widget.collection.tags);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _tagController.dispose();
    super.dispose();
  }

  Future<void> _pickCover() async {
    try {
      final image =
      await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 90,
      );

      if (image == null || !mounted) return;

      setState(() {
        _newCoverPhoto = image;
      });
    } catch (_) {
      _showMessage(
        'Could not open your photos.',
      );
    }
  }

  void _removeNewCover() {
    setState(() {
      _newCoverPhoto = null;
    });
  }

  void _addTag() {
    final value =
    _tagController.text.trim();

    if (value.isEmpty) return;

    final exists = _tags.any(
          (tag) =>
      tag.toLowerCase() ==
          value.toLowerCase(),
    );

    if (exists) {
      _tagController.clear();
      return;
    }

    setState(() {
      _tags.add(value);
      _tagController.clear();
    });
  }

  void _removeTag(String tag) {
    setState(() {
      _tags.remove(tag);
    });
  }

  void _save() {
    final name =
    _nameController.text.trim();

    if (name.isEmpty) {
      _showMessage(
        'Collection name cannot be empty.',
      );
      return;
    }

    ImageProvider? cover =
        widget.collection.coverImage;

    if (_newCoverPhoto != null) {
      cover = FileImage(
        File(_newCoverPhoto!.path),
      );
    }

    final updated =
    MemoryFolder(
      name: name,
      count: widget.collection.count,
      coverImage: cover,
      description:
      _descriptionController.text.trim(),
      tags: List.unmodifiable(_tags),
      createdAt:
      widget.collection.createdAt,
    );

    Navigator.of(context).pop(updated);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      body: SafeArea(
        child: Stack(
          children: [
            const _CollectionBackground(),

            CustomScrollView(
              physics:
              const BouncingScrollPhysics(),
              slivers: [
                SliverPadding(
                  padding:
                  const EdgeInsets.fromLTRB(
                    20,
                    10,
                    20,
                    130,
                  ),
                  sliver:
                  SliverToBoxAdapter(
                    child: Center(
                      child: ConstrainedBox(
                        constraints:
                        const BoxConstraints(
                          maxWidth: 560,
                        ),
                        child: Column(
                          crossAxisAlignment:
                          CrossAxisAlignment
                              .start,
                          children: [
                            _buildTopBar(),

                            const SizedBox(
                              height: 26,
                            ),

                            _buildHeading(),

                            const SizedBox(
                              height: 22,
                            ),

                            _buildCover(),

                            const SizedBox(
                              height: 22,
                            ),

                            _buildName(),

                            const SizedBox(
                              height: 18,
                            ),

                            _buildDescription(),

                            const SizedBox(
                              height: 18,
                            ),

                            _buildTags(),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),

            _buildSaveButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildTopBar() {
    return Row(
      children: [
        GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
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
                    .withValues(alpha: 0.55),
              ),
            ),
            child: const Icon(
              Icons.arrow_back_rounded,
              size: 19,
              color:
              AppColors.textPrimary,
            ),
          ),
        ),

        const Spacer(),

        Text(
          'EDIT COLLECTION',
          style:
          AppTextTheme.labelSmall.copyWith(
            fontSize: 9,
            letterSpacing: 1.5,
            fontWeight: FontWeight.w700,
            color: AppColors.primary,
          ),
        ),

        const Spacer(),

        const SizedBox(width: 42),
      ],
    );
  }

  Widget _buildHeading() {
    return Column(
      crossAxisAlignment:
      CrossAxisAlignment.start,
      children: [
        Text(
          'Make it feel like yours.',
          style:
          GoogleFonts.playfairDisplay(
            fontSize: 28,
            fontWeight: FontWeight.w600,
            color:
            AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          'Update the little details that make '
              'this collection special.',
          style:
          AppTextTheme.bodyMedium.copyWith(
            fontSize: 12,
            height: 1.5,
            color:
            AppColors.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildCover() {
    final hasNew =
        _newCoverPhoto != null;

    return Column(
      crossAxisAlignment:
      CrossAxisAlignment.start,
      children: [
        _EditSectionLabel(
          label: 'COVER PHOTO',
        ),

        const SizedBox(height: 10),

        ClipRRect(
          borderRadius:
          BorderRadius.circular(28),
          child: SizedBox(
            height: 220,
            width: double.infinity,
            child: Stack(
              fit: StackFit.expand,
              children: [
                if (hasNew)
                  Image.file(
                    File(
                      _newCoverPhoto!.path,
                    ),
                    fit: BoxFit.cover,
                  )
                else if (widget
                    .collection
                    .coverImage !=
                    null)
                  Image(
                    image: widget
                        .collection
                        .coverImage!,
                    fit: BoxFit.cover,
                  )
                else
                  Container(
                    color:
                    const Color(0xFFF2E6E5),
                    child: const Icon(
                      Icons
                          .collections_bookmark_outlined,
                      size: 42,
                      color:
                      AppColors.primary,
                    ),
                  ),

                Positioned(
                  left: 14,
                  right: 14,
                  bottom: 14,
                  child: Row(
                    children: [
                      Expanded(
                        child:
                        _CoverButton(
                          icon: Icons
                              .photo_library_outlined,
                          label: 'Change cover',
                          onTap:
                          _pickCover,
                        ),
                      ),

                      if (hasNew) ...[
                        const SizedBox(
                          width: 8,
                        ),
                        _SmallCoverButton(
                          icon: Icons
                              .close_rounded,
                          onTap:
                          _removeNewCover,
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildName() {
    return _EditFieldCard(
      label: 'COLLECTION NAME',
      icon:
      Icons.auto_awesome_rounded,
      child: TextField(
        controller:
        _nameController,
        textCapitalization:
        TextCapitalization.words,
        style:
        GoogleFonts.playfairDisplay(
          fontSize: 16,
          fontWeight:
          FontWeight.w600,
          color:
          AppColors.textPrimary,
        ),
        decoration:
        InputDecoration(
          hintText:
          'Our favourite places',
          hintStyle:
          GoogleFonts.playfairDisplay(
            fontSize: 14,
            color:
            AppColors.textDisabled,
          ),
          border:
          InputBorder.none,
          contentPadding:
          const EdgeInsets.fromLTRB(
            8,
            4,
            8,
            4,
          ),
        ),
      ),
    );
  }

  Widget _buildDescription() {
    return _EditFieldCard(
      label: 'DESCRIPTION',
      icon:
      Icons.edit_note_rounded,
      child: TextField(
        controller:
        _descriptionController,
        minLines: 4,
        maxLines: 7,
        textCapitalization:
        TextCapitalization.sentences,
        style:
        AppTextTheme.bodyLarge.copyWith(
          fontSize: 14,
          height: 1.55,
          color:
          AppColors.textPrimary,
        ),
        decoration:
        InputDecoration(
          hintText:
          'What makes this collection special?',
          hintStyle:
          AppTextTheme.bodyMedium.copyWith(
            color:
            AppColors.textDisabled,
            height: 1.5,
          ),
          border:
          InputBorder.none,
          contentPadding:
          const EdgeInsets.fromLTRB(
            8,
            4,
            8,
            4,
          ),
        ),
      ),
    );
  }

  Widget _buildTags() {
    return _EditFieldCard(
      label: 'TAGS',
      icon:
      Icons.sell_outlined,
      child: Column(
        children: [
          Row(
            children: [
              const Text(
                '#',
                style: TextStyle(
                  fontSize: 21,
                  fontWeight:
                  FontWeight.w600,
                  color:
                  AppColors.primary,
                ),
              ),

              const SizedBox(width: 7),

              Expanded(
                child: TextField(
                  controller:
                  _tagController,
                  textInputAction:
                  TextInputAction.done,
                  onSubmitted: (_) =>
                      _addTag(),
                  decoration:
                  InputDecoration(
                    hintText:
                    'travel, beach, dates...',
                    hintStyle:
                    AppTextTheme
                        .bodyMedium
                        .copyWith(
                      fontSize: 12,
                      color:
                      AppColors
                          .textDisabled,
                    ),
                    border:
                    InputBorder.none,
                    contentPadding:
                    const EdgeInsets.fromLTRB(
                      8,
                      4,
                      8,
                      4,
                    ),
                  ),
                ),
              ),

              const SizedBox(width: 8),

              Material(
                color:
                AppColors.primary,
                shape:
                const CircleBorder(),
                child: InkWell(
                  onTap: _addTag,
                  customBorder:
                  const CircleBorder(),
                  child:
                  const SizedBox(
                    width: 38,
                    height: 38,
                    child: Icon(
                      Icons.add_rounded,
                      color:
                      Colors.white,
                      size: 19,
                    ),
                  ),
                ),
              ),
            ],
          ),

          if (_tags.isNotEmpty) ...[
            const SizedBox(height: 10),

            Align(
              alignment:
              Alignment.centerLeft,
              child: Wrap(
                spacing: 7,
                runSpacing: 7,
                children:
                _tags.map(
                      (tag) {
                    return InputChip(
                      label:
                      Text('#$tag'),
                      onDeleted: () =>
                          _removeTag(
                            tag,
                          ),
                      deleteIcon:
                      const Icon(
                        Icons.close_rounded,
                        size: 14,
                      ),
                      backgroundColor:
                      const Color(
                        0xFFFCE4EC,
                      ),
                      side:
                      BorderSide.none,
                      labelStyle:
                      AppTextTheme
                          .labelSmall
                          .copyWith(
                        fontSize: 10,
                        color:
                        AppColors
                            .primary,
                        fontWeight:
                        FontWeight.w600,
                      ),
                    );
                  },
                ).toList(),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildSaveButton() {
    return Positioned(
      left: 18,
      right: 18,
      bottom: 16,
      child: SafeArea(
        top: false,
        child: Center(
          child: ConstrainedBox(
            constraints:
            const BoxConstraints(
              maxWidth: 560,
            ),
            child: SizedBox(
              height: 56,
              width: double.infinity,
              child: FilledButton(
                onPressed: _save,
                style:
                FilledButton.styleFrom(
                  backgroundColor:
                  AppColors.primary,
                  foregroundColor:
                  Colors.white,
                  elevation: 0,
                  shape:
                  RoundedRectangleBorder(
                    borderRadius:
                    BorderRadius.circular(
                      28,
                    ),
                  ),
                ),
                child: Row(
                  mainAxisAlignment:
                  MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.check_rounded,
                      size: 19,
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                    Text(
                      'Save changes',
                      style:
                      AppTextTheme
                          .labelLarge
                          .copyWith(
                        color:
                        Colors.white,
                        fontWeight:
                        FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          behavior:
          SnackBarBehavior.floating,
          shape:
          RoundedRectangleBorder(
            borderRadius:
            BorderRadius.circular(14),
          ),
        ),
      );
  }
}



class _SmallCoverButton
    extends StatelessWidget {
  const _SmallCoverButton({
    required this.icon,
    required this.onTap,
  });

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black
          .withValues(alpha: 0.48),
      shape: const CircleBorder(),
      child: InkWell(
        onTap: onTap,
        customBorder:
        const CircleBorder(),
        child: SizedBox(
          width: 46,
          height: 46,
          child: Icon(
            icon,
            color: Colors.white,
            size: 18,
          ),
        ),
      ),
    );
  }
}

class _EditSectionLabel
    extends StatelessWidget {
  const _EditSectionLabel({
    required this.label,
  });

  final String label;

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style:
      AppTextTheme.labelSmall.copyWith(
        fontSize: 9,
        letterSpacing: 1.4,
        fontWeight: FontWeight.w700,
        color: AppColors.primary,
      ),
    );
  }
}

class _EditFieldCard
    extends StatelessWidget {
  const _EditFieldCard({
    required this.label,
    required this.icon,
    required this.child,
  });

  final String label;
  final IconData icon;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:
      const EdgeInsets.fromLTRB(
        17,
        15,
        17,
        15,
      ),
      decoration:
      BoxDecoration(
        color: Colors.white
            .withValues(alpha: 0.88),
        borderRadius:
        BorderRadius.circular(24),
        border: Border.all(
          color: AppColors
              .outlineVariant
              .withValues(alpha: 0.55),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black
                .withValues(alpha: 0.035),
            blurRadius: 18,
            offset:
            const Offset(0, 7),
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
                width: 30,
                height: 30,
                decoration:
                const BoxDecoration(
                  color: Color(
                    0xFFFCE4EC,
                  ),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  size: 15,
                  color:
                  AppColors.primary,
                ),
              ),
              const SizedBox(
                width: 9,
              ),
              Text(
                label,
                style:
                AppTextTheme.labelSmall
                    .copyWith(
                  fontSize: 9,
                  fontWeight:
                  FontWeight.w700,
                  letterSpacing: 1.3,
                  color:
                  AppColors.primary,
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          child,
        ],
      ),
    );
  }
}



class _CollectionBackground
    extends StatelessWidget {
  const _CollectionBackground();

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Stack(
        children: [
          Positioned(
            top: -100,
            right: -80,
            child: Container(
              width: 230,
              height: 230,
              decoration:
              BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(
                  0xFFFCE4EC,
                ).withValues(
                  alpha: 0.45,
                ),
              ),
            ),
          ),
          Positioned(
            top: 470,
            left: -110,
            child: Container(
              width: 220,
              height: 220,
              decoration:
              BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(
                  0xFFECEAF3,
                ).withValues(
                  alpha: 0.35,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}


class _CoverButton
    extends StatelessWidget {
  const _CoverButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black
          .withValues(alpha: 0.48),
      borderRadius:
      BorderRadius.circular(18),
      child: InkWell(
        onTap: onTap,
        borderRadius:
        BorderRadius.circular(18),
        child: SizedBox(
          height: 46,
          child: Row(
            mainAxisAlignment:
            MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: Colors.white,
                size: 17,
              ),
              const SizedBox(
                width: 7,
              ),
              Text(
                label,
                style:
                AppTextTheme.labelLarge
                    .copyWith(
                  fontSize: 11,
                  color: Colors.white,
                  fontWeight:
                  FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
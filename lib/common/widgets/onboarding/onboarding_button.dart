import 'package:flutter/material.dart';

class OnboardingButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool showArrow;
  final bool outlined;

  const OnboardingButton({
    super.key,
    required this.text,
    this.onPressed,
    this.showArrow = true,
    this.outlined = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SizedBox(
      width: double.infinity,
      height: 56,
      child: outlined
          ? OutlinedButton(
        onPressed: onPressed,
        child: _content(theme),
      )
          : ElevatedButton(
        onPressed: onPressed,
        child: _content(theme),
      ),
    );
  }

  Widget _content(ThemeData theme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(text),
        if (showArrow) ...[
          const SizedBox(width: 8),
          const Icon(
            Icons.arrow_forward_rounded,
            size: 18,
          ),
        ],
      ],
    );
  }
}
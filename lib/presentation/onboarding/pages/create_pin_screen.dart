import 'package:flutter/material.dart';
import '../../../common/widgets/onboarding/onboarding_keyboard.dart';

class CreatePinScreen extends StatefulWidget {
  const CreatePinScreen({
    super.key,
    required this.onBack,
    required this.onPinCreated,
  });

  final VoidCallback onBack;
  final ValueChanged<String> onPinCreated;

  @override
  State<CreatePinScreen> createState() => _CreatePinScreenState();
}

class _CreatePinScreenState extends State<CreatePinScreen> {
  String pin = '';

  void _pressKey(String value) {
    if (pin.length >= 4) return;

    setState(() {
      pin += value;
    });

    if (pin.length == 4) {
      Future.delayed(
        const Duration(milliseconds: 250),
            () {
          if (mounted) {
            widget.onPinCreated(pin);
          }
        },
      );
    }
  }

  void _deleteKey() {
    if (pin.isEmpty) return;

    setState(() {
      pin = pin.substring(0, pin.length - 1);
    });
  }

  @override
  Widget build(BuildContext context) {
    return PinKeypadLayout(
      title: 'Create your private PIN',
      pin: pin,
      onBack: widget.onBack,
      onKeyPressed: _pressKey,
      onDelete: _deleteKey,
    );
  }
}

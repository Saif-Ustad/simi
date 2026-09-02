import 'package:flutter/material.dart';
import '../../../common/widgets/onboarding/onboarding_keyboard.dart';

class ConfirmPinScreen extends StatefulWidget {
  const ConfirmPinScreen({
    super.key,
    required this.onBack,
    required this.createdPin,
    required this.onPinConfirmed,
  });

  final VoidCallback onBack;
  final String createdPin;
  final ValueChanged<String> onPinConfirmed;

  @override
  State<ConfirmPinScreen> createState() => _ConfirmPinScreenState();
}

class _ConfirmPinScreenState extends State<ConfirmPinScreen> {
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
            widget.onPinConfirmed(pin);
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
      title: 'Confirm your private PIN',
      pin: pin,
      onBack: widget.onBack,
      onKeyPressed: _pressKey,
      onDelete: _deleteKey,
    );
  }
}
import 'package:flutter/material.dart';

class PinKeypad extends StatelessWidget {
  final Function(String value) onKeyPressed;
  final VoidCallback? onDelete;
  final VoidCallback? onBiometric;

  const PinKeypad({
    super.key,
    required this.onKeyPressed,
    this.onDelete,
    this.onBiometric,
  });

  Widget _key({
    required Widget child,
    VoidCallback? onTap,
  }) {
    return Expanded(
      child: AspectRatio(
        aspectRatio: 1,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(50),
          child: Center(child: child),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _row(['1', '2', '3']),
        _row(['4', '5', '6']),
        _row(['7', '8', '9']),
        Row(
          children: [
            _key(
              child: const Icon(Icons.fingerprint),
              onTap: onBiometric,
            ),
            _key(
              child: const Text('0'),
              onTap: () => onKeyPressed('0'),
            ),
            _key(
              child: const Icon(Icons.backspace_outlined),
              onTap: onDelete,
            ),
          ],
        ),
      ],
    );
  }

  Widget _row(List<String> numbers) {
    return Row(
      children: numbers.map((number) {
        return _key(
          child: Text(
            number,
            style: const TextStyle(fontSize: 20),
          ),
          onTap: () => onKeyPressed(number),
        );
      }).toList(),
    );
  }
}
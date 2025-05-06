import 'package:flutter/material.dart';
import 'package:punctualis_1/utils/error_indicator.dart';

class ValidatedTextField extends StatefulWidget {
  final String labelText;
  final TextEditingController? controller;
  final bool obscureText;
  final Widget? suffixIcon;
  final String? errorText;
  final ValueChanged<String>? onChanged;
  final TextInputType? keyboardType;
  
  const ValidatedTextField({
    super.key,
    required this.labelText,
    this.controller,
    this.obscureText = false,
    this.suffixIcon,
    this.errorText,
    this.onChanged,
    this.keyboardType,
  });

  @override
  State<ValidatedTextField> createState() => _ValidatedTextFieldState();
}

class _ValidatedTextFieldState extends State<ValidatedTextField> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: widget.controller,
          obscureText: widget.obscureText,
          obscuringCharacter: '*',
          keyboardType: widget.keyboardType,
          decoration: InputDecoration(
            border: const OutlineInputBorder(),
            labelText: widget.labelText,
            labelStyle: TextStyle(
              color: Theme.of(context).colorScheme.primary,
            ),
            floatingLabelBehavior: FloatingLabelBehavior.always,
            suffixIcon: widget.suffixIcon,
          ),
          onChanged: widget.onChanged,
        ),
        const SizedBox(height: 4),
        ErrorIndicator(
          hasError: widget.errorText != null,
          errorText: widget.errorText,
          isEmpty: widget.controller?.text.isEmpty ?? true,
        ),
      ],
    );
  }
}
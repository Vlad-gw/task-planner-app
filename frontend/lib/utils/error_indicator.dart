import 'package:flutter/material.dart';

class ErrorIndicator extends StatelessWidget {
  final bool hasError;
  final String? errorText;
  final bool isEmpty;
  final bool wasValidated; 

  const ErrorIndicator({
    super.key, 
    required this.hasError,
    this.errorText,
    this.isEmpty = true,
    this.wasValidated = false,
  });

  @override
  Widget build(BuildContext context) {
    Color getIndicatorColor() {
      if (isEmpty && !wasValidated) return Color.fromARGB(255, 121, 116, 126);
      if (hasError) return Colors.red;
      return Colors.green;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          height: 3,
          decoration: BoxDecoration(
            color: getIndicatorColor(),
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        if (hasError && errorText != null && (!isEmpty || wasValidated))
          Padding(
            padding: const EdgeInsets.only(top: 4.0),
            child: Text(
              errorText!,
              style: const TextStyle(
                color: Colors.red,
                fontSize: 12,
              ),
            ),
          ),
      ],
    );
  }
}
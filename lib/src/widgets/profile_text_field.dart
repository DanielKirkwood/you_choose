import 'package:flutter/material.dart';
import 'package:you_choose/src/util/constants/constants.dart';

class TextFieldWidget extends StatefulWidget {
  final String label;
  final String text;
  final String? errorMessage;
  final bool isPassword;
  final ValueChanged<String> onChanged;

  const TextFieldWidget(
      {super.key,
      required this.label,
      required this.text,
      required this.onChanged,
      this.isPassword = false,
      this.errorMessage});

  @override
  State<TextFieldWidget> createState() => _TextFieldWidgetState();
}

class _TextFieldWidgetState extends State<TextFieldWidget> {
  late final TextEditingController controller;

  @override
  void initState() {
    super.initState();

    controller = TextEditingController(text: widget.text);
  }

  @override
  void dispose() {
    controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
            decoration: InputDecoration(
                border: Constants.formInputBorder,
                errorText: widget.errorMessage),
            obscureText: widget.isPassword
        )
      ],
    );
  }
}

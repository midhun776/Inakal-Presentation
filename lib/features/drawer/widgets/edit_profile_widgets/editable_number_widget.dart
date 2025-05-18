import 'package:flutter/material.dart';
import 'package:inakal/constants/app_constants.dart';

class EditableNumberWidget extends StatefulWidget {
  final TextEditingController controller;
  final bool? editable;
  const EditableNumberWidget({super.key, required this.controller, this.editable});

  @override
  State<EditableNumberWidget> createState() => _EditableNumberWidgetState();
}

class _EditableNumberWidgetState extends State<EditableNumberWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.5,
      child: TextField(
        keyboardType: TextInputType.number,
        controller: widget.controller,
        textAlign: TextAlign.end,
        decoration: const InputDecoration(
          hintText: "Enter value",
          border: InputBorder.none,
          isDense: true,
          hintStyle: TextStyle(fontSize: 16, color: AppColors.grey, fontStyle: FontStyle.italic, fontWeight: FontWeight.w500),
        ),
        enabled: widget.editable ?? true,
        onSubmitted: (value) {
          setState(() {
            widget.controller.text = value;
          });
        },
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
      ),
    );
  }
}

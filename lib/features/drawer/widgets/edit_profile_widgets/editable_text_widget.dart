import 'package:flutter/material.dart';
import 'package:inakal/constants/app_constants.dart';

class EditableTextWidget extends StatefulWidget {
  final TextEditingController controller;
  final bool? justify;

  const EditableTextWidget({
    super.key,
    required this.controller, this.justify, // Make controller required
  });

  @override
  State<EditableTextWidget> createState() => _EditableTextWidgetState();
}

class _EditableTextWidgetState extends State<EditableTextWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.6,
      child: TextField(
        controller: widget.controller,
        textAlign: widget.justify != null ? TextAlign.justify : TextAlign.end,
        decoration: const InputDecoration(
          hintText: "Enter value",
          border: InputBorder.none,
          isDense: true,
          hintStyle: TextStyle(fontSize: 16, color: AppColors.grey, fontStyle: FontStyle.italic, fontWeight: FontWeight.w500),
        ),
        minLines: 1,
        maxLines: null,
        keyboardType: TextInputType.multiline,
        onSubmitted: (value) {
          setState(() {
            widget.controller.text = value;
          });
        },
        style: TextStyle(fontWeight: FontWeight.bold, overflow: TextOverflow.ellipsis, fontSize: 18),
      ),
    );
  }
}

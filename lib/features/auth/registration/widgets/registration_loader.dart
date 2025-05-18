import 'package:flutter/material.dart';
import 'package:inakal/constants/app_constants.dart';

class RegistrationLoader extends StatefulWidget {
  final int progress;
  const RegistrationLoader({super.key, required this.progress});

  @override
  State<RegistrationLoader> createState() => _RegistrationLoaderState();
}

class _RegistrationLoaderState extends State<RegistrationLoader> {
  @override
  Widget build(BuildContext context) {
    return Center(
        child: Container(
      decoration: const BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.all(
          Radius.circular(20),
        ),
      ),
      width: MediaQuery.of(context).size.width / 12 * 4,
      child: Row(
        // mainAxisAlignment: MainAxisAlignment.center,
        children: [
            for (int i = 0; i < widget.progress; i++) Status(),
        ],
      ),
    ));
  }

  Widget Status() {
    return Container(
        width: MediaQuery.of(context).size.width / 12,
        height: 18,
        child: const Card(
          color: AppColors.primaryRed,
        ));
  }
}

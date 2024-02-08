import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController? controller;
  final String? hintText;
  final IconData? prefixIcon;
  final bool? obscureText;
  final Function(String)? onChanged;

  const CustomTextField(
      {super.key,
      this.controller,
      this.hintText,
      this.prefixIcon,
      this.obscureText = false,
      this.onChanged});

  @override
  Widget build(BuildContext context) {
    return TextField(
      obscureText: obscureText ?? false,
      style: Theme.of(context).textTheme.bodyMedium,
      decoration: InputDecoration(
        border: const OutlineInputBorder(
          borderSide: BorderSide(
            color: AppColors.blue,
          ),
        ),
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(
            width: 1,
            color: AppColors.blue,
          ),
        ),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(
            width: 1,
            color: AppColors.blue,
          ),
        ),
        hintText: hintText ?? '',
        prefixIcon: Icon(
          prefixIcon,
          size: 20,
          color: AppColors.darkBlue,
        ),
      ),
    );
  }
}

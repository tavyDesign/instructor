import 'package:flutter/material.dart';

class SectionHeader extends StatelessWidget {
  final String title;
  final Function()? onMorePressed;

  const SectionHeader({super.key, required this.title, this.onMorePressed});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        IconButton(
          onPressed: () {
            if (onMorePressed == null) return;
            onMorePressed!();
          },
          icon: const Icon(Icons.arrow_forward_ios_outlined),
        ),
      ],
    );
  }
}

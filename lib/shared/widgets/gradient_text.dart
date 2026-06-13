import 'package:flutter/material.dart';
import 'package:polymorphism/core/theme/app_tokens.dart';

/// Text filled with the teal→violet accent gradient.
class GradientText extends StatelessWidget {
  const GradientText(
    this.text, {
    required this.style,
    super.key,
    this.gradient = const LinearGradient(colors: [AppColors.accentPrimary, AppColors.accentSecondary]),
    this.textAlign,
  });

  final String text;
  final TextStyle style;
  final Gradient gradient;
  final TextAlign? textAlign;

  @override
  Widget build(BuildContext context) => ShaderMask(
    blendMode: BlendMode.srcIn,
    shaderCallback: (bounds) => gradient.createShader(Offset.zero & bounds.size),
    child: Text(text, style: style, textAlign: textAlign),
  );
}

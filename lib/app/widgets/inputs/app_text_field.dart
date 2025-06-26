import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:project_master_template/app/core/theme/app_dimensions.dart';

class AppTextField extends StatefulWidget {
  const AppTextField({
    super.key,
    this.label,
    this.hint,
    this.errorText,
    this.helperText,
    this.initialValue,
    this.controller,
    this.keyboardType = TextInputType.text,
    this.textInputAction = TextInputAction.done,
    this.obscureText = false,
    this.enabled = true,
    this.readOnly = false,
    this.autofocus = false,
    this.maxLines = 1,
    this.maxLength,
    this.prefixIcon,
    this.suffixIcon,
    this.prefixText,
    this.suffixText,
    this.inputFormatters,
    this.onChanged,
    this.onSubmitted,
    this.onTap,
    this.validator,
    this.contentPadding,
    this.borderRadius,
    this.fillColor,
    this.borderColor,
    this.borderWidth = 1.0,
    this.textStyle,
    this.labelStyle,
    this.hintStyle,
  });
  final String? label;
  final String? hint;
  final String? errorText;
  final String? helperText;
  final String? initialValue;
  final TextEditingController? controller;
  final TextInputType keyboardType;
  final TextInputAction textInputAction;
  final bool obscureText;
  final bool enabled;
  final bool readOnly;
  final bool autofocus;
  final int? maxLines;
  final int? maxLength;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final String? prefixText;
  final String? suffixText;
  final List<TextInputFormatter>? inputFormatters;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final VoidCallback? onTap;
  final String? Function(String?)? validator;
  final EdgeInsetsGeometry? contentPadding;
  final BorderRadius? borderRadius;
  final Color? fillColor;
  final Color? borderColor;
  final double borderWidth;
  final TextStyle? textStyle;
  final TextStyle? labelStyle;
  final TextStyle? hintStyle;

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  late bool _obscureText;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.obscureText;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.label != null) ...[
          AutoSizeText(
            widget.label!,
            style: widget.labelStyle ?? theme.textTheme.labelMedium?.copyWith(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: AppSizes.paddingXS),
        ],
        TextFormField(
          controller: widget.controller,
          initialValue: widget.initialValue,
          keyboardType: widget.keyboardType,
          textInputAction: widget.textInputAction,
          obscureText: _obscureText,
          enabled: widget.enabled,
          readOnly: widget.readOnly,
          autofocus: widget.autofocus,
          maxLines: widget.maxLines,
          maxLength: widget.maxLength,
          inputFormatters: widget.inputFormatters,
          onChanged: widget.onChanged,
          onFieldSubmitted: widget.onSubmitted,
          onTap: widget.onTap,
          validator: widget.validator,
          style: widget.textStyle ?? theme.textTheme.bodyMedium,
          decoration: InputDecoration(
            hintText: widget.hint,
            hintStyle:
                widget.hintStyle ??
                theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurface.withAlpha(153)),
            errorText: widget.errorText,
            helperText: widget.helperText,
            prefixIcon: widget.prefixIcon,
            suffixIcon: _buildSuffixIcon(),
            prefixText: widget.prefixText,
            suffixText: widget.suffixText,
            filled: true,
            fillColor: widget.fillColor ?? theme.colorScheme.surface,
            contentPadding: widget.contentPadding ?? AppSpacing.m,
            border: _buildBorder(theme),
            enabledBorder: _buildBorder(theme),
            focusedBorder: _buildBorder(theme, isFocused: true),
            errorBorder: _buildBorder(theme, isError: true),
            focusedErrorBorder: _buildBorder(theme, isError: true, isFocused: true),
            disabledBorder: _buildBorder(theme, isDisabled: true),
          ),
        ),
      ],
    );
  }

  Widget? _buildSuffixIcon() {
    if (widget.obscureText) {
      return IconButton(
        icon: Icon(_obscureText ? Icons.visibility : Icons.visibility_off),
        onPressed: () {
          setState(() {
            _obscureText = !_obscureText;
          });
        },
      );
    }
    return widget.suffixIcon;
  }

  OutlineInputBorder _buildBorder(
    ThemeData theme, {
    bool isFocused = false,
    bool isError = false,
    bool isDisabled = false,
  }) {
    Color borderColor;

    if (isError) {
      borderColor = theme.colorScheme.error;
    } else if (isFocused) {
      borderColor = theme.colorScheme.primary;
    } else if (isDisabled) {
      borderColor = theme.colorScheme.onSurface.withAlpha(31);
    } else {
      borderColor = widget.borderColor ?? theme.colorScheme.outline;
    }

    return OutlineInputBorder(
      borderRadius: widget.borderRadius ?? AppBorderRadius.s,
      borderSide: BorderSide(
        color: borderColor,
        width: isFocused || isError ? widget.borderWidth + 0.5 : widget.borderWidth,
      ),
    );
  }
}

class AppSearchField extends StatelessWidget {
  const AppSearchField({super.key, this.hint, this.controller, this.onChanged, this.onClear, this.margin});
  final String? hint;
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onClear;
  final EdgeInsetsGeometry? margin;

  @override
  Widget build(BuildContext context) => Container(
    margin: margin ?? AppSpacing.m,
    child: AppTextField(
      controller: controller,
      hint: hint ?? 'Search...',
      prefixIcon: const Icon(Icons.search),
      suffixIcon:
          (controller?.text.isNotEmpty ?? false)
              ? IconButton(
                icon: const Icon(Icons.clear),
                onPressed: () {
                  controller?.clear();
                  onClear?.call();
                },
              )
              : null,
      onChanged: onChanged,
      textInputAction: TextInputAction.search,
    ),
  );
}

import 'package:flutter/material.dart';
import 'package:flutter_number_captcha/number_captcha_widget.dart';

class CaptchaForm extends StatelessWidget {
  const CaptchaForm({
    Key? key,
    this.titleText,
    this.placeholderText = 'Enter Number',
    this.checkCaption = 'Check',
    this.invalidText = 'Invalid Code',
    this.accentColor,
    this.onVerified,
    this.width,
    this.height = 48,
    this.borderRadius = 8,
    this.showTitle = true,
    this.showCheckButton = false,
  }) : super(key: key);

  final String? titleText;
  final String? placeholderText;
  final String? checkCaption;
  final String? invalidText;
  final Color? accentColor;
  final Function(bool)? onVerified;
  final double? width;
  final double height;
  final double borderRadius;
  final bool showTitle;
  final bool showCheckButton;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: NumberCaptchaWidget(
        titleText: titleText,
        placeholderText: placeholderText!,
        checkCaption: checkCaption!,
        invalidText: invalidText!,
        accentColor: accentColor,
        onVerified: onVerified,
        height: height,
        borderRadius: borderRadius,
        showTitle: showTitle,
        showCheckButton: showCheckButton,
      ),
    );
  }
}

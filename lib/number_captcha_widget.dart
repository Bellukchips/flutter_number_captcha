import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'number_captcha.dart';

class NumberCaptchaWidget extends StatefulWidget {
  const NumberCaptchaWidget({
    Key? key,
    this.titleText,
    required this.placeholderText,
    required this.checkCaption,
    required this.invalidText,
    this.accentColor,
    this.onVerified,
    this.height = 48,
    this.borderRadius = 8,
    this.showTitle = true,
    this.showCheckButton = false,
  }) : super(key: key);

  final String? titleText;
  final String placeholderText;
  final String checkCaption;
  final String invalidText;
  final Color? accentColor;
  final Function(bool)? onVerified;
  final double height;
  final double borderRadius;
  final bool showTitle;
  final bool showCheckButton;

  @override
  State<NumberCaptchaWidget> createState() => _NumberCaptchaWidgetState();
}

class _NumberCaptchaWidgetState extends State<NumberCaptchaWidget> {
  final TextEditingController textController = TextEditingController();
  String code = '';
  bool? isValid;

  @override
  void initState() {
    super.initState();
    generateCode();
  }

  void generateCode() {
    Random random = Random();
    code = (random.nextInt(9000) + 1000).toString();
    textController.clear();
    setState(() {
      isValid = null;
    });
  }

  void checkCode() {
    if (textController.text == code) {
      setState(() {
        isValid = true;
      });
      widget.onVerified?.call(true);
    } else {
      setState(() {
        isValid = false;
      });
      widget.onVerified?.call(false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = widget.accentColor ?? Theme.of(context).primaryColor;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Title (optional)
        if (widget.showTitle && widget.titleText != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Text(
              widget.titleText!,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),
          ),

        // Main Row
        SizedBox(
          height: widget.height,
          child: Row(
            children: [
              // TextField
              Expanded(
                flex: 3,
                child: TextField(
                  controller: textController,
                  keyboardType: TextInputType.number,
                  maxLength: 4,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  style: TextStyle(fontSize: 16),
                  decoration: InputDecoration(
                    hintText: widget.placeholderText,
                    counterText: '',
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 0,
                    ),
                    isDense: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(widget.borderRadius),
                      borderSide: BorderSide(
                        color: isValid == false ? Colors.red : Colors.grey[300]!,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(widget.borderRadius),
                      borderSide: BorderSide(
                        color: isValid == false ? Colors.red : Colors.grey[300]!,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(widget.borderRadius),
                      borderSide: BorderSide(
                        color: isValid == false ? Colors.red : color,
                        width: 2,
                      ),
                    ),
                  ),
                  onChanged: (value) {
                    if (value.length == 4) {
                      checkCode();
                    } else {
                      setState(() {
                        isValid = null;
                      });
                    }
                  },
                  onSubmitted: (value) {
                    checkCode();
                  },
                ),
              ),

              SizedBox(width: 8),

              // Captcha Display
              Expanded(
                flex: 2,
                child: Container(
                  height: widget.height,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(widget.borderRadius),
                    border: Border.all(color: Colors.grey[300]!),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(widget.borderRadius),
                    child: NumberCaptcha(code),
                  ),
                ),
              ),

              SizedBox(width: 4),

              // Refresh Button
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(widget.borderRadius),
                ),
                child: IconButton(
                  icon: Icon(Icons.refresh, color: Colors.white, size: 20),
                  onPressed: generateCode,
                  padding: EdgeInsets.zero,
                ),
              ),

              // Check Button (optional)
              if (widget.showCheckButton) ...[
                SizedBox(width: 4),
                Container(
                  height: 40,
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(widget.borderRadius),
                  ),
                  child: TextButton(
                    onPressed: checkCode,
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.symmetric(horizontal: 12),
                      minimumSize: Size.zero,
                    ),
                    child: Text(
                      widget.checkCaption,
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),

        // Error Text
        if (isValid == false)
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(
              widget.invalidText,
              style: TextStyle(
                color: Colors.red,
                fontSize: 12,
              ),
            ),
          ),
      ],
    );
  }

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }
}
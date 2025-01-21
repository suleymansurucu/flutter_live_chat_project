import 'package:flutter/material.dart';

class SocialLogInButton extends StatelessWidget {
  final String buttonText;
  final Color buttonColor;
  final Color textColor;
  final double radius;
  final double? height;
  final Widget buttonIcon;
  final VoidCallback onPressed;

  const SocialLogInButton(
      {super.key,
      required this.buttonText,
      required this.buttonColor,
      required this.textColor,
      this.radius = 16,
      this.height = 50,
      required this.buttonIcon,
      required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      child: SizedBox(
        height: height,
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(radius),
            ),
            backgroundColor: buttonColor,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              buttonIcon,
              Text(
                buttonText,
                style: TextStyle(color: textColor),
              ),
              Opacity(
                opacity: 0,
                child: buttonIcon,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../theme/colors.dart';

typedef LoginButtonBuilder = LoginButton Function(
    String title,
    bool showActions,
    );

class LoginButton extends ConsumerWidget {
  final VoidCallback onPressed;
  const LoginButton({
    super.key,
    this.title,
    this.showActions = true,
    required this.onPressed,
  });

  final String? title;

  final bool showActions;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        height: MediaQuery.of(context).size.height * 0.05,
        width: MediaQuery.of(context).size.width * 0.6,
        decoration: BoxDecoration(
          color: Colors.yellow,
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: Padding(
          padding: const EdgeInsets.only(left: 8.0, right: 8.0),
          child: Row(
            mainAxisAlignment: (showActions) ? MainAxisAlignment.spaceBetween : MainAxisAlignment.center,
            children: [
              Text(
                title!,
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold),
              ),
              if (showActions) Icon(Icons.arrow_forward, color: Colors.white, size: 30), // Right arrow icon
            ],
          ),
        ),
      ),
    );
  }
}
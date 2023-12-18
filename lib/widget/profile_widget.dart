import 'package:flutter/material.dart';

class GradientButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final List<Color> colors; // Define colors as a list of Color objects

  const GradientButton({
    Key? key,
    required this.text,
    required this.onPressed,
    required this.colors, // Expect a list of colors
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(4), // Space around the button
      constraints: BoxConstraints.tightFor(
          width: 180, height: 50), // Fixed width and height
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: colors, // Gradient colors
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: Colors.white, width: 2.0),
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          primary: Colors.transparent,
          onPrimary: Colors.white,
          textStyle: TextStyle(fontSize: 16),
          padding: EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12), // Inner padding for the button's child
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          elevation: 0,
        ).copyWith(
          overlayColor: MaterialStateProperty.all(Colors.transparent),
        ),
        child: FittedBox(
          fit: BoxFit.fitWidth,
          child: Text(
            text,
            style: TextStyle(
              color: Colors.black,
              fontSize: 20,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w400,
              height: 0,
              letterSpacing: 0.20,
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

class GradientButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const GradientButton({
    Key? key,
    required this.text,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(
                0xFFf6a5c1), // Adjust to the light pink color from the gradient
            Color(
                0xFF5fadcf), // Adjust to the light blue color from the gradient
          ],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius:
            BorderRadius.circular(30), // Adjust border color and width
      ),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          primary: Colors
              .transparent, // Ensures the button background is transparent
          onSurface: Colors.white,
          shadowColor: Colors.transparent, // No shadow for the button
          shape: RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(30), // Same roundness as the container
          ),
          padding: EdgeInsets.zero, // No additional padding inside the button
        ),
        onPressed: onPressed, // The action to perform on button tap
        child: Ink(
          // Use Ink widget to apply the same gradient and border to the button
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(
                    0xFFf6a5c1), // Adjust to the light pink color from the gradient
                Color(
                    0xFF5fadcf), // Adjust to the light blue color from the gradient
              ],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
            borderRadius:
                BorderRadius.circular(30), // Adjust border color and width
          ),
          child: Container(
            alignment: Alignment.center,
            constraints: BoxConstraints(
                minWidth: double.infinity,
                minHeight: 50), // Set minimum width and height of the button
            child: Text(
              text,
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Color.fromRGBO(0, 0, 0, 1),
                  fontSize: 20,
                  fontWeight: FontWeight
                      .bold), // Adjust text style to ensure visibility
            ),
          ),
        ),
      ),
    );
  }
}


// Usage example:

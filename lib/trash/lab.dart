import 'package:flutter/material.dart';

Widget lol(BuildContext context) {
  return ElevatedButton(
    onPressed: () {
      // Your press event here.
    },
    style: ButtonStyle(
      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
          side: BorderSide(color: Colors.blue, width: 2),
        ),
      ),
      backgroundColor: MaterialStateProperty.resolveWith<Color>(
        (Set<MaterialState> states) {
          if (states.contains(MaterialState.pressed)) {
            return Theme.of(context).colorScheme.primary.withOpacity(0.5);
          }
          return Colors.blue; // Use the component's default.
        },
      ),
      padding: MaterialStateProperty.all(EdgeInsets.all(20)),
    ),
    child: Ink(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.green, Colors.blue],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Container(
        constraints: BoxConstraints(
            minWidth: 88.0, minHeight: 36.0), // min sizes for Material buttons
        alignment: Alignment.center,
        child: Text(
          'Gradient Button with outline',
          textAlign: TextAlign.center,
        ),
      ),
    ),
  );
}

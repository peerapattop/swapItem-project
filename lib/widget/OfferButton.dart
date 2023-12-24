import 'package:flutter/material.dart';

class OfferButton extends StatefulWidget {
  final int index;
  final Map<dynamic, dynamic> offerData;
  final Function onSelect;

  const OfferButton({
    Key? key,
    required this.index,
    required this.offerData,
    required this.onSelect,
  }) : super(key: key);

  @override
  _OfferButtonState createState() => _OfferButtonState();
}

class _OfferButtonState extends State<OfferButton> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        widget.onSelect(widget.index, widget.offerData);
      },
      child: Container(
        width: 40,
        height: 40,
        margin: EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: Colors.blue, // logic to determine color based on selection,
          shape: BoxShape.circle,
          border: Border.all(
            color: Colors.black,
            width: 1.0,
          ),
        ),
        child: Center(
          child: Text(
            '${widget.index + 1}',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}

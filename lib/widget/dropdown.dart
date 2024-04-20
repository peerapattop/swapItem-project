import 'package:flutter/material.dart';

class MultiSelectableButtonList extends StatefulWidget {
  const MultiSelectableButtonList({Key? key}) : super(key: key);

  @override
  _MultiSelectableButtonListState createState() =>
      _MultiSelectableButtonListState();
}

class _MultiSelectableButtonListState extends State<MultiSelectableButtonList> {
  List<String> selectedButtons = [];

  void toggleButton(String value) {
    setState(() {
      if (selectedButtons.contains(value)) {
        selectedButtons.remove(value);
      } else {
        selectedButtons.add(value);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          children: [
            for (String item in [
              "อุปกรณ์อิเล็กทรอนิกส์",
            ])
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  onPressed: () {
                    toggleButton(item);
                  },
                  style: ButtonStyle(
                    backgroundColor: selectedButtons.contains(item)
                        ? MaterialStateProperty.all<Color>(Colors.greenAccent)
                        : null,
                  ),
                  child: Text(item),
                ),
              ),
          ],
        ),
        const SizedBox(height: 16),
        Text(
          'ปุ่มที่ถูกเลือก: ${selectedButtons.join(", ")}',
          style: TextStyle(fontSize: 16),
        ),
      ],
    );
  }
}

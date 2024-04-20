import 'package:flutter/material.dart';

class MultiSelectableButtonList extends StatefulWidget {
  final String selectedItem;
  const MultiSelectableButtonList({Key? key, required this.selectedItem})
      : super(key: key);

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
    String dataInType = widget.selectedItem;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (dataInType == 'เสื้อผ้าแฟชั่นผู้ชาย')
          Wrap(
            runSpacing: 10.0,
            spacing: 10.0,
            children: [
              for (String item in [
                "ทั้งหมด",
                "เสื้อเชิ้ตผู้ชาย",
                "เสื้อยืด",
                "กางเกงขาสั้น",
                "กางเกงขายาว",
                "เสื้อโปโลผู้ชาย",
                "ผ้ายีนส์",
                "เสื้อนอกผู้ชาย",
                "เครื่องแบบ",
              ])
                ElevatedButton(
                  onPressed: () {
                    toggleButton(item);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: selectedButtons.contains(item) ? Colors.cyan : null,
                  ),
                  child: Text(item,style: TextStyle(color: Colors.black),),
                ),

            ],
          ),
        const SizedBox(height: 16),
        Text(
          'ค้นหา: ${selectedButtons.join(", ")}',
          style: const TextStyle(fontSize: 16),
        ),
      ],
    );
  }
}

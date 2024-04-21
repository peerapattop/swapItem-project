import 'package:flutter/material.dart';

Widget menClothesDropdown(void Function(String?)? onChanged) {
  // Data for men's clothes dropdown
  final List<String> menClothes = [
    "กางเกงยีนส์",
    "เสื้อฮู้ดดี้",
    "สเวตเตอร์และคาร์ดิแกน",
    "เสื้อแจ็คเกตและเสื้อโค้ท",
    "สูท",
    "กางเกงขายาว",
    "กางเกงขาสั้น",
    "เสื้อ",
    "ชุดชั้นในชาย",
    "ชุดนอน",
    "ชุดเซ็ต",
    "ชุดพื้นเมืองชาย",
    "คอสเพลย์",
    "ยูนิฟอร์ม",
    "อื่นๆ",
    "ถุงเท้า"
  ];

  // Selected item state variable
  String _selectedItem = menClothes[0]; // Default selection

  return DropdownButton<String>(
    // Dropdown value
    value: _selectedItem,
    // Dropdown items
    items: menClothes.map((String value) {
      return DropdownMenuItem<String>(
        value: value,
        child: Text(value),
      );
    }).toList(),
    // Dropdown onChanged function (handle nullable value)
    onChanged: onChanged != null ? (String? newValue) => onChanged(newValue!) : null,
  );
}

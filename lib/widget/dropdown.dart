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
    List<String> buttonItems = [];

    if (dataInType == 'เสื้อผ้าแฟชั่นผู้ชาย') {
      buttonItems = [
        "ทั้งหมด",
        "เสื้อเชิ้ตผู้ชาย",
        "เสื้อยืด",
        "กางเกงขาสั้น",
        "กางเกงขายาว",
        "เสื้อโปโลผู้ชาย",
        "ผ้ายีนส์",
        "เสื้อนอกผู้ชาย",
        "เครื่องแบบ",
      ];
    } else if (dataInType == 'เสื้อผ้าแฟชั่นผู้หญิง') {
      buttonItems = [
        "ทั้งหมด",
        "เสื้อ",
        "กางเกง",
        "กระโปรง",
        "ผ้ายีนส์",
        "กางเกงขายาว",
        "เสื้อโปโลผู้หญิง",
        "เสื้อยืดผู้หญิง",
        "เสื้อนอกผู้หญิง",
        "เดรส",
      ];
    } else if (dataInType == 'กระเป๋า') {
      buttonItems = [
        'ทั้งหมด',
        'กระเป๋าถือ',
        'กระเป๋าสะพายข้าง',
        'กระเป๋าสตางค์',
        'กระเป๋าผ้า',
        'กระเป๋าคาดอก',
        'กระเป๋าเป้',
        'กระเป๋าเดินทาง',
        'อุปกรณ์เสริมกระเป๋า',
      ];
    } else if (dataInType == 'รองเท้าผู้ชาย') {
      buttonItems = [
        'ทั้งหมด',
        'รองเท้าผ้าใบ',
        'รองเท้าหนังแบบผูกเชือก',
        'สลิปออน',
        'รองเท้าบูทและรองเท้าหุ้มข้อ',
        'รองเท้าหนังแบบสวม',
        'รองเท้าเซฟตี้',
        'รองเท้าแตะผู้ชาย',
        'ถุงเท้า',
        'อุปกรณ์เสริม'
      ];
    } else if (dataInType == 'รองเท้าผู้หญิง') {
      buttonItems = [
        'ทั้งหมด',
        'รองเท้าส้นสูง',
        'รองเท้าส้นแบน',
        'รองเท้าผ้าใบ',
        'รองเท้าบู้ทและรองเท้าหุ้มข้อ',
        'รองเท้าลำลอง',
        'รองเท้าแตะผู้หญิง',
        'ถุงเท้าและถุงน่อง'
      ];
    } else if (dataInType == 'นาฬิกาและแว่นตา') {
      buttonItems = [
        'ทั้งหมด',
        'แว่นตา',
        'แว่นตากันแดด',
        'อุปกรณ์เสริมสำหรับแว่นตา',
        'นาฬิกาผู้หญิง',
        'นาฬิกาผู้ชาย',
        'อุปกรณ์สำหรับนาฬิกา',
      ];
    } else if (dataInType == 'มือถือและอุปกรณ์เสริม') {
      buttonItems = [
        'ทั้งหมด',
        'โทรศัพท์มือถือ',
        'แท็บเล็ต',
        'เคสและซองมือถือ',
        'อุปกรณ์เสริมมือถือ',
        'แบตเตอรี่สำรอง'
      ];
    } else if (dataInType == 'เครื่องใช้ไฟฟ้าภายในบ้าน') {
      buttonItems = [
        'ทั้งหมด',
        'ไมโครเวฟและเตาอบ',
        'ตู้เย็น',
        'พัดลม',
        'พัดลมไอเย็น',
        'เตารีด',
        'เครื่องดูดฝุ่น'
      ];
    } else if (dataInType == 'กล้องและอุปกรณ์ถ่ายภาพ') {
      buttonItems = [
        'ทั้งหมด',
        'กล้อง',
        'กล้องแอคชั่น',
        'กล้องวงจรปิด',
        'เลนส์',
        'มมโมรี่การ์ด',
        'อุปกรณ์เสริมกล้อง',
      ];
    } else if (dataInType == 'คอมพิวเตอร์และอุปกรณ์เสริม') {
      buttonItems = [
        'ทั้งหมด',
        'อุปกรณ์เสริมคอมพิวเตอร์',
        'แลปท๊อป',
        'คอมพิวเตอร์ตั้งโต๊ะ'
            'อุปกรณ์สำหรับเล่นเกม',
        'ชิ้นส่วนคอมพิวเตอร์'
      ];
    } else if (dataInType == 'ของเล่น สินค้าแม่และเด็ก') {
      buttonItems = [
        'ทั้งหมด',
        'อุปกรณ์สำหรับเด็ก',
        'เป้อุ้ม',
        'รถเข็น',
        'คาร์ซีท',
        'เสื้อผ้าเด็กแรกเกิด',
        'เสื้อผ้าเด็กผู้หญิง',
        'เสื้อผ้าเด็กผู้ชาย',
        'ของเล่นและของสะสม',
        'ตุ๊กตา',
      ];
    } else if (dataInType == 'เครื่องเขียน หนังสือ และงานอดิเรก') {
      buttonItems = [
        'ทั้งหมด',
        'อุปกรณ์สำนักงาน',
        'อุปกรณ์เพื่อการบรรจุ',
        ',อุปกรณ์เครื่องเขียน',
        'หนังสือ'
      ];
    } else if (dataInType == 'อุปกรณ์กีฬา') {
      buttonItems = [
        'ทั้งหมด',
        'อุปกรณ์ฟิสเนสและออกกำลังกาย',
        'รองเท้ากีฬา',
        'เสื้อผ้ากีฬา',
        'กอล์ฟ',
        'แบดมินตัน',
        'ปิงปอง',
        'บาสเกตบอล',
        'ฟุตบอล',
      ];
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: 8.0, // ระยะห่างระหว่างปุ่ม
          children: [
            for (String item in buttonItems)
              Padding(
                padding: EdgeInsets.symmetric(vertical: 4.0),
                child: ElevatedButton(
                  onPressed: () {
                    toggleButton(item);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        selectedButtons.contains(item) ? Colors.cyan : null,
                  ),
                  child: Text(item,style: const TextStyle(color: Colors.black),),
                ),
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

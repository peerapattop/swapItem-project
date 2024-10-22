import 'package:flutter/material.dart';
import 'package:swapitem/0_btnnt.dart';

import '../home_page.dart';

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
  List<String> menClothes = [
    "ทั้งหมด",
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
  ]; //เสื้อผ้าผู้ชาย
  List<String> womenClothes = [
    "ทั้งหมด",
    "เสื้อฮู้ดและ เสื้อสเวตเชิ้ต",
    "ชุดเซ็ต",
    "ชุดชั้นใน",
    "ชุดนอน",
    "เสื้อผ้าคนท้อง",
    "เสื้อพื้นเมือง",
    "ชุดแต่งกาย",
    "อื่นๆ",
    "ถุงเท้า และถุงน่อง"
  ]; //เสื้อผ้าผู้หญิง
  List<String> accessories = [
    "ทั้งหมด",
    "แว่นตา",
    "เครื่องประดับผม",
    "เครื่องประดับอื่นๆ",
    "โลหะมีค่าเพื่อการลงทุน",
    "แหวน",
    "ต่างหู",
    "กำไลข้อเท้า",
    "สร้อยคอ",
    "เซ็ตเครื่องประดับ",
    "ผ้าพันคอและผ้าคลุมไหล่",
    "ถุงมือ",
    "กำไลข้อมือ",
    "หมวก",
    "เข็มขัด",
    "เนคไท, หูกระต่าย",
    "อื่นๆ"
  ]; //เครื่องประดับ
  List<String> homeAppliances = [
    // "เครื่องใช้ไฟฟ้าภายในบ้าน",
    "ทั้งหมด",
    "โปรเจคเตอร์และ อะไหล่",
    "เครื่องใช้ไฟฟ้าขนาดเล็กภายในบ้าน",
    "เครื่องใช้ไฟฟ้าขนาดใหญ่",
    "ทีวีและ อุปกรณ์ที่เกี่ยวข้อง",
    "เครื่องใช้ไฟฟ้าในครัว",
    "แผงวงจรและ อะไหล่",
    "แบตเตอรี่",
    "รีโมต คอนโทรล",
    "อื่นๆ"
  ];
  List<String> womenShoes = [
    "ทั้งหมด",
    "รองเท้าบูท",
    "รองเท้าผ้าใบ",
    "รองเท้าส้นแบน",
    "รองเท้าส้นสูง",
    "รองเท้าส้นตึก",
    "รองเท้าแตะ",
    "ผลิตภัณฑ์และอุปกรณ์เสริมสำหรับรองเท้า",
    "อื่นๆ"
  ]; //"รองเท้าผู้หญิง",
  List<String> menShoes = [
    "ทั้งหมด",
    "รองเท้าบูท",
    "รองเท้าผ้าใบ",
    "รองเท้าผ้าใบแบบสวมและรองเท้าเปิดส้น",
    "รองเท้าโลฟเฟอร์",
    "รองเท้าหนังแบบผูกเชือก",
    "รองเท้าแตะ",
    "อุปกรณ์เสริมสำหรับรองเท้า",
    "อื่นๆ"
  ]; //"รองเท้าผู้ชาย",
  List<String> electronics = [
    "ทั้งหมด",
    "ซิมการ์ด",
    "แท็บเล็ต",
    "โทรศัพท์มือถือ",
    "อุปกรณ์สวมใส่",
    "อุปกรณ์เสริม",
    "วิทยุสื่อสาร",
    "อื่นๆ"
  ]; //มือถือและอุปกรณ์เสริม
  List<String> muslimClothing = [
    "ทั้งหมด",
    "เสื้อผ้ามุสลิมผู้หญิง",
    "เสื้อผ้ามุสลิมผู้ชาย",
    "เสื้อผ้ามุสลิมเด็ก",
    "เสื้อชั้นนอก",
    "ชุดเซ็ต",
    "อื่นๆ"
  ]; //เสื้อผ้ามุสลิม
  List<String> travelGear = [
    "ทั้งหมด",
    "กระเป๋าเดินทางล้อลาก",
    "กระเป๋าสำหรับเดินทาง",
    "อุปกรณ์เสริมสำหรับเดินทาง",
    "อื่นๆ"
  ]; //"กระเป๋าเดินทาง",
  List<String> womenBags = [
    "ทั้งหมด",
    "กระเป๋าเป้",
    "กระเป๋าคอมพิวเตอร์",
    "คลัทช์ & กระเป๋าคล้องมือ",
    "กระเป๋าคาดอก",
    "กระเป๋าผ้า",
    "กระเป๋าถือ",
    "กระเป๋าสะพายข้าง",
    "กระเป๋าสตางค์",
    "อุปกรณ์เสริมกระเป๋า",
    "อื่นๆ"
  ]; //"กระเป๋าผู้หญิง",
  List<String> menBags = [
    "ทั้งหมด",
    "กระเป๋าเป้",
    "กระเป๋าคอมพิวเตอร์",
    "กระเป๋าผ้า",
    "กระเป๋าเอกสาร",
    "คลัทช์",
    "กระเป๋าคาดอก",
    "กระเป๋าสะพายข้าง",
    "กระเป๋าสตางค์",
    "อื่นๆ"
  ]; // "กระเป๋าผู้ชาย",
  List<String> watches = [
    "ทั้งหมด",
    "นาฬิกาผู้หญิง",
    "นาฬิกาผู้ชาย",
    "นาฬิกาคู่",
    "อุปกรณ์เสริมสำหรับนาฬิกา",
    "อื่นๆ"
  ]; // "นาฬิกา",
  List<String> audioEquipment = [
    "ทั้งหมด",
    "หูฟัง",
    "เครื่องเล่นวิดีโอ, เสียง และเครื่องบันทึกเสียง",
    "ไมโครโฟน",
    "เครื่องขยายเสียง และ มิกเซอร์",
    "เครื่องเสียงภายในบ้าน",
    "สายเคเบิลและอุปกรณ์แปลงสัญญาณ",
    "อื่นๆ"
  ]; // "เครื่องเสียง",
  List<String> gamingEquipment = [
    "ทั้งหมด",
    "เครื่องเกม",
    "อุปกรณ์เสริมเกม",
    "แผ่นและตลับเกม",
    "อื่นๆ"
  ]; //"เกมและอุปกรณ์เสริม",
  List<String> camerasAndDrones = [
    "ทั้งหมด",
    "กล้อง",
    "กล้องวงจรปิด",
    "เลนส์",
    "อุปกรณ์เสริมเลนส์",
    "อุปกรณ์เสริมกล้อง",
    "อุปกรณ์ดูแลกล้อง",
    "โดรน",
    "อุปกรณ์เสริมโดรน",
    "อื่นๆ"
  ]; //"กล้องและโดรน",
  List<String> homeObject = [
    "ทั้งหมด",
    "เทียนหอม และน้ำมันหอมระเหย",
    "ห้องน้ำ",
    "ห้องนอน",
    "อุปกรณ์ตกแต่งบ้าน",
    "เครื่องอุ่นมือ ถุงน้ำร้อน และถุงน้ำแข็ง",
    "เฟอร์นิเจอร์",
    "สวน",
    "เครื่องมือและอุปกรณ์ปรับปรุงบ้าน",
    "อุปกรณ์ซักรีดและผลิตภัณฑ์ดูแลบ้าน",
    "เครื่องครัว",
    "เครื่องใช้บนโต๊ะอาหาร",
    "โคมไฟและอุปกรณ์ให้แสงสว่าง",
    "อุปกรณ์รักษาความปลอดภัย",
    "อุปกรณ์สำหรับจัดเก็บ",
    "อุปกรณ์งานปาร์ตี้",
    "สินค้าเกี่ยวกับฮวงจุ้ยและศาสนา",
    "อื่นๆ"
  ]; // "เครื่องใช้ในบ้าน",
  List<String> outdoorSports = [
    "ทั้งหมด",
    "อุปกรณ์เล่นกีฬาและกิจกรรมกลางแจ้ง",
    "รองเท้ากีฬา",
    "เสื้อผ้ากีฬา",
    "อุปกรณ์เสริมสำหรับเล่นกีฬาและกิจกรรมกลางแจ้ง",
    "สินค้าอื่นๆ"
  ]; // "กีฬาและกิจกรรมกลางแจ้ง",
  List<String> stationery = [
    "ทั้งหมด",
    "อุปกรณ์ห่อของขวัญ",
    "อุปกรณ์การเขียนและลบคำผิด",
    "อุปกรณ์สำนักงานและโรงเรียน",
    "อุปกรณ์ศิลปะ",
    "สมุดโน๊ตและกระดาษ",
    "จดหมายและซองจดหมาย",
    "สินค้าอื่นๆ"
  ]; // "เครื่องเขียน",
  List<String> hobbiesAndCollectibles = [
    "ทั้งหมด",
    "ของสะสม",
    "ของที่ระลึก",
    "ของเล่นและเกม",
    "ซีดี ดีวีดี",
    "เครื่องดนตรีและอุปกรณ์เสริม",
    "แผ่นเสียง",
    "อัลบั้มรูป",
    "งานปัก",
    "อื่นๆ"
  ]; // "งานอดิเรกและของสะสม",
  List<String> booksAndMagazines = [
    "ทั้งหมด",
    "นิตยสารและหนังสือพิมพ์",
    "หนังสือ",
    "หนังสืออิเล็กทรอนิกส์",
    "อื่นๆ"
  ]; // "หนังสือและนิตยสาร",
  List<String> computersAndAccessories = [
    "ทั้งหมด",
    "คอมพิวเตอร์แบบตั้งโต๊ะ",
    "หน้าจอคอมพิวเตอร์",
    "อุปกรณ์คอมพิวเตอร์",
    "อุปกรณ์เก็บข้อมูล",
    "อุปกรณ์เน็ตเวิร์ก",
    "โปรแกรมคอมพิวเตอร์",
    "เครื่องใช้สำนักงาน",
    "ปริ้นเตอร์และอุปกรณ์เสริม",
    "อุปกรณ์ต่อพ่วงและอุปกรณ์เสริม",
    "คีย์บอร์ดและเมาส์",
    "แล็ปท็อป",
    "อื่น ๆ"
  ]; //"คอมพิวเตอร์และอุปกรณ์เสริม",
  List<String> any = ['อื่นๆ'];
  List<String> newList = [];

  @override
  initState() {
    check();
    super.initState();
  }

  void check() {
    if (widget.selectedItem == "เสื้อผ้าผู้ชาย") {
      newList = menClothes;
    } else if (widget.selectedItem == "เสื้อผ้าผู้หญิง") {
      newList = womenClothes;
    } else if (widget.selectedItem == "เครื่องประดับ") {
      newList = accessories;
    } else if (widget.selectedItem == "เครื่องใช้ในบ้าน") {
      newList = homeObject;
    } else if (widget.selectedItem == "เครื่องใช้ไฟฟ้าภายในบ้าน") {
      newList = homeAppliances;
    } else if (widget.selectedItem == "รองเท้าผู้หญิง") {
      newList = womenShoes;
    } else if (widget.selectedItem == "รองเท้าผู้ชาย") {
      newList = menShoes;
    } else if (widget.selectedItem == "มือถือและอุปกรณ์เสริม") {
      newList = electronics;
    } else if (widget.selectedItem == "เสื้อผ้ามุสลิม") {
      newList = muslimClothing;
    } else if (widget.selectedItem == "กระเป๋าเดินทาง") {
      newList = travelGear;
    } else if (widget.selectedItem == "กระเป๋าผู้หญิง") {
      newList = womenBags;
    } else if (widget.selectedItem == "กระเป๋าผู้ชาย") {
      newList = menBags;
    } else if (widget.selectedItem == "นาฬิกา") {
      newList = watches;
    } else if (widget.selectedItem == "เครื่องเสียง") {
      newList = audioEquipment;
    } else if (widget.selectedItem == "เกมและอุปกรณ์เสริม") {
      newList = gamingEquipment;
    } else if (widget.selectedItem == "กล้องและโดรน") {
      newList = camerasAndDrones;
    } else if (widget.selectedItem == "เครื่องใช้ในบ้าน") {
      newList = homeObject;
    } else if (widget.selectedItem == "กีฬาและกิจกรรมกลางแจ้ง") {
      newList = outdoorSports;
    } else if (widget.selectedItem == "เครื่องเขียน") {
      newList = stationery;
    } else if (widget.selectedItem == "งานอดิเรกและของสะสม") {
      newList = hobbiesAndCollectibles;
    } else if (widget.selectedItem == "หนังสือและนิตยสาร") {
      newList = booksAndMagazines;
    } else if (widget.selectedItem == "คอมพิวเตอร์และอุปกรณ์เสริม") {
      newList = computersAndAccessories;
    } else if (widget.selectedItem == 'อื่นๆ') {
      newList = any;
    }
  }

  void toggleButton(String value) {
    setState(() {
      if (value == 'ทั้งหมด') {
        if (!selectedButtons.contains('ทั้งหมด')) {
          selectedButtons.clear();
          selectedButtons.add('ทั้งหมด');
        }
      } else {
        if (selectedButtons.contains('ทั้งหมด')) {
          selectedButtons.clear();
        }
        if (selectedButtons.contains(value)) {
          selectedButtons.remove(value);
        } else {
          selectedButtons.add(value);
        }
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
        'เมมโมรี่การ์ด',
        'อุปกรณ์เสริมกล้อง',
      ];
    } else if (dataInType == 'คอมพิวเตอร์และอุปกรณ์เสริม') {
      buttonItems = [
        'ทั้งหมด',
        'อุปกรณ์เสริมคอมพิวเตอร์',
        'แลปท๊อป',
        'คอมพิวเตอร์ตั้งโต๊ะ',
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
        'อุปกรณ์เครื่องเขียน',
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
            for (String item in newList)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: ElevatedButton(
                  onPressed: () {
                    toggleButton(item);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        selectedButtons.contains(item) ? Colors.cyan : null,
                  ),
                  child: Text(
                    item,
                    style: const TextStyle(color: Colors.black),
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 16),
        Text(
          'ค้นหา: ${widget.selectedItem}  ${selectedButtons.join(", ")}',
          style: const TextStyle(fontSize: 16),
        ),
        const SizedBox(height: 15),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text(
                'ยกเลิก',
                style:
                    TextStyle(color: Colors.black, fontWeight: FontWeight.w500),
              ),
            ),
            const SizedBox(width: 10),
            ElevatedButton.icon(
              icon: const Icon(
                Icons.search,
                color: Colors.white,
              ),
              style:
                  ElevatedButton.styleFrom(backgroundColor: Colors.blueAccent),
              label: const Text(
                'ค้นหา',
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () {
                if (selectedButtons.isEmpty) {
                  // ถ้าไม่มีการเลือกปุ่มใดเลย
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text("แจ้งเตือน"),
                        content: Text("กรุณาเลือกปุ่มก่อนค้นหา"),
                        actions: <Widget>[
                          TextButton(
                            child: Text("ตกลง"),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      );
                    },
                  );
                } else if (selectedButtons.length == 1 &&
                    selectedButtons.contains("ทั้งหมด")) {
                  // ถ้ามีเพียง "ทั้งหมด" เท่านั้นที่ถูกเลือก

                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            btnnt(filter: [widget.selectedItem])),
                    (route) => false,
                  );
                } else {
                  // ถ้ามีการเลือกคำอื่น ๆ นอกเหนือจาก "ทั้งหมด"

                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                        builder: (context) => btnnt(filter: selectedButtons)),
                    (route) => false,
                  );
                }
              },
            ),
          ],
        ),
      ],
    );
  }
}

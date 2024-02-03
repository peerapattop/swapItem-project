class Message {
  late String senderId;
  late String receiverId;
  late String message;
  late String timestamp; // เปลี่ยน dynamic เป็น String

  Message({
    required this.senderId,
    required this.message,
    required this.timestamp,
    required this.receiverId,
  });

  Map<String, dynamic> toMap() {
    return {
      'senderId': senderId,
      'receiverId': receiverId,
      'message': message,
      'timestamp': timestamp,
    };
  }
}

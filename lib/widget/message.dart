class Message {
  late String senderId;
  late String receiverId;
  late String message;
  late dynamic timestamp; // Use dynamic type

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
      'timestamp': timestamp is DateTime
          ? (timestamp as DateTime).millisecondsSinceEpoch
          : timestamp,
    };
  }
}

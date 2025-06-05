class Message {
  final String text;
  final String time;
  final bool isUser;

  Message({required this.text, required this.time, required this.isUser});

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(text: json['message'], time: json['sent_at'].toString(), isUser: false);
  }
}

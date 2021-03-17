enum MessageType { text, file }

class Message {
  final MessageType type;
  final String content;

  Message(this.type, this.content);
}

class MassageModel {
  String? senderId;
  String? receiverId;
  String? dateTime;
  String? text;


  MassageModel({
    this.senderId,
    this.receiverId,
    this.dateTime,
    this.text,

  });
  MassageModel.formJson(Map<String, dynamic> json)
      : senderId = json['senderId'],
        receiverId = json['receiverId'],
        dateTime = json['dateTime'],
        text = json['text'];


  Map<String, dynamic> toMap() {
    return {
      'senderId': senderId,
      'receiverId': receiverId,
      'dateTime': dateTime,
      'text': text,

    };
  }
}

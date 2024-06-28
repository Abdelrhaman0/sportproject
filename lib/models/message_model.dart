import 'dart:convert';

class MassageModel {
  String? senderId;
  String? receiverId;
  String? dateTime;
  String? text;
  String? imageUrl;
  String? videoUrl;

  MassageModel({
    this.senderId,
    this.receiverId,
    this.dateTime,
    this.text,
    this.imageUrl,
    this.videoUrl,
  });
  MassageModel.formJson(Map<String, dynamic> json)
      : senderId = json['senderId'],
        receiverId = json['receiverId'],
        dateTime = json['dateTime'],
        text = json['text'],
        videoUrl = json["videoUrl"],
        imageUrl = json["imageUrl"];

  Map<String, dynamic> toMap() {
    return {
      'senderId': senderId,
      'receiverId': receiverId,
      'dateTime': dateTime,
      'text': text,
      'videoUrl': videoUrl,
      'imageUrl': imageUrl,
    };
  }
}
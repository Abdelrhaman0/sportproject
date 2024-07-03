import 'dart:typed_data';

class MassageModel {
  String? text;
  String? senderId;
  String? receiverId;
  String? dateTime;
  String? imageUrl;
  String? videoUrl;
  Uint8List? imageBytes;
  Uint8List? videoBytes;

  MassageModel({
    this.text,
    this.senderId,
    this.receiverId,
    this.dateTime,
    this.imageUrl,
    this.videoUrl,
    this.imageBytes,
    this.videoBytes,
  });

  MassageModel.fromJson(Map<String, dynamic> json) {
    text = json['text'];
    senderId = json['senderId'];
    receiverId = json['receiverId'];
    dateTime = json['dateTime'];
    imageUrl = json['imageUrl'];
    videoUrl = json['videoUrl'];
  }

  Map<String, dynamic> toMap() {
    return {
      'text': text,
      'senderId': senderId,
      'receiverId': receiverId,
      'dateTime': dateTime,
      'imageUrl': imageUrl,
      'videoUrl': videoUrl,
    };
  }
}

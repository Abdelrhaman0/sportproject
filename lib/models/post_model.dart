class PostModel {
  String? name;
  String? uid;
  String? image;
  String? text;
  String? postId;
  String? postImage;
  String? dateTime;

  PostModel(
      {this.name,
      this.uid,
      this.image,
      this.text,
      this.postId,
      this.postImage,
      this.dateTime});

  PostModel.formJson(Map<String, dynamic> json)
      : name = json['name'],
        uid = json['uid'],
        image = json['image'],
        text = json['text'],
        postId = json['postId'],
        postImage = json['postImage'],
        dateTime = json['dateTime'];

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'uid': uid,
      'image': image,
      'text': text,
      'postId': postId,
      'postImage': postImage,
      'dateTime': dateTime,
    };
  }
}

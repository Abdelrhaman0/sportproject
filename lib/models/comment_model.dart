class CommentModel {
  String? name;
  String? comment;
  String? postId;
  String? uid;
  String? profilePhoto;
  String? datePublished;

  CommentModel({
    this.name,
    this.comment,
    this.postId,
    this.uid,
    this.profilePhoto,
    this.datePublished,
  });

  Map<String, dynamic> toMap() => {
        'name': name,
        'comment': comment,
        'commentId': postId,
        'uid': uid,
        'profilePhoto': profilePhoto,
        'datePublished': datePublished,
      };

  CommentModel.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        comment = json['comment'],
        postId = json['postId'],
        uid = json['uid'],
        profilePhoto = json['profilePhoto'],
        datePublished = json['datePublished'];
}

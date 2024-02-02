class UserModel {
  String? name;
  String? email;
  String? phone;
  String? uid;
  String? image;
  String? cover;
  String? bio;
  bool? isEmailVerified;

  UserModel({
    this.name,
    this.email,
    this.phone,
    this.uid,
    this.image,
    this.cover,
    this.bio,
    this.isEmailVerified,
  });
  UserModel.formJson(Map<String, dynamic> json)
      : name = json['name'],
        email = json['email'],
        phone = json['phone'],
        uid = json['uid'],
        image = json['image'],
        cover = json['cover'],
        bio = json['bio'],
        isEmailVerified = json['isEmailVerified'];

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'phone': phone,
      'uid': uid,
      'image': image,
      'cover': cover,
      'bio' : bio,
      'isEmailVerified': isEmailVerified,
    };
  }
}

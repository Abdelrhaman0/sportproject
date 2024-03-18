import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sports_project/component/conest.dart';
import 'package:sports_project/layout/cubit/states.dart';
import 'package:sports_project/models/comment_model.dart';
import 'package:sports_project/models/message_model.dart';
import 'package:sports_project/models/post_model.dart';
import 'package:sports_project/models/user_model.dart';
import 'package:sports_project/pages/add_post/add_post_screen.dart';
import 'package:sports_project/pages/chats/chats_screen.dart';
import 'package:sports_project/pages/home/home_screen.dart';
import 'package:sports_project/pages/news/news_page.dart';
import 'package:sports_project/pages/profile/profile_screen.dart';



final storage = FirebaseStorage.instance;

class ProjectCubit extends Cubit<ProjectStates> {
  ProjectCubit() : super(ProjectInitialState());

  static ProjectCubit get(context) => BlocProvider.of(context);

  UserModel? userModel;

  void getUser() {
    emit(ProjectGetUserLoadingState());

    FirebaseFirestore.instance.collection('users').doc(uid).get().then((value) {
      userModel =
          UserModel.formJson(value.data() as Map<String, dynamic>);
      emit(ProjectGetUserSuccessState());
    }).catchError((error) {
      print(error);
      emit(ProjectGetUserErrorState(error.toString()));
    });
  }

  List<PostModel> postModel = [];


  int currentIndex = 0;
  List<Widget> screens = [
    HomeScreen(),
    NewsScreen(),
    AddPostScreen(),
    ChatsScreen(),
    ProfileScreen(),
  ];

  List<String> title = ['Home', 'News', 'Posts', 'Chats', 'Profile'];

  void changeBottomNav(int index) {

    if (index == 2) {
      emit(ProjectAddPostState());
    } else {
      currentIndex = index;
      emit(ProjectChangeBottomNavState());
    }
    if (index == 3) {
      getUsers();
    }
  }


  File? profileImage;
  var picker = ImagePicker();

  Future<void> getProfileImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      profileImage = File(pickedFile.path);
      emit(ProjectProfilePickedImageSuccessState());
    } else {
      print('no image selected');
      emit(ProjectProfilePickedImageErrorState());
    }
  }

  File? coverImage;

  Future<void> getCoverImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      coverImage = File(pickedFile.path);
      emit(ProjectCoverPickedImageSuccessState());
    } else {
      print('no image selected');
      emit(ProjectCoverPickedImageErrorState());
    }
  }

  void uploadProfileImage({
    required String name,
    required String bio,
    required String phone,
  }) {
    storage
        .ref()
        .child('users/${Uri.file(profileImage!.path).pathSegments.last}')
        .putFile(profileImage!)
        .then((value) {
      value.ref.getDownloadURL().then((value) {
        print(value);
        updateUser(name: name, bio: bio, phone: phone, image: value);
        emit(ProjectUploadProfileImageSuccessState());
      }).catchError((error) {
        emit(ProjectUploadProfileImageErrorState());
      });
    }).catchError((error) {
      emit(ProjectUploadProfileImageErrorState());
      print(error);
    });
  }

  void uploadCoverImage({
    required String name,
    required String bio,
    required String phone,
  }) {
    storage
        .ref()
        .child('users/${Uri.file(coverImage!.path).pathSegments.last}')
        .putFile(coverImage!)
        .then((value) {
      value.ref.getDownloadURL().then((value) {
        print(value);
        updateUser(name: name, bio: bio, phone: phone, cover: value);
        emit(ProjectUploadCoverImageSuccessState());
      }).catchError((error) {
        emit(ProjectUploadCoverImageErrorState());
      });
    }).catchError((error) {
      emit(ProjectUploadCoverImageErrorState());
      print(error);
    });
  }


  void updateUser(
      {required String name,
      required String bio,
      required String phone,
      String? image,
      String? cover}) {
    UserModel model = UserModel(
      name: name,
      phone: phone,
      bio: bio,
      email: userModel!.email,
      uid: userModel!.uid,
      image: image ?? userModel!.image,
      cover: cover ?? userModel!.cover,
      isEmailVerified: false,
    );
    FirebaseFirestore.instance
        .collection('users')
        .doc(userModel!.uid)
        .update(model.toMap())
        .then((value) {
      getUser();
    }).catchError((error) {});
  }


  List<CommentModel> commentModel = [];

  File? postImage;

  void removePostImage() {
    postImage = null;
    emit(ProjectRemovePostImageSuccessState());
  }

  Future<void> getPostImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      postImage = File(pickedFile.path);
      emit(ProjectPostPickedImageSuccessState());
    } else {
      print('no image selected');
      emit(ProjectPostPickedImageErrorState());
    }
  }

  void uploadPostImage({
    required String text,
    required String dateTime,
  }) {
    emit(ProjectCreatePostLoadingState());
    storage
        .ref()
        .child('users/${Uri.file(postImage!.path).pathSegments.last}')
        .putFile(postImage!)
        .then((value) {
      value.ref.getDownloadURL().then((value) {
        print(value);
        createPost(text: text, dateTime: dateTime, postImage: value);
      }).catchError((error) {
        emit(ProjectCreatePostErrorState());
      });
    }).catchError((error) {
      emit(ProjectCreatePostErrorState());
      print(error);
    });
  }

  void createPost({
    required String text,
    required String dateTime,
    String? postImage,

  }) {
    emit(ProjectCreatePostLoadingState());
    PostModel model = PostModel(
      name: userModel!.name,
      uid: userModel!.uid,
      image: userModel!.image,
      postId:'' ,
      text: text,
      dateTime: dateTime,
      postImage: postImage ?? '',
    );
    FirebaseFirestore.instance
        .collection('posts')
        .add(model.toMap())
        .then((value) {
          model.postId = value.id;
          print(' model id ${model.toMap()}');
      emit(ProjectCreatePostSuccessState());
    }).catchError((error) {
      emit(ProjectCreatePostErrorState());
    });
  }

  List<String> postId = [];
  List<int> likes = [];
  List<String> commentsId = [];
  List<int> commentsLikes = [];

  void getPost() {
    emit(ProjectGetPostLoadingState());

    FirebaseFirestore.instance.collection('posts').get().then((value) {
      for (var element in value.docs) {
        element.reference.collection('likes').get().then((value) {
          likes.add(value.docs.length);
          postModel.add(PostModel.formJson(element.data()));
          postId.add(element.id);
        }).catchError((error) {});
      }
      emit(ProjectGetPostSuccessState());
    }).catchError((error) {
      print(error);
      emit(ProjectGetPostErrorState(error.toString()));
    });
  }

  void getComment(String postId) {
    emit(ProjectGetCommentLoadingState());
    FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .collection('comments')
        .get()
        .then((value) {
      for (var element in value.docs) {
        element.reference.collection('commentsLikes').get().then((value) {
          commentsLikes.add(value.docs.length);
          commentModel.add(CommentModel.fromJson(element.data()));
          commentsId.add(element.id);
        }).catchError((error) {});
      }
      emit(ProjectGetCommentSuccessState());
    }).catchError((error) {
      emit(ProjectGetCommentErrorState(error));
    });
  }

  void createComment({
    required String text,
    required String dateTime,
    required String postId,
  }) {
    emit(ProjectCreateCommentLoadingState());
    CommentModel model = CommentModel(
      name: userModel!.name,
      uid: userModel!.uid,
      profilePhoto: userModel!.image,
      comment: text,
      datePublished: dateTime,
      postId: postId
    );
    FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .collection('comments')
        .add(model.toMap())
        .then((value) {
      emit(ProjectCreateCommentSuccessState());
    }).catchError((error) {
      emit(ProjectCreateCommentErrorState());
    });
  }

  void getCommentsLikes(String commentId, String postId) {
    FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .collection('comments')
        .doc(commentId)
        .collection('commentsLikes')
        .doc(userModel!.uid)
        .set({'commentsLike': true}).then((value) {
      emit(ProjectGetLikesSuccessState());
    }).catchError((error) {
      emit(ProjectGetLikesErrorState(error));
    });
  }

  void getLikes(String postId) {
    FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .collection('likes')
        .doc(userModel!.uid)
        .set({'like': true}).then((value) {
      emit(ProjectGetLikesSuccessState());
    }).catchError((error) {
      emit(ProjectGetLikesErrorState(error));
    });
  }

  List<UserModel> users = [];

  void getUsers() {
    if (users.isEmpty) {
      emit(ProjectGetAllUserLoadingState());
      FirebaseFirestore.instance.collection('users').get().then((value) {
        for (var element in value.docs) {
          if (element.data()['uid'] != userModel!.uid) {
            users.add(UserModel.formJson(element.data()));
          }
        }
        emit(ProjectGetAllUserSuccessState());
      }).catchError((error) {
        emit(ProjectGetAllUserErrorState(error.toString()));
      });
    }
  }

  void sendMassage(
      {required String? text,
      required String? receiverId,
      required String? dateTime}) {
    MassageModel model = MassageModel(
      text: text,
      senderId: userModel!.uid,
      receiverId: receiverId,
      dateTime: dateTime,
    );

    // set my chats

    FirebaseFirestore.instance
        .collection('users')
        .doc(userModel!.uid)
        .collection('chats')
        .doc(receiverId)
        .collection('massages')
        .add(model.toMap())
        .then((value) {
      emit(ProjectSendMassageSuccessState());
    }).catchError((error) {
      emit(ProjectSendMassageErrorState());
    });

    // set receiver Chats

    FirebaseFirestore.instance
        .collection('users')
        .doc(receiverId)
        .collection('chats')
        .doc(userModel!.uid)
        .collection('massages')
        .add(model.toMap())
        .then((value) {
      emit(ProjectSendMassageSuccessState());
    }).catchError((error) {
      emit(ProjectSendMassageErrorState());
    });
  }

  List<MassageModel> massages = [];

  void getMassage({required String? receiverId}) {
    FirebaseFirestore.instance
        .collection('users')
        .doc(userModel!.uid)
        .collection('chats')
        .doc(receiverId)
        .collection('massages')
        .orderBy('dateTime')
        .snapshots()
        .listen((event) {
      massages = [];
      for (var element in event.docs) {
        massages.add(MassageModel.formJson(element.data()));
      }
      emit(ProjectGetMassageSuccessState());
    });
  }

}

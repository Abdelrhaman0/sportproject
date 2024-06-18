import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sports_project/component/conest.dart';
import 'package:sports_project/component/shared/cache_helper.dart';
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
import 'package:video_player/video_player.dart';

final storage = FirebaseStorage.instance;

class ProjectCubit extends Cubit<ProjectStates> {
  ProjectCubit() : super(ProjectInitialState());

  static ProjectCubit get(context) => BlocProvider.of(context);

  UserModel? userModel;

  void getUser() {
    emit(ProjectGetUserLoadingState());

    FirebaseFirestore.instance.collection('users').doc(uid).get().then((value) {
      userModel = UserModel.formJson(value.data() as Map<String, dynamic>);
      emit(ProjectGetUserSuccessState());
    }).catchError((error) {
      print(error);
      emit(ProjectGetUserErrorState(error.toString()));
    });
  }

  List<PostModel> postModel = [];
  List<PostModel> userPostModel = [];

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
    if (index == 0 && postModel == null) {
      getPost();
    }
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
  File? postVideo;

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
    String? postVideo,
  }) {
    emit(ProjectCreatePostLoadingState());

    PostModel model = PostModel(
      name: userModel!.name,
      uid: userModel!.uid,
      image: userModel!.image,
      postId: '',
      text: text,
      dateTime: dateTime,
      postImage: postImage ?? '',
      postVideo: postVideo ?? '',
    );

    FirebaseFirestore.instance
        .collection('posts')
        .add(model.toMap())
        .then((value) {
      model.postId = value.id;
      print('Created post with ID: ${model.postId}');
      emit(ProjectCreatePostSuccessState());
    }).catchError((error) {
      print('Failed to create post: $error');
      emit(ProjectCreatePostErrorState());
    });
  }


  VideoPlayerController? postVideoController;


  Future<void> getPostVideo() async {
    final pickedFile = await ImagePicker().pickVideo(source: ImageSource.gallery);
    if (pickedFile != null) {
      postVideo = File(pickedFile.path);
      postVideoController = VideoPlayerController.file(postVideo!)
        ..initialize().then((_) {
          emit(ProjectPostVideoPickedSuccessState());
        });
    } else {
      emit(ProjectPostVideoPickedErrorState());
    }
  }

  Future<void> removePostVideo() async {
    postVideo = null;
    emit(ProjectPostVideoRemovedState());
  }

  Future<void> uploadPostVideo({required String text, required String dateTime}) async {
    emit(ProjectCreatePostLoadingState());
    final videoUploadResult = await FirebaseStorage.instance
        .ref()
        .child('posts/${Uri.file(postVideo!.path).pathSegments.last}')
        .putFile(postVideo!);

    final videoUrl = await videoUploadResult.ref.getDownloadURL();
    createPost(text: text, dateTime: dateTime, postVideo: videoUrl);
  }

  Map<String, VideoPlayerController?> postVideoControllers = {};

  VideoPlayerController? controller;

  void initializeVideoController(String postId, String videoUrl) {
    if (postVideoControllers[postId] == null) {
      print('Initializing video controller for postId: $postId with videoUrl: $videoUrl');
       controller = VideoPlayerController.network(videoUrl)
        ..initialize().then((_) {
          postVideoControllers[postId] = controller;
          emit(ProjectVideoInitializedState(postId));
          print('Video controller initialized for postId: $postId');
        }).catchError((error) {
          print('Error initializing video controller for postId: $postId, error: $error');
        });
    } else {
      print('Video controller already exists for postId: $postId');
    }
  }



  void playPauseVideo(String postId) {
    final controller = postVideoControllers[postId];
    if (controller != null) {
      if (controller.value.isPlaying) {
        controller.pause();
      } else {
        controller.play();
      }
      emit(ProjectVideoPlayPauseState());
    } else {
      print('No video controller found for postId: $postId');
    }
  }

  void disposeVideoController(String postId) {
    postVideoControllers[postId]?.dispose();
    postVideoControllers.remove(postId);
    print('Disposed video controller for postId: $postId');
  }

  @override
  Future<void> close() {
    postVideoControllers.forEach((key, controller) {
      controller?.dispose();
    });
    postVideoControllers.clear();
    return super.close();
  }

  List<String> postId = [];
  List<int> likes = [];
  List<String> commentsId = [];
  List<int> commentsLikes = [];
  List<int> userLikes = [];
  List<String> userPostId = [];


  void getPost() {
    emit(ProjectGetPostLoadingState());

    FirebaseFirestore.instance.collection('posts').get().then((value) {
      for (var element in value.docs) {
        element.reference.collection('likes').get().then((value) {
          likes.add(value.docs.length);
          postModel.add(PostModel.formJson(element.data()));
          postId.add(element.id);
        });
      }
      emit(ProjectGetPostSuccessState());
    }).catchError((error) {
      print(error);
      emit(ProjectGetPostErrorState(error.toString()));
    });
  }

  void getUserPost(String userId) {

    FirebaseFirestore.instance.collection('posts').where('uid', isEqualTo: userId).get().then((value) {
      for (var element in value.docs) {
        element.reference.collection('likes').get().then((value) {
          userLikes.add(value.docs.length);
          userPostModel.add(PostModel.formJson(element.data()));
          userPostId.add(element.id);
        });
      }
    }).catchError((error) {
      print(error);
    });
  }


  void getComment(String postId) async {
    emit(ProjectGetCommentLoadingState());

    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('posts')
          .doc(postId)
          .collection('comments')
          .orderBy('datePublished', descending: true)
          .get();

      commentModel = querySnapshot.docs.map((doc) {
        return CommentModel(
          comment: doc['comment'],
          profilePhoto: doc['profilePhoto'],
          name: doc['name'],
          datePublished: doc['datePublished'],
        );
      }).toList();

      emit(ProjectCommentsLoaded(commentModel));
    } catch (error) {
      print(error.toString());
      emit(ProjectGetCommentErrorState(error.toString()));
    }
  }



  void createComment({
    required String text,
    required String dateTime,
    required String postId,
  }) {
    if (postId.isEmpty) {
      print('post id is empty');
    } else
      print(postId);

    emit(ProjectCreateCommentLoadingState());
    CommentModel model = CommentModel(
        name: userModel!.name,
        uid: userModel!.uid,
        profilePhoto: userModel!.image,
        comment: text,
        datePublished: dateTime,
        postId: postId);
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
          var userData = element.data();
          if (userData != null && userData['uid'] != userModel!.uid) {
            users.add(UserModel.formJson(userData));
          }
        }
        emit(ProjectGetAllUserSuccessState());
      }).catchError((error) {
        emit(ProjectGetAllUserErrorState(error.toString()));
        print(error);
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

  void singOut() async {
    emit(ProjectSignOutLoadingState());
    await FirebaseAuth.instance.signOut();
    uid = CacheHelper.removeData(key: 'uid')
            .then((value) => {emit(ProjectSignOutSuccessState())})
            .catchError(
                (error) => {emit(ProjectSignOutErrorState()), print(error)})
        as String?;
  }

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> followUser(String uid, String followId) async {
    try {
      DocumentSnapshot snap =
          await _firestore.collection('users').doc(uid).get();
      List following = (snap.data()! as dynamic)['following'];

      if (following.contains(followId)) {
        await _firestore.collection('users').doc(followId).update({
          'followers': FieldValue.arrayRemove([uid])
        });

        await _firestore.collection('users').doc(uid).update({
          'following': FieldValue.arrayRemove([followId])
        });
      } else {
        await _firestore.collection('users').doc(followId).update({
          'followers': FieldValue.arrayUnion([uid])
        });

        await _firestore.collection('users').doc(uid).update({
          'following': FieldValue.arrayUnion([followId])
        });
      }
    } catch (e) {
      if (kDebugMode) print(e.toString());
    }
  }
}

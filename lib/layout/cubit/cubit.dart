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
import 'package:sports_project/ML_model/model.dart';
import 'package:sports_project/component/conest.dart';
import 'package:sports_project/component/shared/cache_helper.dart';
import 'package:sports_project/layout/cubit/states.dart';
import 'package:sports_project/models/comment_model.dart';
import 'package:sports_project/models/message_model.dart';
import 'package:sports_project/models/post_model.dart';
import 'package:sports_project/models/user_model.dart';
import 'package:sports_project/pages/add_post/add_post_screen.dart';
import 'package:sports_project/pages/chats/chats_screen.dart';
import 'package:sports_project/pages/chats/encryption_class.dart';
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
      userModel = UserModel.fromJson(value.data() as Map<String, dynamic>);
      emit(ProjectGetUserSuccessState());
    }).catchError((error) {
      print(error);
      emit(ProjectGetUserErrorState(error.toString()));
    });
  }

  UserModel? specificUserModel;

  Future<void> getSpecificUser(String userId)  async{
    try {
      var userDoc = await FirebaseFirestore.instance.collection('users').doc(userId).get();
      specificUserModel = UserModel.fromJson(userDoc.data() as Map<String, dynamic>);
    } catch (error) {
      print(error);
    }
  }

  List<PostModel> postModel = [];
  List<PostModel> userPostModel = [];

  int currentIndex = 0;

  List<Widget> screens = [
    HomeScreen(),
    NewsScreen(),
    HealthMetricsScreen(),
    ChatsScreen(),
    ProfileScreen(),
  ];

  List<String> title = ['Home', 'News', 'Your Fit', 'Chats', 'Profile'];

  void changeBottomNav(int index) {
    if (index == 0 && postModel == null) {
      getPost();
    }
    if (index == 2) {
      emit(ProjectYourFitState());
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
  Map<String, VideoPlayerController?> postVideoControllers = {};

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
    final pickedFile =
        await ImagePicker().pickVideo(source: ImageSource.gallery);
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

  Future<void> uploadPostVideo(
      {required String text, required String dateTime}) async {
    emit(ProjectCreatePostLoadingState());
    final videoUploadResult = await FirebaseStorage.instance
        .ref()
        .child('posts/${Uri.file(postVideo!.path).pathSegments.last}')
        .putFile(postVideo!);

    final videoUrl = await videoUploadResult.ref.getDownloadURL();
    createPost(text: text, dateTime: dateTime, postVideo: videoUrl);
  }

  Future<void> initializeVideoController(String postId, String videoUrl) async {
    if (!postVideoControllers.containsKey(postId)) {
      var controller = VideoPlayerController.network(videoUrl);
      await controller.initialize().then((_) {
        postVideoControllers[postId] = controller;
        emit(ProjectVideoInitializedState(postId));
      }).catchError((error) {
        print(
            'Error initializing video controller for postId: $postId, error: $error');
      });
    }
  }

  Future<void> initializePostVideoController(String videoUrl) async {
    final controller = postVideoControllers[videoUrl];
    if (controller != null && !controller.value.isInitialized) {
      await controller.initialize();
    }
  }

  void playPauseVideo(String postId) {
    var controller = postVideoControllers[postId];
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
    emit(ProjectVideoDisposedState(postId));
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
    FirebaseFirestore.instance
        .collection('posts')
        .where('uid', isEqualTo: userId)
        .get()
        .then((value) {
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

  void getUsersPost(String userId) {
    FirebaseFirestore.instance
        .collection('posts')
        .where('uid', isEqualTo: userId)
        .get()
        .then((value) {
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

  Set<String> likedPosts = {};


  List<UserModel> users = [];




  void likePost(String postId, int index) {
    FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .collection('likes')
        .doc(userModel!.uid)
        .set({'like': true}).then((value) {
      // Increase the likes count in the local list and mark the post as liked
      likes[index] += 1;
      likedPosts.add(postId);
      emit(ProjectGetLikesSuccessState());
    }).catchError((error) {
      emit(ProjectGetLikesErrorState(error));
    });
  }

  void unlikePost(String postId, int index) {
    FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .collection('likes')
        .doc(userModel!.uid)
        .delete().then((value) {
      // Decrease the likes count in the local list and mark the post as unliked
      likes[index] -= 1;
      likedPosts.remove(postId);
      emit(ProjectUnlikePostSuccessState());
    }).catchError((error) {
      emit(ProjectUnlikePostErrorState());
    });
  }

  void getUsers()  {
    if (users.isEmpty) {
      emit(ProjectGetAllUserLoadingState());
      FirebaseFirestore.instance.collection('users').get().then((value) {
        for (var element in value.docs) {
          var userData = element.data();
          if (userData != null && userData['uid'] != userModel!.uid) {
            users.add(UserModel.fromJson(userData));
          }
        }
        emit(ProjectGetAllUserSuccessState());
      }).catchError((error) {
        emit(ProjectGetAllUserErrorState(error.toString()));
        print(error);
      });
    }

  }

  List<MassageModel> massages = [];

  void sendMassage({
    required String? text,
    required String? receiverId,
    required String? dateTime,
    Uint8List? imageBytes,
    Uint8List? videoBytes,
  }) {
    final encryptedText = EncryptionHelper().encryptText(text ?? '');
    String? encryptedImage;
    String? encryptedVideo;

    if (imageBytes != null) {
      encryptedImage = EncryptionHelper().encryptBytes(imageBytes);
    }

    if (videoBytes != null) {
      encryptedVideo = EncryptionHelper().encryptBytes(videoBytes);
    }

    MassageModel model = MassageModel(
      text: encryptedText,
      senderId: userModel!.uid,
      receiverId: receiverId,
      dateTime: dateTime,
      imageUrl: encryptedImage,
      videoUrl: encryptedVideo,
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
        var encryptedMessage = MassageModel.fromJson(element.data());
        encryptedMessage.text = EncryptionHelper().decryptText(encryptedMessage.text ?? '');
        if (encryptedMessage.imageUrl != null && encryptedMessage.imageUrl!.isNotEmpty) {
          encryptedMessage.imageBytes = EncryptionHelper().decryptBytes(encryptedMessage.imageUrl!);
        }
        if (encryptedMessage.videoUrl != null && encryptedMessage.videoUrl!.isNotEmpty) {
          encryptedMessage.videoBytes = EncryptionHelper().decryptBytes(encryptedMessage.videoUrl!);
        }
        massages.add(encryptedMessage);
      }
      emit(ProjectGetMassageSuccessState());
    });
  }








  void signOut() async {
    emit(ProjectSignOutLoadingState());
    try {
      await FirebaseAuth.instance.signOut();
      bool isRemoved = await CacheHelper.removeData(key: 'uid');
      if (isRemoved) {
        emit(ProjectSignOutSuccessState());
      } else {
        emit(ProjectSignOutErrorState());
      }
    } catch (error) {
      emit(ProjectSignOutErrorState());
      print(error);
    }
  }


  List<String> followingUsers = [];

  User? getCurrentUser() {
    return FirebaseAuth.instance.currentUser;
  }

  List<UserModel> currentUserFollowers = [];
  List<UserModel> currentUserFollowing = [];
  List<UserModel> otherUserFollowers = [];
  List<UserModel> otherUserFollowing = [];

  void followUser(String userToFollowId) async {
    try {
      final currentUser = getCurrentUser();
      if (currentUser != null) {
        final currentUserDoc = FirebaseFirestore.instance.collection('users').doc(currentUser.uid);
        final userToFollowDoc = FirebaseFirestore.instance.collection('users').doc(userToFollowId);

        // Update current user's following list
        await currentUserDoc.collection('following').doc(userToFollowId).set({});

        // Update target user's followers list
        await userToFollowDoc.collection('followers').doc(currentUser.uid).set({});

        currentUserFollowing.add(UserModel(uid: userToFollowId)); // Assuming UserModel has a constructor accepting only uid
        emit(FollowSuccessState());
        await getFollowerUsers(userToFollowId, forCurrentUser: false);
        await getFollowingUsers(currentUser.uid, forCurrentUser: true);
      } else {
        emit(FollowErrorState());
      }
    } catch (e) {
      print("Error following user: $e");
      emit(FollowErrorState());
    }
  }

  void unfollowUser(String userToUnfollowId) async {
    try {
      final currentUser = getCurrentUser();
      if (currentUser != null) {
        final currentUserDoc = FirebaseFirestore.instance.collection('users').doc(currentUser.uid);
        final userToUnfollowDoc = FirebaseFirestore.instance.collection('users').doc(userToUnfollowId);

        // Remove from current user's following list
        await currentUserDoc.collection('following').doc(userToUnfollowId).delete();

        // Remove from target user's followers list
        await userToUnfollowDoc.collection('followers').doc(currentUser.uid).delete();

        currentUserFollowing.removeWhere((user) => user.uid == userToUnfollowId);
        emit(UnfollowSuccessState());
        await getFollowerUsers(userToUnfollowId, forCurrentUser: false);
        await getFollowingUsers(currentUser.uid, forCurrentUser: true);
      } else {
        emit(UnfollowErrorState());
      }
    } catch (e) {
      print("Error unfollowing user: $e");
      emit(UnfollowErrorState());
    }
  }

  Future<void> getFollowerUsers(String userId, {bool forCurrentUser = false}) async {
    try {
      QuerySnapshot followersSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('followers')
          .get();

      List<UserModel> followersList = followersSnapshot.docs
          .map((doc) => UserModel.fromJson(doc.data() as Map<String, dynamic>))
          .toList();

      if (forCurrentUser) {
        currentUserFollowers = followersList;
      } else {
        otherUserFollowers = followersList;
      }

      emit(GetFollowersUsersSuccessState());
    } catch (e) {
      print(e);
      emit(GetFollowersUsersErrorState());
    }
  }

  Future<void> getFollowingUsers(String userId, {bool forCurrentUser = false}) async {
    try {
      QuerySnapshot followingSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('following')
          .get();

      List<UserModel> followingList = followingSnapshot.docs
          .map((doc) => UserModel.fromJson(doc.data() as Map<String, dynamic>))
          .toList();

      if (forCurrentUser) {
        currentUserFollowing = followingList;
      } else {
        otherUserFollowing = followingList;
      }

      emit(GetFollowingUsersSuccessState());
    } catch (e) {
      print(e);
      emit(GetFollowingUsersErrorState());
    }
  }

  Future<bool> isFollowing(String userId) async {
    final currentUser = getCurrentUser();
    if (currentUser != null) {
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser.uid)
          .collection('following')
          .doc(userId)
          .get();
      return doc.exists;
    }
    return false;
  }
  Future<bool> isFollowing1(String userToCheckUid) async {
    try {
      final currentUserUid = getCurrentUser()?.uid;
      if (currentUserUid != null) {
        final doc = await FirebaseFirestore.instance.collection('users').doc(currentUserUid)
            .collection('following').doc(userToCheckUid).get();
        return doc.exists;
      }
      return false;
    } catch (e) {
      print("Error checking if following: $e");
      return false;
    }
  }

  void updateFollowingStatus(String userId) async {
    bool isFollowing = await isFollowing1(userId);
    if (isFollowing) {
      followingUsers.add(userId);
    } else {
      followingUsers.remove(userId);
    }
    emit(ProjectInitialState());
  }


  }


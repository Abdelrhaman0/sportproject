import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseMethods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Follow user
  void followUser(String currentUserUid, String userToFollowUid)  {
    try {
       _firestore.collection('users').doc(currentUserUid).collection('following').doc(userToFollowUid).set({
        'timestamp': FieldValue.serverTimestamp(),
      });

       _firestore.collection('users').doc(userToFollowUid).collection('followers').doc(currentUserUid).set({
        'timestamp': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print("Error following user: $e");
      throw e;
    }
  }

  // Unfollow user
  void unfollowUser(String currentUserUid, String userToUnfollowUid)  {
    try {
       _firestore.collection('users').doc(currentUserUid).collection('following').doc(userToUnfollowUid).delete();

       _firestore.collection('users').doc(userToUnfollowUid).collection('followers').doc(currentUserUid).delete();
    } catch (e) {
      print("Error unfollowing user: $e");
      throw e;
    }
  }

  // Check if following

}


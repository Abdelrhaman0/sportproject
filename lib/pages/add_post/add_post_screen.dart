import 'package:flutter/material.dart';

class AddPostScreen extends StatelessWidget {
  static String id = 'AddPostScreen';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back_ios_new),
        ),
        title: Text('Create Post'),
      ),

    );
  }
}

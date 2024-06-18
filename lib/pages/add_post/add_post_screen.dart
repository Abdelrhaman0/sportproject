import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:sports_project/component/other_component.dart';
import 'package:sports_project/layout/cubit/cubit.dart';
import 'package:sports_project/layout/cubit/states.dart';
import 'package:sports_project/layout/project_layout.dart';
import 'package:sports_project/pages/home/home_screen.dart';

import 'package:video_player/video_player.dart';

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sports_project/layout/cubit/cubit.dart';
import 'package:sports_project/layout/cubit/states.dart';
import 'package:video_player/video_player.dart';

class AddPostScreen extends StatelessWidget {
  static String id = 'AddPostScreen';

  final TextEditingController postController = TextEditingController();

  AddPostScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProjectCubit, ProjectStates>(
      listener: (context, state) {
        if(state is ProjectCreatePostSuccessState){
          ProjectCubit.get(context).postModel.clear();
          ProjectCubit.get(context).getPost();
        }
        if(state is ProjectGetPostSuccessState){
          navigateTo(context, ProjectLayout());
        }
      },
      builder: (context, state) {
        var now = DateTime.now();
        var formatter = DateFormat('MMM dd, yyyy hh:mm a');
        var formattedDate = formatter.format(now);
        var cubit = ProjectCubit.get(context);

        return Scaffold(
          appBar: AppBar(
            leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(Icons.arrow_back_ios_new),
            ),
            title: Text('Create Post'),
            actions: [
              TextButton(
                onPressed: () {
                  if (cubit.postImage == null && cubit.postVideo == null) {
                    cubit.createPost(
                        text: postController.text, dateTime: formattedDate.toString());
                  } else if (cubit.postImage != null) {
                    cubit.uploadPostImage(
                        text: postController.text, dateTime: formattedDate.toString());
                  } else if (cubit.postVideo != null) {
                    cubit.uploadPostVideo(
                        text: postController.text, dateTime: formattedDate.toString());
                  }
                  

                },
                child: Text('POST'),
              ),
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                if (state is ProjectCreatePostLoadingState)
                  LinearProgressIndicator(),
                SizedBox(height: 10),
                Row(
                  children: [
                    CircleAvatar(
                      radius: 25,
                      backgroundImage: NetworkImage('${cubit.userModel!.image}'),
                    ),
                    SizedBox(width: 15),
                    Expanded(
                      child: Row(
                        children: [
                          Text(
                            '${cubit.userModel!.name}',
                            style: TextStyle(height: 1.4),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Expanded(
                  child: TextFormField(
                    decoration: InputDecoration(
                      hintText: 'What is in your mind...',
                      border: InputBorder.none,
                    ),
                    controller: postController,
                  ),
                ),
                SizedBox(height: 20),
                if (cubit.postImage != null)
                  Stack(
                    alignment: Alignment.topRight,
                    children: [
                      Container(
                        width: double.infinity,
                        height: 150,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          image: DecorationImage(
                              image: FileImage(cubit.postImage as File),
                              fit: BoxFit.cover),
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          cubit.removePostImage();
                        },
                        icon: CircleAvatar(
                          radius: 20,
                          child: Icon(
                            Icons.close,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                if (cubit.postVideo != null)
                  Stack(
                    alignment: Alignment.topRight,
                    children: [
                      Container(
                        width: double.infinity,
                        height: 150,
                        child: FutureBuilder(
                          future: cubit.postVideoController!.initialize(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState == ConnectionState.done) {
                              return VideoPlayer(cubit.postVideoController!);
                            } else {
                              return Center(child: CircularProgressIndicator());
                            }
                          },
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          cubit.removePostVideo();
                        },
                        icon: CircleAvatar(
                          radius: 20,
                          child: Icon(
                            Icons.close,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed: () {
                          cubit.getPostImage();
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.image),
                            SizedBox(width: 5),
                            Text('add photo'),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: TextButton(
                        onPressed: () {
                          cubit.getPostVideo();
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.video_camera_back),
                            SizedBox(width: 5),
                            Text('add video'),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}



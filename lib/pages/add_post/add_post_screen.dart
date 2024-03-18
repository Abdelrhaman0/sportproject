import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sports_project/layout/cubit/cubit.dart';
import 'package:sports_project/layout/cubit/states.dart';

class AddPostScreen extends StatelessWidget {
  static String id = 'AddPostScreen';

  const AddPostScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProjectCubit, ProjectStates>(
      listener: (context, state) {},
      builder: (context, state) {

        var postController = TextEditingController();
        var now = DateTime.now();

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
                    if(ProjectCubit.get(context).postImage == null){
                      ProjectCubit.get(context).createPost(text: postController.text, dateTime:now.toString());
                    }else
                    {
                      ProjectCubit.get(context).uploadPostImage(text: postController.text, dateTime: now.toString());
                    }
                  },
                  child: Text('POST'))],
          ),
          body: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                if(state is ProjectCreatePostLoadingState)
                  LinearProgressIndicator(),
                SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    CircleAvatar(
                      radius: 25,
                      backgroundImage: NetworkImage(
                          '${ProjectCubit.get(context).userModel!.image}'),
                    ),
                    SizedBox(
                      width: 15,
                    ),
                    Expanded(
                        child: Row(
                          children: [
                            Text(
                              '${ProjectCubit.get(context).userModel!.name}',
                              style: TextStyle(
                                height: 1.4,
                              ),
                            ),
                          ],
                        )),
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
                SizedBox(height: 20,),
                if(ProjectCubit.get(context).postImage != null)
                  Stack(
                    alignment: Alignment.topRight,
                    children: [
                      Container(
                        width: double.infinity,
                        height: 150,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          image: DecorationImage(
                              image: FileImage(ProjectCubit.get(context).postImage as File) ,
                              fit: BoxFit.cover
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          ProjectCubit.get(context).removePostImage();
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
                SizedBox(height: 20,),
                Row(
                  children: [
                    Expanded(
                      child: TextButton(
                          onPressed: () {
                            ProjectCubit.get(context).getPostImage();
                          },

                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.image),
                              SizedBox(width: 5,),
                              Text('add photo')
                            ],
                          )),
                    ),
                    // Expanded(
                    //   child: TextButton(
                    //       onPressed: () {},
                    //       child: Text('# tags')),
                    // ),
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }
}

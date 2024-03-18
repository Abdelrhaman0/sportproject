import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sports_project/component/conest.dart';
import 'package:sports_project/layout/cubit/cubit.dart';
import 'package:sports_project/layout/cubit/states.dart';
import 'package:sports_project/models/comment_model.dart';

import 'package:sports_project/models/post_model.dart';

class CommentsScreen extends StatelessWidget {
  var postId;

  CommentsScreen({required this.postId});


  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProjectCubit,ProjectStates>(
      listener: (context,state){},
      builder: (context,state){
        var commentController = TextEditingController();
        var now = DateTime.now();
        return Scaffold(
          appBar: AppBar(
            leading: IconButton(onPressed: () {
              Navigator.pop(context);
            },
              icon: Icon(Icons.arrow_back_ios_new),),
            title: Text("Comments"),
          ),
          body: ConditionalBuilder(
            condition: true ,
            builder: (context) => Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                children: [
                  Expanded(
                    child: ListView.separated(
                      itemBuilder: (context,index) => Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: buildCommentItem(ProjectCubit.get(context).commentModel[index]),
                      ),
                      separatorBuilder: (context,index) => SizedBox(height: 10,),
                      itemCount: ProjectCubit.get(context).commentModel.length,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Row(
                      children: [
                        Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  border: Border.all(color: Color(0xFFE0E0E0))),
                              child: Padding(
                                padding:
                                const EdgeInsets.symmetric(horizontal: 10),
                                child: TextFormField(
                                  controller: commentController,
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: 'type your comment...',
                                  ),
                                ),
                              ),
                            )),
                        SizedBox(
                          width: 5,
                        ),
                        IconButton(
                          onPressed: () {
                            ProjectCubit.get(context).createComment(
                                text: commentController.text,
                                dateTime:now.toString() ,
                                postId: postId);
                            },
                          icon: Icon(Icons.send,
                              size: 30, color: kPrimaryColor),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            fallback:(context) => Center(child: Text('No Comments Yet',style: TextStyle(color: Colors.grey),)),
          )
        );
      },

    );

  }

  Widget buildCommentItem(CommentModel model) => Card(
    clipBehavior: Clip.antiAliasWithSaveLayer,
    elevation: 6,
    margin: EdgeInsets.symmetric(
      horizontal: 8.0,
    ),
    child: Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(children: [
        Row(
          children: [
            CircleAvatar(
              radius: 25,
              backgroundImage: NetworkImage(
                  '${model.profilePhoto}'),
            ),
            SizedBox(
              width: 15,
            ),
            Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${model.name}',
                      style: TextStyle(
                        height: 1.4,
                      ),
                    ),
                    Text(
                      '${model.comment}',
                    ),
                    // Text('${model.datePublished}',
                    //    ),
                  ],
                )),

          ],
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 15),
          child: Container(
            width: double.infinity,
            height: 1,
            color: Colors.grey[300],
          ),
        ),
        Row(
          children: [

          ],
        ),
   ]
  )
  ));
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:sports_project/layout/cubit/cubit.dart';
import 'package:sports_project/layout/cubit/states.dart';
import 'package:sports_project/models/comment_model.dart';

class CommentsScreen extends StatelessWidget {
  final String postId;

  CommentsScreen({required this.postId});



  @override
  Widget build(BuildContext context) {
    // Load comments
    ProjectCubit.get(context).getComment(postId);


    return Scaffold(
      appBar: AppBar(
        title: Text('Comments'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: BlocBuilder<ProjectCubit, ProjectStates>(
        builder: (context, state) {
          return Column(
            children: [
              Expanded(
                child: _buildCommentsList(context),
              ),
              _buildCommentInput(context),
            ],
          );
        },
      ),
    );
  }

  Widget _buildCommentsList(BuildContext context) {
    final commentModel = ProjectCubit.get(context).commentModel;

    return commentModel.isNotEmpty
        ? ListView.builder(
      itemCount: commentModel.length,
      itemBuilder: (context, index) {
        return _buildCommentItem(context, commentModel[index]);
      },
    )
        : Center(
      child: Text('No comments yet'),
    );
  }

  Widget _buildCommentItem(BuildContext context, CommentModel model) {
    return Container(
      padding: EdgeInsets.all(10),
      margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 1,
            blurRadius: 3,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundImage: NetworkImage(model.profilePhoto ?? ''),
              ),
              SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    model.name ?? '',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    model.datePublished ?? '',
                    style: TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 10),
          Text(
            model.comment ?? '',
            style: TextStyle(
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCommentInput(BuildContext context) {
    final TextEditingController commentController = TextEditingController();
    var now = DateTime.now();
    var formatter = DateFormat('MMM dd, yyyy hh:mm a');
    var formattedDate = formatter.format(now);

    return Padding(
      padding: EdgeInsets.all(10),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: commentController,
              decoration: InputDecoration(
                hintText: 'Write a comment...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
            ),
          ),
          SizedBox(width: 10),
          ElevatedButton(
            onPressed: () {
              final comment = commentController.text.trim();
              if (comment.isNotEmpty) {
                ProjectCubit.get(context).createComment(
                  text: comment,
                  postId: postId, dateTime:formattedDate,
                );
                commentController.clear();
              }
            },
            child: Text('Post'),
            style: ElevatedButton.styleFrom(
              primary: Theme.of(context).primaryColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

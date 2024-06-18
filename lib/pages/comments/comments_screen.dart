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
      body: BlocConsumer<ProjectCubit, ProjectStates>(
        listener: (context, state) {
          if (state is ProjectCreateCommentSuccessState) {
            // Fetch comments again
            ProjectCubit.get(context).getComment(postId);
          }
        },
        builder: (context, state) {
          if (state is ProjectGetCommentLoadingState) {
            return Center(child: CircularProgressIndicator());
          } else if (state is ProjectCommentsLoaded) {
            return _buildCommentListWithRefresh(context, state.comments, postId);
          } else if (state is ProjectGetCommentErrorState) {
            return Center(child: Text(state.error));
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }

  Widget _buildCommentListWithRefresh(BuildContext context, List<CommentModel> comments, String postId) {
    return RefreshIndicator(
      onRefresh: () async {
        // Fetch comments again
        ProjectCubit.get(context).getComment(postId);
      },
      child: ListView.builder(
        itemCount: comments.length,
        itemBuilder: (context, index) {
          return _buildCommentItem(context, comments[index], index);
        },
      ),
    );
  }

  Widget _buildCommentItem(BuildContext context, CommentModel model, int index) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 500),
      curve: Curves.easeInOut,
      padding: EdgeInsets.all(15),
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 20,
                backgroundImage: NetworkImage(model.profilePhoto ?? ''),
              ),
              SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      model.name ?? '',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      model.datePublished ?? '',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 12,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      model.comment ?? '',
                      style: TextStyle(
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: Icon(Icons.favorite_border_outlined),
                onPressed: () {
                  // Implement like functionality here
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sports_project/component/other_component.dart';
import 'package:sports_project/layout/cubit/cubit.dart';
import 'package:sports_project/layout/cubit/states.dart';
import 'package:sports_project/models/post_model.dart';
import 'package:sports_project/models/user_model.dart';
import 'package:sports_project/pages/comments/comments_screen.dart';
import 'package:sports_project/pages/home/image_full_screen.dart';
import 'package:sports_project/pages/home/video_full_screen.dart';
import 'package:sports_project/pages/user_profile_page/user_profile_screen.dart';
import 'package:video_player/video_player.dart';


class FollowingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var postModel = ProjectCubit.get(context).postModel;
    return BlocBuilder<ProjectCubit, ProjectStates>(
      builder: (context, state) {
        return ListView.separated(
          physics: BouncingScrollPhysics(),
          itemBuilder: (context, index) {
            final post = postModel[index];
            String postUid = postModel[index].uid as String;
            ProjectCubit.get(context).getSpecificUser(postUid);
            UserModel? postUser = ProjectCubit.get(context).specificUserModel;
            final postId = ProjectCubit.get(context).postId![index];
            String currentUserId = ProjectCubit.get(context).userModel!.uid as String;
            ProjectCubit.get(context).fetchFollowingStatus(currentUserId, postUid);

            if (ProjectCubit.get(context).followingStatus[postUid] == true) {
              return buildPostItem(context, post, index, postId, postUser!, currentUserId);
            } else {
              return SizedBox.shrink();
            }
          },
          separatorBuilder: (context, index) => SizedBox(height: 10),
          itemCount: postModel.length,
        );
      },
    );
  }

  Widget buildPostItem(BuildContext context, PostModel model, int index, String postId, UserModel user, String currentUserId) {
    if (model.postVideo != null && model.postVideo!.isNotEmpty) {
      ProjectCubit.get(context).initializeVideoController(postId, model.postVideo!);
    }
    int likes = ProjectCubit.get(context).likes[index];
    bool isLiked = ProjectCubit.get(context).likedPosts.contains(postId);

    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      clipBehavior: Clip.antiAliasWithSaveLayer,
      margin: EdgeInsets.symmetric(horizontal: 8.0, vertical: 5.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 6,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InkWell(
              onTap: () {
                navigateTo(context, UsersProfileScreen(model: user));
              },
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 25,
                    backgroundImage: NetworkImage('${model.image}'),
                  ),
                  SizedBox(width: 15),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${model.name}',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          '${model.dateTime}',
                          style: Theme.of(context).textTheme.caption,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10),
            Text(
              '${model.text}',
              style: Theme.of(context).textTheme.subtitle1,
            ),
            if (model.postImage != '')
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => FullScreenImage(imageUrl: model.postImage!),
                    ),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: Image.network(
                      '${model.postImage}',
                      width: double.infinity,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) {
                        return SizedBox.shrink();
                      },
                    ),
                  ),
                ),
              ),
            if (model.postVideo != null && model.postVideo!.isNotEmpty)
              BlocBuilder<ProjectCubit, ProjectStates>(
                builder: (context, state) {
                  var controller = ProjectCubit.get(context).postVideoControllers[postId];
                  if (controller == null || !controller.value.isInitialized) {
                    return Center(child: CircularProgressIndicator());
                  }
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => FullScreenVideo(videoController: controller),
                        ),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8.0),
                        child: AspectRatio(
                          aspectRatio: controller.value.aspectRatio,
                          child: Stack(
                            alignment: Alignment.bottomCenter,
                            children: [
                              VideoPlayer(controller),
                              VideoProgressIndicator(
                                controller,
                                allowScrubbing: true,
                              ),
                              IconButton(
                                onPressed: () {
                                  ProjectCubit.get(context).playPauseVideo(postId);
                                },
                                icon: Icon(
                                  controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Row(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        ProjectCubit.get(context).getComment(postId);
                        navigateTo(context, CommentsScreen(postId: postId));
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        child: Row(
                          children: [
                            Icon(
                              Icons.comment_outlined,
                              size: 18,
                              color: Colors.amber,
                            ),
                            SizedBox(width: 5),
                            Text(
                              'Comment',
                              style: TextStyle(color: Colors.grey),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        if (isLiked) {
                          ProjectCubit.get(context).unlikePost(postId, index);
                        } else {
                          ProjectCubit.get(context).likePost(postId, index);
                        }
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Icon(
                              isLiked ? Icons.favorite : Icons.favorite_border,
                              size: 18,
                              color: isLiked ? Theme.of(context).primaryColor : Colors.red,
                            ),
                            SizedBox(width: 5),
                            Text(
                              '$likes',
                              style: TextStyle(color: Colors.grey),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Divider(color: Colors.grey[300]),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sports_project/component/other_component.dart';
import 'package:sports_project/layout/cubit/cubit.dart';
import 'package:sports_project/layout/cubit/states.dart';
import 'package:sports_project/models/post_model.dart';
import 'package:sports_project/pages/add_post/add_post_screen.dart';
import 'package:sports_project/pages/comments/comments_screen.dart';
import 'package:sports_project/pages/setting/setting_screen.dart';
import 'package:video_player/video_player.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';

class ProfileScreen extends StatefulWidget {
  static String id = 'ProfileScreen';

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {

  @override
  Widget build(BuildContext context) {
    final userId = ProjectCubit.get(context).userModel!.uid;

    return BlocConsumer<ProjectCubit, ProjectStates>(
      listener: (context, state) {
        if(state is ProjectChangeBottomNavState){
          ProjectCubit.get(context).getFollowerUsers(userId!);
          ProjectCubit.get(context).getFollowingUsers(userId!);
        }
      },
      builder: (context, state) {
        final model = ProjectCubit.get(context).userModel;
        final userPosts = ProjectCubit.get(context).userPostModel;
        int followers = ProjectCubit.get(context).followersList.length;
        int following = ProjectCubit.get(context).followingList.length;
        int postNumber = userPosts.length;

        return ConditionalBuilder(
          condition: model?.image != null,
          builder: (context) => Padding(
            padding: const EdgeInsets.all(8.0),
            child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 12),
                        child: CircleAvatar(
                          radius: 54,
                          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                          child: CircleAvatar(
                            radius: 50,
                            backgroundImage: NetworkImage(
                              model!.image ??
                                  'https://icons8.com/icon/AZazdsitsrgg/user',
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: InkWell(
                          child: Column(
                            children: [
                              Text(
                                'Posts',
                                style: Theme.of(context).textTheme.subtitle1,
                              ),
                              Text(
                                '$postNumber',
                                style: Theme.of(context).textTheme.caption,
                              ),
                            ],
                          ),
                          onTap: () {
                            // Handle tap on Posts
                          },
                        ),
                      ),
                      Expanded(
                        child: InkWell(
                          child: Column(
                            children: [
                              Text(
                                'Followers',
                                style: Theme.of(context).textTheme.subtitle1,
                              ),
                              Text(
                                '$followers', // Display followers count
                                style: Theme.of(context).textTheme.caption,
                              ),
                            ],
                          ),
                          onTap: () {
                            // Handle tap on Followers
                          },
                        ),
                      ),
                      Expanded(
                        child: InkWell(
                          child: Column(
                            children: [
                              Text(
                                'Following',
                                style: Theme.of(context).textTheme.subtitle1,
                              ),
                              Text(
                                '$following', // Display following count
                                style: Theme.of(context).textTheme.caption,
                              ),
                            ],
                          ),
                          onTap: () {
                            // Handle tap on Following
                          },
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 20),
                    child: Row(
                      children: [
                        Text(
                          '${model!.name}',
                          style: Theme.of(context).textTheme.bodyText1,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 20),
                    child: Text(
                      '${model!.bio}',
                      style: Theme.of(context).textTheme.caption,
                    ),
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            Navigator.pushNamed(context, AddPostScreen.id);
                          },
                          child: Text('Add Post'),
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      OutlinedButton(
                        onPressed: () {
                          navigateTo(context, SettingScreen());
                        },
                        child: Icon(
                          Icons.edit,
                          size: 18,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  myDivider(),
                  buildPostList(context, '${model.uid}'),
                ],
              ),
            ),
          ),
          fallback: (context) => Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
    );
  }

  Widget buildPostList(BuildContext context, String userId) {
    final userPosts = ProjectCubit.get(context).userPostModel;
    return ListView.separated(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        final post = userPosts[index];
        final postId = ProjectCubit.get(context).postId![index];
        return buildPostItem(context, post, index, postId, userId);
      },
      separatorBuilder: (context, index) => SizedBox(height: 10),
      itemCount: userPosts.length,
    );
  }

  Widget buildPostItem(BuildContext context, PostModel model, int index, String postId, String userId) {
    if (model.uid == userId) {
      if (model.postVideo != null && model.postVideo!.isNotEmpty) {
        ProjectCubit.get(context).initializeVideoController(postId, model.postVideo!);
      }

      return AnimatedOpacity(
        opacity: 1.0,
        duration: Duration(milliseconds: 500),
        child: AnimatedContainer(
          duration: Duration(milliseconds: 500),
          curve: Curves.easeInOut,
          clipBehavior: Clip.antiAliasWithSaveLayer,
          margin: EdgeInsets.symmetric(horizontal: 8.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                Row(
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
                            style: TextStyle(height: 1.4),
                          ),
                          Text(
                            '${model.dateTime}',
                            style: Theme.of(context).textTheme.caption!.copyWith(height: 1.4),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 15),
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
                    Text(
                      '${model.text}',
                      style: Theme.of(context).textTheme.subtitle1,
                    ),
                  ],
                ),
                if (model.postImage != '')
                  Padding(
                    padding: const EdgeInsetsDirectional.only(top: 15),
                    child: Image.network(
                      '${model.postImage}',
                      width: double.infinity,
                      height: 140,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        print('Failed to load image: $error\n$stackTrace');
                        return SizedBox.shrink();
                      },
                    ),
                  ),
                if (model.postVideo != null && model.postVideo!.isNotEmpty)
                  BlocBuilder<ProjectCubit, ProjectStates>(
                    builder: (context, state) {
                      var controller = ProjectCubit.get(context).postVideoControllers[postId];
                      if (controller == null || !controller.value.isInitialized) {
                        return Center(child: CircularProgressIndicator());
                      }
                      return Padding(
                        padding: const EdgeInsetsDirectional.only(top: 15),
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
                                ),
                                color: Colors.white,
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  child: Row(
                    children: [
                      Expanded(
                        child: InkWell(
                          onTap: () {
                            ProjectCubit.get(context).getComment(postId);
                            navigateTo(context, CommentsScreen(postId: postId));
                            print(postId);
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
                                  '0',
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
                            ProjectCubit.get(context).getLikes(ProjectCubit.get(context).postId[index]);
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 5),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Icon(
                                  Icons.favorite_border,
                                  size: 18,
                                  color: Colors.red,
                                ),
                                SizedBox(width: 5),
                                Text(
                                  '${ProjectCubit.get(context).likes[index]}',
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
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Container(
                    width: double.infinity,
                    height: 1,
                    color: Colors.grey[300],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    } else
      return SizedBox.shrink();
  }
}

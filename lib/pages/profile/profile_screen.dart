import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sports_project/component/other_component.dart';
import 'package:sports_project/layout/cubit/cubit.dart';
import 'package:sports_project/layout/cubit/states.dart';
import 'package:sports_project/models/post_model.dart';
import 'package:sports_project/pages/add_post/add_post_screen.dart';
import 'package:sports_project/pages/comments/comments_screen.dart';
import 'package:sports_project/pages/home/image_full_screen.dart';
import 'package:sports_project/pages/home/video_full_screen.dart';
import 'package:sports_project/pages/setting/setting_screen.dart';
import 'package:video_player/video_player.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';

class ProfileScreen extends StatefulWidget {
  static String id = 'ProfileScreen';

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeInAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _fadeInAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeIn,
    );
    _controller.forward();

    final cubit = ProjectCubit.get(context);
    final userId = cubit.userModel!.uid;
    cubit.getFollowerUsers(userId as String, forCurrentUser: true);
    cubit.getFollowingUsers(userId as String, forCurrentUser: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userId = ProjectCubit.get(context).userModel!.uid;

    return BlocConsumer<ProjectCubit, ProjectStates>(
      listener: (context, state) {
        if (state is UnfollowSuccessState || state is FollowSuccessState) {
          ProjectCubit.get(context).getFollowerUsers(userId as String, forCurrentUser: true);
          ProjectCubit.get(context).getFollowingUsers(userId as String, forCurrentUser: true);
        }
      },
      builder: (context, state) {
        final model = ProjectCubit.get(context).userModel;
        final userPosts = ProjectCubit.get(context).userPostModel;
        int followers = ProjectCubit.get(context).currentUserFollowers.length;
        int following = ProjectCubit.get(context).currentUserFollowing.length;
        int postNumber = userPosts.length;

        return ConditionalBuilder(
          condition: model?.image != null,
          builder: (context) => FadeTransition(
            opacity: _fadeInAnimation,
            child: Padding(
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
                                model!.image ?? 'https://icons8.com/icon/AZazdsitsrgg/user',
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
                        ),
                      ],
                    ),
                    SizedBox(height: 5),
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
                    SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.only(left: 20),
                      child: Text(
                        '${model!.bio}',
                        style: Theme.of(context).textTheme.caption,
                      ),
                    ),
                    SizedBox(height: 50),
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
                        SizedBox(width: 10),
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
                    SizedBox(height: 10),
                    myDivider(),
                    SizedBox(height: 10,),
                    buildPostList(context, '${model.uid}'),

                  ],
                ),
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
      int likes = ProjectCubit.get(context).likes[index];

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
                          ProjectCubit.get(context).getLikes(postId);
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
    } else
      return SizedBox.shrink();
  }
}

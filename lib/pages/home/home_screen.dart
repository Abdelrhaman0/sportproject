import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sports_project/component/conest.dart';
import 'package:sports_project/component/other_component.dart';
import 'package:sports_project/layout/cubit/cubit.dart';
import 'package:sports_project/layout/cubit/states.dart';
import 'package:sports_project/models/post_model.dart';
import 'package:sports_project/pages/comments/comments_screen.dart';
import 'package:video_player/video_player.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProjectCubit, ProjectStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var postModel = ProjectCubit.get(context).postModel;
        return ConditionalBuilder(
          condition: postModel.isNotEmpty && ProjectCubit.get(context).userModel != null,
          builder: (context) => ListView.separated(
            physics: BouncingScrollPhysics(),
            itemBuilder: (context, index) {
              final post = ProjectCubit.get(context).postModel[index];
              final postId = ProjectCubit.get(context).postId![index];
              return buildPostItem(context, post, index, postId);
            },
            separatorBuilder: (context, index) => SizedBox(height: 10),
            itemCount: postModel.length,
          ),
          fallback: (context) => Center(child: CircularProgressIndicator()),
        );
      },
    );
  }

  Widget buildPostItem(BuildContext context, PostModel model, int index, String postId) {
    if (model.postVideo != null && model.postVideo!.isNotEmpty) {
      ProjectCubit.get(context).initializeVideoController(postId, model.postVideo!);
    }

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
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 15),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: Image.network(
                    '${model.postImage}',
                    width: double.infinity,
                    height: 200,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      print('Failed to load image: $error\n$stackTrace');
                      return SizedBox.shrink();
                    },
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
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: AspectRatio(
                        aspectRatio: controller.value.aspectRatio,
                        child: Stack(
                          alignment: Alignment.bottomCenter,
                          children: [
                            FadeTransition(
                              opacity: AlwaysStoppedAnimation(controller.value.isPlaying ? 1.0 : 0.7),
                              child: VideoPlayer(controller),
                            ),
                            VideoProgressIndicator(
                              controller,
                              allowScrubbing: true,
                            ),
                            IconButton(
                              onPressed: () {
                                ProjectCubit.get(context).playPauseVideo(postId);
                              },
                              icon: AnimatedSwitcher(
                                duration: Duration(milliseconds: 300),
                                child: Icon(
                                  controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
                                  key: ValueKey<bool>(controller.value.isPlaying),
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
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
            Divider(color: Colors.grey[300]),
          ],
        ),
      ),
    );
  }
}

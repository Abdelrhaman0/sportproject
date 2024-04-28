import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sports_project/component/conest.dart';
import 'package:sports_project/component/other_component.dart';
import 'package:sports_project/layout/cubit/cubit.dart';
import 'package:sports_project/layout/cubit/states.dart';
import 'package:sports_project/models/post_model.dart';
import 'package:sports_project/pages/comments/comments_screen.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProjectCubit, ProjectStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var post = ProjectCubit.get(context).postModel;
        return ConditionalBuilder(
          condition: ProjectCubit.get(context).postModel.isNotEmpty &&
              ProjectCubit.get(context).userModel != null,
          builder: (context) => SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Column(
              children: [
                buildPostList(context),
                SizedBox(height: 10),
              ],
            ),
          ),
          fallback: (context) => Center(child: CircularProgressIndicator()),
        );
      },
    );
  }

  Widget buildPostList(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) =>
          buildPostItem(context, ProjectCubit.get(context).postModel[index],index,ProjectCubit.get(context).postId![index]),
      separatorBuilder: (context, index) => SizedBox(height: 10),
      itemCount: ProjectCubit.get(context).postModel.length,
    );
  }

  Widget buildPostItem(BuildContext context, PostModel model, int index, String postId) {
    return Card(
      clipBehavior: Clip.antiAliasWithSaveLayer,
      elevation: 6,
      margin: EdgeInsets.symmetric(horizontal: 8.0),
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
    );
  }
}


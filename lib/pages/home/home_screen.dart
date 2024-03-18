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
    return BlocConsumer<ProjectCubit,ProjectStates>(
      listener: (context,state){},
      builder: (context,state){
        var post = ProjectCubit.get(context).postModel;
        return ConditionalBuilder(
          condition: ProjectCubit.get(context).postModel.length > 0 && ProjectCubit.get(context).userModel != null,
          builder: (context) => SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Column(
              children: [
                // Container (
                //   width: double.infinity,
                //   child: Card(
                //     clipBehavior: Clip.antiAliasWithSaveLayer,
                //     elevation: 5,
                //     margin: EdgeInsets.all(8.0),
                //     child: Stack(alignment: AlignmentDirectional.bottomEnd, children: [
                //       Image(
                //         image: NetworkImage(
                //             'https://img.freepik.com/free-photo/friends-having-fun-with-traditional-games_23-2149332630.jpg?t=st=1696504517~exp=1696505117~hmac=9843b537ba4946ef3e1f3dfb8d01c4f34da63abd69e54d073b618960e87bdca8'),
                //         fit: BoxFit.cover,
                //         width: double.infinity,
                //         height: 200,
                //       ),
                //       Padding(
                //         padding: const EdgeInsets.all(8.0),
                //         child: Text(
                //           'Communicate with your friends',
                //           style: Theme.of(context)
                //               .textTheme
                //               .subtitle1!
                //               .copyWith(color: Colors.white),
                //           //
                //         ),
                //       ),
                //     ]),
                //   ),
                // ),

                ListView.separated(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (context,index) => buildPostItem(context,ProjectCubit.get(context).postModel[index],index),
                  separatorBuilder: (context,index) => SizedBox(height: 10,),
                  itemCount: ProjectCubit.get(context).postModel.length,
                ),
                SizedBox(
                  height: 10,
                )
              ],
            ),
          ),
          fallback:(context) => Center(child: CircularProgressIndicator()),
        );
      },

    );

  }
  Widget buildPostItem(context,PostModel model,index) => Card(
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
                  '${model.image}'),
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
                    Text('${model.dateTime}',
                        style: Theme.of(context)
                            .textTheme
                            .caption!
                            .copyWith(height: 1.4))
                  ],
                )),
            SizedBox(
              width: 15,
            ),
            // IconButton(
            //     onPressed: () {},
            //     icon: Icon(
            //       Icons.more_horiz,
            //       size: 18,
            //     )),
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
        // Padding(
        //   padding: const EdgeInsets.only(top: 5, bottom: 10),
        //   child: Container(
        //     width: double.infinity,
        //     child: Wrap(
        //       children: [
        //         Padding(
        //           padding: const EdgeInsetsDirectional.only(end: 4),
        //           child: Container(
        //             height: 20,
        //             child: MaterialButton(
        //               onPressed: () {},
        //               minWidth: 1,
        //               padding: EdgeInsets.zero,
        //               child: Text('#flutter',
        //                   style: Theme.of(context)
        //                       .textTheme
        //                       .caption!
        //                       .copyWith(color: defaultColor)),
        //             ),
        //           ),
        //         ),
        //         Padding(
        //           padding: const EdgeInsetsDirectional.only(end: 4),
        //           child: Container(
        //             height: 20,
        //             child: MaterialButton(
        //               onPressed: () {},
        //               minWidth: 1,
        //               padding: EdgeInsets.zero,
        //               child: Text('#software',
        //                   style: Theme.of(context)
        //                       .textTheme
        //                       .caption!
        //                       .copyWith(color: defaultColor)),
        //             ),
        //           ),
        //         ),
        //       ],
        //     ),
        //   ),
        // ),
        if(model.postImage != '')
          Padding(
            padding: const EdgeInsetsDirectional.only(top: 15),
            child: Container(
              height: 140,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                image: DecorationImage(
                  image: NetworkImage(
                      '${model.postImage}'
                  ),

                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 5),
          child: Row(
            children: [
              Expanded(
                  child: InkWell(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      child: Row(
                        children: [
                          Icon(
                            Icons.favorite_border,
                            size: 18,
                            color: Colors.red,
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Text(
                            '${ProjectCubit.get(context).likes[index]}',
                            style: TextStyle(color: Colors.grey),
                          )
                        ],
                      ),
                    ),
                    onTap: (){},
                  )),
              Expanded(
                  child: InkWell(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Icon(
                            Icons.comment_outlined,
                            size: 18,
                            color: Colors.amber,
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Text(
                            '0',
                            style: TextStyle(color: Colors.grey),
                          )
                        ],
                      ),
                    ),
                    onTap: (){},
                  ))
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
        Row(
          children: [
            Expanded(
              child: InkWell(
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 17,
                      backgroundImage: NetworkImage(
                          '${ProjectCubit.get(context).userModel!.image}'),
                    ),
                    SizedBox(
                      width: 15,
                    ),

                    Text('write a comment...',
                        style: Theme.of(context)
                            .textTheme
                            .caption!
                            .copyWith(height: 1.4)),
                  ],
                ),
                onTap: (){
                  navigateTo(context, CommentsScreen(postId: model.postId,));
                },
              ),
            ),
            InkWell(
              child: Row(
                children: [
                  Icon(
                    Icons.favorite_border,
                    size: 18,
                    color: Colors.red,
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Text(
                    'Like',
                    style: Theme.of(context).textTheme.caption,
                  )
                ],
              ),
              onTap: (){
                ProjectCubit.get(context).getLikes(ProjectCubit.get(context).postId[index]);

              },
            )


          ],
        )
      ]),
    ),
  );
}


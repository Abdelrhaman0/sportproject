import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sports_project/component/conest.dart';
import 'package:sports_project/component/other_component.dart';
import 'package:sports_project/layout/cubit/cubit.dart';
import 'package:sports_project/layout/cubit/states.dart';
import 'package:sports_project/pages/add_post/add_post_screen.dart';
import 'package:sports_project/pages/setting/setting_screen.dart';

class ProfileScreen extends StatelessWidget {
  static String id = 'ProfileScreen';

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProjectCubit, ProjectStates>(
        listener: (context, state) {},
        builder: (context, state) {
          var model = ProjectCubit.get(context).userModel;
          return ConditionalBuilder(
            condition: model!.image != null,
            builder: (context) => Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 12),
                        child: CircleAvatar(
                          radius: 54,
                          backgroundColor:
                              Theme.of(context).scaffoldBackgroundColor,
                          child: CircleAvatar(
                            radius: 50,
                            backgroundImage: NetworkImage(
                                '${model?.image ?? "https://icons8.com/icon/AZazdsitsrgg/user"}'),
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
                                '100',
                                style: Theme.of(context).textTheme.caption,
                              ),
                            ],
                          ),
                          onTap: () {},
                        ),
                      ),
                      // Expanded(
                      //   child: InkWell(
                      //     child: Column(
                      //       children: [
                      //         Text(
                      //           'Photos',
                      //           style: Theme.of(context).textTheme.subtitle1,
                      //         ),
                      //         Text(
                      //           '236',
                      //           style: Theme.of(context).textTheme.caption,
                      //         ),
                      //       ],
                      //     ),
                      //     onTap: (){},
                      //   ),
                      // ),
                      Expanded(
                        child: InkWell(
                          child: Column(
                            children: [
                              Text(
                                'Followers',
                                style: Theme.of(context).textTheme.subtitle1,
                              ),
                              Text(
                                '1M',
                                style: Theme.of(context).textTheme.caption,
                              ),
                            ],
                          ),
                          onTap: () {},
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
                                '35',
                                style: Theme.of(context).textTheme.caption,
                              ),
                            ],
                          ),
                          onTap: () {},
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
                        Text('${model!.name}',
                            style: Theme.of(context).textTheme.bodyText1),
                        SizedBox(
                          width: 4,
                        ),
                        // Icon(
                        //   Icons.verified,
                        //   color: kPrimaryColor,
                        //   size: 16,
                        // )
                      ],
                    ),
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
                  // Padding(
                  //   padding: const EdgeInsets.symmetric(vertical: 20),
                  //   child: Row(
                  //     children: [
                  //       Expanded(
                  //         child: InkWell(
                  //           child: Column(
                  //             children: [
                  //               Text(
                  //                 'Posts',
                  //                 style: Theme.of(context).textTheme.subtitle1,
                  //               ),
                  //               Text(
                  //                 '100',
                  //                 style: Theme.of(context).textTheme.caption,
                  //               ),
                  //             ],
                  //           ),
                  //           onTap: (){},
                  //         ),
                  //       ),
                  //       // Expanded(
                  //       //   child: InkWell(
                  //       //     child: Column(
                  //       //       children: [
                  //       //         Text(
                  //       //           'Photos',
                  //       //           style: Theme.of(context).textTheme.subtitle1,
                  //       //         ),
                  //       //         Text(
                  //       //           '236',
                  //       //           style: Theme.of(context).textTheme.caption,
                  //       //         ),
                  //       //       ],
                  //       //     ),
                  //       //     onTap: (){},
                  //       //   ),
                  //       // ),
                  //       Expanded(
                  //         child: InkWell(
                  //           child: Column(
                  //             children: [
                  //               Text(
                  //                 'Followers',
                  //                 style: Theme.of(context).textTheme.subtitle1,
                  //               ),
                  //               Text(
                  //                 '1M',
                  //                 style: Theme.of(context).textTheme.caption,
                  //               ),
                  //             ],
                  //           ),
                  //           onTap: (){},
                  //         ),
                  //       ),
                  //       Expanded(
                  //         child: InkWell(
                  //           child: Column(
                  //             children: [
                  //               Text(
                  //                 'Following',
                  //                 style: Theme.of(context).textTheme.subtitle1,
                  //               ),
                  //               Text(
                  //                 '35',
                  //                 style: Theme.of(context).textTheme.caption,
                  //               ),
                  //             ],
                  //           ),
                  //           onTap: (){},
                  //         ),
                  //       )
                  //     ],
                  //   ),
                  // ),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            Navigator.pushNamed(context, AddPostScreen.id);
                          },
                          child: Text(
                            'Add Post',
                          ),
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
                          ))
                    ],
                  )
                ],
              ),
            ),
            fallback: (context) => Center(
              child: CircularProgressIndicator(),
            ),
          );
        });
  }
}

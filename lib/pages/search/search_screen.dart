import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sports_project/component/other_component.dart';
import 'package:sports_project/layout/cubit/cubit.dart';
import 'package:sports_project/layout/cubit/states.dart';
import 'package:sports_project/models/user_model.dart';
import 'package:sports_project/pages/chats/chat_detail.dart';

class SearchScreen extends StatelessWidget {
  static String id = 'SearchScreen';

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProjectCubit,ProjectStates>(
      listener: (context, state) {},
      builder: (context, state) {
        return ConditionalBuilder(
          condition: ProjectCubit.get(context).users.length > 0,
          builder: (BuildContext context) =>  ListView.separated(
              physics: BouncingScrollPhysics(),
              itemBuilder: (context, index) => chatItemBuilder(ProjectCubit.get(context).users[index],context),
              separatorBuilder: (context, index) => myDivider(),
              itemCount: ProjectCubit.get(context).users.length),
          fallback: (BuildContext context) => Center(child: CircularProgressIndicator(),),

        );
      },
    );
  }

  Widget chatItemBuilder(UserModel model,context) => InkWell(
    onTap: (){navigateTo(context, ChatDetailsScreen(userModel: model,));},
    child: Padding(
      padding: const EdgeInsets.all(15.0),
      child: Row(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundImage: NetworkImage(
                '${model.image}'),
          ),
          SizedBox(
            width: 15,
          ),
          Text(
            '${model.name}',
            style: TextStyle(
              height: 1.4,
            ),
          ),
        ],
      ),
    ),
  );

}


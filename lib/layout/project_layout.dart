import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sports_project/component/conest.dart';
import 'package:sports_project/layout/cubit/cubit.dart';
import 'package:sports_project/layout/cubit/states.dart';
import 'package:sports_project/pages/add_post/add_post_screen.dart';

class ProjectLayout extends StatelessWidget {
  static String id = 'ProjectLayout';

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProjectCubit, ProjectStates>(
        listener: (context, state) {
      if (state is ProjectAddPostState) {
        Navigator.pushNamed(context, AddPostScreen.id);
      }
    }, builder: (context, state) {
      var cubit = ProjectCubit.get(context);
      return Scaffold(
        appBar: AppBar(
          title: Text(
            cubit.title[cubit.currentIndex],
            style: TextStyle(color: kPrimaryColor),
          ),
        ),
        body: cubit.screens[cubit.currentIndex],
        bottomNavigationBar: BottomNavigationBar(
          onTap: (index) {
            cubit.changeBottomNav(index);
          },
          currentIndex: cubit.currentIndex,
          items: [
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.home_filled,
                ),
                label: 'Home'),
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.newspaper,
                ),
                label: 'News'),
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.add_box_outlined,
                ),
                label: 'Posts'),
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.chat_outlined,
                ),
                label: 'Chats'),
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.person_2_rounded,
                ),
                label: 'Profile')
          ],
        ),
      );
    });
  }
}

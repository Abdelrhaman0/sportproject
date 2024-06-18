import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sports_project/component/conest.dart';
import 'package:sports_project/layout/cubit/cubit.dart';
import 'package:sports_project/layout/cubit/states.dart';
import 'package:sports_project/pages/add_post/add_post_screen.dart';
import 'package:sports_project/pages/search/search_screen.dart';

class ProjectLayout extends StatelessWidget {
  static String id = 'ProjectLayout';

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProjectCubit, ProjectStates>(
      listener: (context, state) {
        if (state is ProjectAddPostState) {
          Navigator.pushNamed(context, AddPostScreen.id);
        }
      },
      builder: (context, state) {
        var cubit = ProjectCubit.get(context);
        return Scaffold(
          appBar: AppBar(
            title: Text(
              cubit.title[cubit.currentIndex],
              style: TextStyle(
                color: kPrimaryColor,
                fontWeight: FontWeight.bold,
                fontSize: 22,
              ),
            ),
            actions: [
              IconButton(
                onPressed: () {
                  Navigator.pushNamed(context, SearchScreen.id);
                },
                icon: Icon(Icons.search, size: 30, color: kPrimaryColor),
              ),
            ],
            backgroundColor: Colors.white,
            elevation: 5,
            shadowColor: Colors.grey.withOpacity(0.5),
            iconTheme: IconThemeData(color: kPrimaryColor),
          ),
          body: IndexedStack(
            index: cubit.currentIndex,
            children: cubit.screens,
          ),
          floatingActionButton: cubit.currentIndex == 0
              ? FloatingActionButton(
            onPressed: () {
              Navigator.pushNamed(context, AddPostScreen.id);
            },
            child: Icon(Icons.add),
            backgroundColor: kPrimaryColor,
            elevation: 8,
          )
              : null,
          bottomNavigationBar: Container(
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  spreadRadius: 5,
                  blurRadius: 7,
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
              child: BottomNavigationBar(
                onTap: (index) {
                  cubit.changeBottomNav(index);
                },
                currentIndex: cubit.currentIndex,
                backgroundColor: Colors.white,
                selectedItemColor: kPrimaryColor,
                unselectedItemColor: Colors.grey,
                selectedFontSize: 14,
                unselectedFontSize: 12,
                elevation: 20,
                type: BottomNavigationBarType.fixed,
                items: [
                  BottomNavigationBarItem(
                    icon: Icon(Icons.home_filled),
                    label: 'Home',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.newspaper),
                    label: 'News',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.add_box_outlined),
                    label: 'Posts',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.chat_outlined),
                    label: 'Chats',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.person_2_rounded),
                    label: 'Profile',
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

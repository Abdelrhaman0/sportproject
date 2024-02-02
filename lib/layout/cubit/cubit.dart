import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sports_project/component/shared/cache_helper.dart';
import 'package:sports_project/layout/cubit/states.dart';
import 'package:sports_project/pages/add_post/add_post_screen.dart';
import 'package:sports_project/pages/chats/chats_screen.dart';
import 'package:sports_project/pages/home/home_screen.dart';
import 'package:sports_project/pages/news/news_screen.dart';
import 'package:sports_project/pages/profile/profile_screen.dart';

class ProjectCubit extends Cubit<ProjectStates> {
  ProjectCubit() : super(ProjectInitialState());

  static ProjectCubit get(context) => BlocProvider.of(context);


  int currentIndex = 0;
  List<Widget> screens = [
    HomeScreen(),
    NewsScreen(),
    AddPostScreen(),
    ChatsScreen(),
    ProfileScreen(),
  ];

  List<String> title = ['Home', 'News', 'Posts', 'Chats', 'Profile'];

  void changeBottomNav(int index) {
    if (index == 2) {
      emit(ProjectAddPostState());
    } else {
      currentIndex = index;
      emit(ProjectChangeBottomNavState());
    }
  }

}
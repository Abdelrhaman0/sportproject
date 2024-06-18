import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sports_project/component/bloc_observer.dart';
import 'package:sports_project/component/conest.dart';
import 'package:sports_project/component/shared/cache_helper.dart';
import 'package:sports_project/component/shared/dio_helper.dart';
import 'package:sports_project/component/style/theme.dart';
import 'package:sports_project/firebase_options.dart';
import 'package:sports_project/layout/cubit/cubit.dart';
import 'package:sports_project/layout/cubit/states.dart';
import 'package:sports_project/layout/project_layout.dart';
import 'package:sports_project/models/post_model.dart';
import 'package:sports_project/pages/add_post/add_post_screen.dart';
import 'package:sports_project/pages/chats/chat_detail.dart';
import 'package:sports_project/pages/comments/comments_screen.dart';
import 'package:sports_project/pages/initial_page/initial_page.dart';
import 'package:sports_project/pages/login_page/login_page.dart';
import 'package:sports_project/pages/profile/profile_screen.dart';
import 'package:sports_project/pages/register_page/register_page.dart';
import 'package:sports_project/pages/search/search_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  Bloc.observer = MyBlocObserver();
  DioHelper.init();
  await CacheHelper.init();

  // Fetch initial data
  token = CacheHelper.getData(key: 'token');

  uid = CacheHelper.getData(key: 'uid');
  Widget projectWidget;

  if (uid != null) {
    projectWidget = ProjectLayout();
  } else {
    projectWidget = LoginPage();
  }

  runApp(SportsProject(projectWidget));
}

class SportsProject extends StatelessWidget {
  final Widget projectWidget;
  const SportsProject(this.projectWidget, {super.key});
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ProjectCubit()
        ..getUser()
        ..getPost()
        ..getUsers()
      ..getUserPost(uid!),
      child: BlocConsumer<ProjectCubit, ProjectStates>(
        listener: (context, state) {},
        builder: (context, state) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: lightTheme,
            // darkTheme: darkTheme,
            routes: {
              InitialPage.id: (context) => InitialPage(),
              LoginPage.id: (context) => LoginPage(),
              RegisterPage.id: (context) => RegisterPage(),
              ProjectLayout.id: (context) => ProjectLayout(),
              AddPostScreen.id: (context) => AddPostScreen(),
              SearchScreen.id: (context) => SearchScreen(),
              ChatDetailsScreen.id: (context) => ChatDetailsScreen(),
            },
            home: projectWidget,
          );
        },
      ),
    );
  }
}

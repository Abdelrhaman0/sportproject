import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sports_project/component/bloc_observer.dart';
import 'package:sports_project/component/style/theme.dart';
import 'package:sports_project/firebase_options.dart';
import 'package:sports_project/layout/cubit/cubit.dart';
import 'package:sports_project/layout/cubit/states.dart';
import 'package:sports_project/layout/project_layout.dart';
import 'package:sports_project/pages/add_post/add_post_screen.dart';
import 'package:sports_project/pages/initial_page/initial_page.dart';
import 'package:sports_project/pages/login_page/login_page.dart';
import 'package:sports_project/pages/register_page/register_page.dart';

void main() async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  Bloc.observer = MyBlocObserver();

  runApp(const SportsProject());
}

class SportsProject extends StatelessWidget {
  const SportsProject({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ProjectCubit(),
      child: BlocConsumer<ProjectCubit, ProjectStates>(
        listener: (context, state) {},
        builder: (context, state) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: lightTheme,
            darkTheme: darkTheme,
            routes: {
              InitialPage.id: (context) => InitialPage(),
              LoginPage.id: (context) => LoginPage(),
              RegisterPage.id: (context) => RegisterPage(),
              ProjectLayout.id: (context) => ProjectLayout(),
              AddPostScreen.id: (context) => AddPostScreen(),
            },
            initialRoute: InitialPage.id,
          );
        },
      ),
    );
  }
}

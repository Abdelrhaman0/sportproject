import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sports_project/component/conest.dart';
import 'package:sports_project/layout/cubit/cubit.dart';
import 'package:sports_project/layout/cubit/states.dart';
import 'package:sports_project/pages/home/following_page.dart';
import 'package:sports_project/pages/home/post_page.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProjectCubit, ProjectStates>(
      listener: (context, state) {
        if (state is ProjectGetLikesSuccessState || state is ProjectUnlikePostSuccessState) {
          // Handle any specific logic for like/unlike success if needed
        }
      },
      builder: (context, state) {
        return Scaffold(
          body: Column(
            children: [
              Container(
                color: Colors.white,
                // padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildNavigationBarItem('For You', 0),
                    _buildNavigationBarItem('Following', 1),
                  ],
                ),
              ),
              Expanded(
                child: PageView(
                  controller: _pageController,
                  onPageChanged: (index) {
                    setState(() {
                      _currentPage = index;
                    });
                  },
                  children: [
                    PostsPage(),
                    FollowingScreen(),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildNavigationBarItem(String title, int pageIndex) {
    bool isSelected = _currentPage == pageIndex;
    return GestureDetector(
      onTap: () {
        _pageController.animateToPage(
          pageIndex,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      },
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        decoration: BoxDecoration(
          border: isSelected
              ? Border(bottom: BorderSide(color: kPrimaryColor, width: 3))
              : null,
        ),
        child: Text(
          title,
          style: TextStyle(
            color: isSelected ? kPrimaryColor : Colors.grey,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}

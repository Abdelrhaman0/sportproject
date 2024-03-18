import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sports_project/component/conest.dart';
import 'package:sports_project/component/other_component.dart';
import 'package:sports_project/layout/cubit/cubit.dart';
import 'package:sports_project/layout/cubit/states.dart';
import 'package:sports_project/pages/setting/setting_screen.dart';

class ProfileScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProjectCubit,ProjectStates>(
      listener: (context,state){},
      builder: (context,state){
        var model = ProjectCubit.get(context).userModel;
        return  Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container (
                height: 180,
                child: Stack(
                  alignment: Alignment.bottomLeft,
                  children: [
                    Align(
                      child: Container(
                        width: double.infinity,
                        height: 150,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(4),
                            topRight: Radius.circular(4),
                          ),
                          image: DecorationImage(
                            image: NetworkImage(
                                '${model!.cover}'),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      alignment: Alignment.topCenter,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 12),
                      child: CircleAvatar(
                        radius: 54,
                        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                        child: CircleAvatar(
                          radius: 50,
                          backgroundImage: NetworkImage(
                              '${model!.image}')
                          ,
                        ),
                      ),
                    ),

                  ],
                ),
              ),
              SizedBox(
                height: 5,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20),
                child: Row(
                  children: [
                    Text(
                        '${model!.name}',
                        style: Theme.of(context).textTheme.bodyText1
                    ),
                    SizedBox(
                      width: 4,
                    ),
                    Icon(
                      Icons.verified,
                      color: kPrimaryColor,
                      size: 16,
                    )
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
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Row(
                  children: [
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
                        onTap: (){},
                      ),
                    ),
                    Expanded(
                      child: InkWell(
                        child: Column(
                          children: [
                            Text(
                              'Photos',
                              style: Theme.of(context).textTheme.subtitle1,
                            ),
                            Text(
                              '236',
                              style: Theme.of(context).textTheme.caption,
                            ),
                          ],
                        ),
                        onTap: (){},
                      ),
                    ),
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
                        onTap: (){},
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
                        onTap: (){},
                      ),
                    )
                  ],
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: (){},
                      child: Text(
                        'Add Photo',
                      ),

                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  OutlinedButton(
                      onPressed: (){
                        navigateTo(context, SettingScreen());
                      },
                      child: Icon(Icons.edit_outlined))
                ],
              )
            ],
          ),
        );
      },
    );
  }}

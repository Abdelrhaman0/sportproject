import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sports_project/component/conest.dart';
import 'package:sports_project/component/default_button.dart';
import 'package:sports_project/component/other_component.dart';
import 'package:sports_project/layout/cubit/cubit.dart';
import 'package:sports_project/layout/cubit/states.dart';
import 'package:sports_project/pages/login_page/login_page.dart';

class SettingScreen extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProjectCubit, ProjectStates>(
      listener: (context, state) {
          if(state is ProjectSignOutSuccessState){
            Navigator.pushNamedAndRemoveUntil(
                context, LoginPage.id, (route) => false);
          }
      },
      builder: (context, state) {

        var nameController = TextEditingController();
        var bioController = TextEditingController();
        var phoneController = TextEditingController();

        nameController.text = ProjectCubit.get(context).userModel!.name!;
        bioController.text = ProjectCubit.get(context).userModel!.bio!;
        phoneController.text = ProjectCubit.get(context).userModel!.phone!;

        var model = ProjectCubit.get(context).userModel;

        File? profileImage = ProjectCubit.get(context).profileImage;
        ImageProvider<Object>? profileBackground = (profileImage != null
            ? FileImage(profileImage)
            : NetworkImage('${model!.image}')) as ImageProvider<Object>?;

        return Scaffold(
          appBar: AppBar(
            leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(Icons.arrow_back_ios_new),
            ),
            title: Text('Edit Profile'),
            actions: [
              TextButton(
                onPressed: () {
                  ProjectCubit.get(context).updateUser(name: nameController.text, bio: bioController.text, phone: phoneController.text);
                },
                child: Text('Update'),
              ),
            ],
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  if(state is ProjectUploadUserLoadingState)
                    LinearProgressIndicator(),
                  if(state is ProjectUploadUserLoadingState)
                    SizedBox(
                      height: 10,
                    ),
                  Container(
                    height: 180,
                    child: Stack(
                      alignment: Alignment.bottomLeft,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 12),
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              CircleAvatar(
                                  radius: 75,
                                  backgroundImage: profileBackground
                              ),
                              IconButton(
                                onPressed: () {
                                  ProjectCubit.get(context).getProfileImage();
                                },
                                icon: Icon(
                                  Icons.edit,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  // if(ProjectCubit.get(context).profileImage != null || ProjectCubit.get(context).coverImage != null )
                    Row(
                      children: [
                        if(ProjectCubit.get(context).profileImage != null)
                          Expanded(child:   Column(
                            children: [
                              Container(
                                width: double.infinity,
                                height: 40.0,
                                child: MaterialButton(
                                  onPressed: (){
                                    ProjectCubit.get(context).uploadProfileImage(name: nameController.text, bio: bioController.text, phone: phoneController.text);
                                  },
                                  child: Text(
                                    'upload profile'.toUpperCase(),
                                    style: TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(
                                    3,
                                  ),
                                  color: kPrimaryColor,
                                ),
                              ),
                              // SizedBox(height: 5 ,),
                              // LinearProgressIndicator(),
                            ],
                          )),


                      ],
                    ),
                  SizedBox(
                    height: 20,
                  ),
                  defaultFormField(
                    controller: nameController,
                    type: TextInputType.text,
                    validate: (String? value) {
                      if (value == null || value.isEmpty) {
                        return 'The name must not be empty';
                      } else {
                        return null;
                      }
                    },
                    label: 'Name',
                    prefix: Icons.person,
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  defaultFormField(
                    controller: bioController,
                    type: TextInputType.text,
                    validate: (String? value) {},
                    label: 'Bio',
                    prefix: Icons.info,
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  defaultFormField(
                    controller: phoneController,
                    type: TextInputType.phone,
                    validate: (String? value) {
                      if (value == null || value.isEmpty) {
                        return 'The phone must not be empty';
                      } else {
                        return null;
                      }
                    },
                    label: 'Phone',
                    prefix: Icons.phone,
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  DefaultButton(
                      label: 'Log out',
                    onTap: (){
                        ProjectCubit.get(context).singOut();

                    },
                    buttonColor: kPrimaryColor,
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

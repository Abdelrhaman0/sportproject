import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sports_project/component/conest.dart';
import 'package:sports_project/layout/cubit/cubit.dart';
import 'package:sports_project/layout/cubit/states.dart';
import 'package:sports_project/models/message_model.dart';
import 'package:sports_project/models/user_model.dart';

class ChatDetailsScreen extends StatelessWidget {
  ChatDetailsScreen({this.userModel});

  static String id = 'ChatDetailsScreen';
  UserModel? userModel;

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (BuildContext context) {
        ProjectCubit.get(context).getMassage(receiverId: userModel!.uid);

        return BlocConsumer<ProjectCubit, ProjectStates>(
          listener: (context, state) {},
          builder: (context, state) {
            var massageController = TextEditingController();
            var now = DateTime.now();
            return Scaffold(
              appBar: AppBar(
                leading: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(Icons.arrow_back_ios_new),
                ),
                titleSpacing: 0,
                title: Row(
                  children: [
                    CircleAvatar(
                      radius: 20,
                      backgroundImage: NetworkImage('${userModel!.image}'),
                    ),
                    SizedBox(
                      width: 15,
                    ),
                    Text('${userModel!.name}')
                  ],
                ),
              ),
              body: ConditionalBuilder(
                condition: true,
                builder: (BuildContext context) => Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                    children: [
                      Expanded(
                        child: ListView.separated(
                            itemBuilder: (context, index) {
                              var massage =
                                  ProjectCubit.get(context).massages[index];
                              if (ProjectCubit.get(context).userModel!.uid ==
                                  massage.senderId) {
                                return buildMyMassage(massage);
                              } else {
                                return buildMassage(massage);
                              }
                            },
                            separatorBuilder: (context, index) => SizedBox(
                                  height: 10,
                                ),
                            itemCount:
                              ProjectCubit.get(context).massages.length),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Row(
                          children: [
                            Expanded(
                                child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15),
                                  border: Border.all(color: Color(0xFFE0E0E0))),
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                child: TextFormField(
                                  controller: massageController,
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: 'type your massage...',
                                  ),
                                ),
                              ),
                            )),
                            SizedBox(
                              width: 5,
                            ),
                            IconButton(
                              onPressed: () {
                                ProjectCubit.get(context).sendMassage(
                                    text: massageController.text,
                                    receiverId: userModel!.uid.toString(),
                                    dateTime: now.toString());
                              },
                              icon: Icon(Icons.send,
                                  size: 30, color: kPrimaryColor),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                fallback: (BuildContext context) =>
                    Center(child: CircularProgressIndicator()),
              ),
            );
          },
        );
      },
    );
  }

  Widget buildMassage(MassageModel model) => Align(
        alignment: AlignmentDirectional.centerStart,
        child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadiusDirectional.only(
                topStart: Radius.circular(10),
                topEnd: Radius.circular(10),
                bottomEnd: Radius.circular(10),
              ),
              color: Colors.grey[300],
            ),
            padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
            child: Text('${model.text}')),
      );

  Widget buildMyMassage(MassageModel model) => Align(
        alignment: AlignmentDirectional.centerEnd,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadiusDirectional.only(
              topStart: Radius.circular(10),
              topEnd: Radius.circular(10),
              bottomStart: Radius.circular(10),
            ),
            color: kPrimaryColor.withOpacity(.3),
          ),
          padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
          child: Text('${model.text}'),
        ),
      );
}

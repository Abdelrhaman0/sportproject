import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sports_project/component/conest.dart';
import 'package:sports_project/component/default_button.dart';
import 'package:sports_project/component/other_component.dart';
import 'package:sports_project/layout/cubit/cubit.dart';
import 'package:sports_project/pages/login_page/login_page.dart';

class VerifcationScreen extends StatelessWidget {
  const VerifcationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('verify your email',style: TextStyle(color: kPrimaryColor),),
      ),
      body: Column(
        children: [
          Container(
            color: Colors.amber.withOpacity(.6),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
              ),
              child: Row(
                children: [
                  Icon(Icons.info_outline, color: Colors.red),
                  SizedBox(width: 10),
                  Expanded(child: Text('Please verify your email')),
                  SizedBox(width: 10),
                  MaterialButton(
                    onPressed: () {
                      FirebaseAuth.instance.currentUser!.sendEmailVerification().then((value) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Check your email for verification.')),
                        );
                      }).catchError((error) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Failed to send verification email.')),
                        );
                      });
                      ProjectCubit.get(context).userModel!.isEmailVerified=true;
                    },
                    child: Text(
                      'Send',
                      style: TextStyle(color: kPrimaryColor),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Spacer(),
          DefaultButton(label: 'edit my email address',onTap: (){navigateTo(context, LoginPage());},buttonColor: kPrimaryColor,),
          SizedBox(height: 30,),
        ],
      ),
    );
  }
}

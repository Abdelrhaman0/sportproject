import 'package:flutter/material.dart';
import 'package:sports_project/component/conest.dart';
import 'package:sports_project/component/default_button.dart';
import 'package:sports_project/pages/login_page/login_page.dart';

class ConfirmScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('check your email to reset the password'),
          DefaultButton(label: 'back to login page',
            onTap: (){
              Navigator.pushNamedAndRemoveUntil(
                  context, LoginPage.id, (route) => false);
            },
            buttonColor: kPrimaryColor,)
        ],
      ),
    ) ;
  }
}

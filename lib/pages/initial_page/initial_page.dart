import 'package:flutter/material.dart';
import 'package:sports_project/component/conest.dart';
import 'package:sports_project/component/default_button.dart';
import 'package:sports_project/pages/login_page/login_page.dart';
import 'package:sports_project/pages/register_page/register_page.dart';

class InitialPage extends StatelessWidget {
  const InitialPage({super.key});

  static String id = 'InitialPage';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 200,),
            // Image.asset('assets/images/icons8_sport.png'),
            Text(
              'SPORTS',
              style: TextStyle(
                  fontSize: 52,
                  fontFamily: 'Pacifico',
                  color: kPrimaryColor),
            ),
            Text(
              'FOR TALENT',
              style: TextStyle(
                color: kPrimaryColor,
              ),
            ),
            SizedBox(height: 100,),
            DefaultButton(
              label: 'Login',
              onTap: () {
                Navigator.pushNamed(context, LoginPage.id);
              },
              buttonColor: Color(0xff78b955),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              'or',
              style: TextStyle(color: Colors.grey, fontSize: 12),
            ),
            SizedBox(
              height: 10,
            ),
            DefaultButton(
              label: 'Sign Up',
              onTap: () {
                Navigator.pushNamed(context, RegisterPage.id);
              },
              buttonColor: Color(0xfffbcc62),
            )
          ],
        ),
      ),
    );
  }
}

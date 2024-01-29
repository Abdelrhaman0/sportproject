import 'package:flutter/material.dart';
import 'package:sports_project/component/conest.dart';
import 'package:sports_project/component/default_button.dart';
import 'package:sports_project/component/default_text_field.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  static String id = 'RegisterPage';

  @override
  Widget build(BuildContext context) {
    GlobalKey<FormState> formKey = GlobalKey();

    return Scaffold(
      body: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 200,),
                Text(
                  'SPORTS',
                  style: TextStyle(
                      fontSize: 52, fontFamily: 'Pacifico', color: kPrimaryColor),
                ),
                Text(
                  'FOR TALENT',
                  style: TextStyle(
                    color: kPrimaryColor,
                  ),
                ),
                SizedBox(height: 40,),
                DefaultTextFormField(
                  hintText: 'Name',
                  onChange: (String value){},
                  prefixIcon: Icon(Icons.person,color: kPrimaryColor,),
                ),
                SizedBox(height: 15,),
                DefaultTextFormField(
                  hintText: 'Email',
                  onChange: (String value){},
                  prefixIcon: Icon(Icons.email_outlined,color: kPrimaryColor,),
                ),
                SizedBox(height: 15,),
                DefaultTextFormField(
                  hintText: 'Phone',
                  onChange: (String value){},
                  prefixIcon: Icon(Icons.phone_android,color: kPrimaryColor,),
                ),
                SizedBox(height: 15,),
                DefaultTextFormField(
                  hintText: 'Password',
                  onChange: (String value){},
                  prefixIcon: Icon(Icons.lock_open_outlined,color: kPrimaryColor,),
                  suffixIcon: Icon(Icons.remove_red_eye_outlined,color: kPrimaryColor,),
                ),
                SizedBox(height: 30,),
                DefaultButton(label: 'Sign Up',onTap: (){},buttonColor:kPrimaryColor,),
                SizedBox(height: 15,),


              ],
            ),
          ),
        ),
      ),
    );
  }
}

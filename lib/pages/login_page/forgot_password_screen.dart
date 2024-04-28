import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sports_project/component/conest.dart';
import 'package:sports_project/component/default_button.dart';
import 'package:sports_project/component/default_text_field.dart';
import 'package:sports_project/component/other_component.dart';
import 'package:sports_project/pages/login_page/confirm_screen.dart';
import 'package:sports_project/pages/login_page/cubit/cubit.dart';
import 'package:sports_project/pages/login_page/cubit/states.dart';

class ForgotPasswordScreen extends StatelessWidget {
  GlobalKey<FormState> formKey = GlobalKey();

  var emailController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => LoginCubit(),
      child: BlocConsumer<LoginCubit, LoginStates>(
        listener: (context, state) => {
          if (state is ResetPasswordErrorState) {
            Fluttertoast.showToast(
              msg: state.error,
              backgroundColor: Colors.grey,
              textColor: Colors.white,
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              fontSize: 16,
            )
          },
          if (state is LoginSuccessState) {
            navigateTo(context,ConfirmScreen())
          }
        },
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
              leading: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(Icons.arrow_back_ios_new),
              ),
              title: Text('Reset password'),
            ),
            body: SingleChildScrollView(
              child: Form(
                key: formKey,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 200,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Text(
                            'Enter your email to to send the password reset link to you',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        DefaultTextFormField(
                          controller: emailController,
                          hintText: 'Email',
                          onChange: (String value) {},
                          prefixIcon: Icon(
                            Icons.email_outlined,
                            color: kPrimaryColor,
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        DefaultButton(
                          label: 'Rest password',
                          onTap: () {
                            LoginCubit.get(context).passwordReset(email: emailController.text);
                          },
                          buttonColor: kPrimaryColor,
                        )
                      ]),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

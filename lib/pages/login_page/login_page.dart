import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sports_project/component/conest.dart';
import 'package:sports_project/component/default_button.dart';
import 'package:sports_project/component/default_text_field.dart';
import 'package:sports_project/component/other_component.dart';
import 'package:sports_project/component/shared/cache_helper.dart';
import 'package:sports_project/layout/project_layout.dart';
import 'package:sports_project/pages/login_page/cubit/cubit.dart';
import 'package:sports_project/pages/login_page/cubit/states.dart';
import 'package:sports_project/pages/login_page/forgot_password_screen.dart';
import 'package:sports_project/pages/register_page/register_page.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  static String id = 'LoginPage';

  @override
  Widget build(BuildContext context) {
    GlobalKey<FormState> formKey = GlobalKey();

    var emailController = TextEditingController();
    var passwordController = TextEditingController();

    return BlocProvider(
      create: (BuildContext context) => LoginCubit(),
      child: BlocConsumer<LoginCubit, LoginStates>(
        listener: (context, state) {
          if (state is LoginErrorState) {
            Fluttertoast.showToast(
              msg: state.error,
              backgroundColor: Colors.grey,
              textColor: Colors.white,
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              fontSize: 16,
            );
          }
          if (state is LoginSuccessState) {
            CacheHelper.saveData(key: 'uid', value: state.uid).then((value) {
              Navigator.pushNamedAndRemoveUntil(
                  context, ProjectLayout.id, (route) => false);
            });
          }
        },
        builder: (context, state) {
          return Scaffold(
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
                      SizedBox(
                        height: 40,
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
                        height: 15,
                      ),
                      TextFormField(
                        controller: passwordController,
                        keyboardType: TextInputType.visiblePassword,
                        style: TextStyle(color: Colors.black),
                        obscureText: LoginCubit.get(context).isPassword,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderSide: BorderSide(color: kPrimaryColor),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          prefixIcon: Icon(
                            Icons.key_outlined,
                            color: kPrimaryColor,
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(
                              LoginCubit.get(context).suffix,
                              color: Colors.grey,
                            ),
                            onPressed: () {
                              LoginCubit.get(context)
                                  .changePasswordVisibility();
                            },
                          ),
                          hintText: 'Password',
                          hintStyle: TextStyle(color: Colors.grey),
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'password must be not empty';
                          }
                        },
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            GestureDetector(
                              onTap: () {
                                navigateTo(context, ForgotPasswordScreen());
                              },
                              child: Text(
                                'Forgot Password?',
                                style: TextStyle(color: kPrimaryColor),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      DefaultButton(
                        label: 'Login',
                        onTap: () {
                          if (formKey.currentState!.validate()) {
                            LoginCubit.get(context).userLogin(
                                email: emailController.text,
                                password: passwordController.text);
                          }
                        },
                        buttonColor: kPrimaryColor,
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Don\'t have account?  ',
                            style: TextStyle(
                              color: Colors.black,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(context, RegisterPage.id);
                            },
                            child: Text(
                              'Register',
                              style: TextStyle(color: kPrimaryColor),
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

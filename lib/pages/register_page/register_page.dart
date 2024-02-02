import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sports_project/component/conest.dart';
import 'package:sports_project/component/default_button.dart';
import 'package:sports_project/component/default_text_field.dart';
import 'package:sports_project/pages/login_page/login_page.dart';
import 'package:sports_project/pages/register_page/cubit/cubit.dart';
import 'package:sports_project/pages/register_page/cubit/states.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  static String id = 'RegisterPage';

  @override
  Widget build(BuildContext context) {
    GlobalKey<FormState> formKey = GlobalKey();

    var emailController = TextEditingController();
    var nameController = TextEditingController();
    var passwordController = TextEditingController();
    var phoneController = TextEditingController();

    return BlocProvider(
      create: (BuildContext context) => RegisterCubit(),
      child: BlocConsumer<RegisterCubit, RegisterStates>(
        listener: (context, state) {
          if(state is CreateUserErrorState){
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
          if (state is CreateUserSuccessState) {
            Navigator.pushNamed(context, LoginPage.id);
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
                        hintText: 'Name',
                        onChange: (String value) {},
                        prefixIcon: Icon(
                          Icons.person,
                          color: kPrimaryColor,
                        ),
                        controller: nameController,
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      DefaultTextFormField(
                        hintText: 'Email',
                        onChange: (String value) {},
                        prefixIcon: Icon(
                          Icons.email_outlined,
                          color: kPrimaryColor,
                        ),
                        controller: emailController,
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      DefaultTextFormField(
                        hintText: 'Phone',
                        onChange: (String value) {},
                        prefixIcon: Icon(
                          Icons.phone_android,
                          color: kPrimaryColor,
                        ),
                        controller: phoneController,
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      TextFormField(
                        controller: passwordController,
                        keyboardType: TextInputType.visiblePassword,
                        style: TextStyle(color: Colors.black),
                        obscureText: RegisterCubit.get(context).isPassword,
                        decoration: InputDecoration(
                          border:OutlineInputBorder(
                            borderSide: BorderSide(color:kPrimaryColor),
                            borderRadius: BorderRadius.circular(20),),
                          prefixIcon: Icon(
                            Icons.key_outlined,color: kPrimaryColor,
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(RegisterCubit.get(context).suffix,color: Colors.grey,),
                            onPressed: () {
                              RegisterCubit.get(context)
                                  .changePasswordVisibility();
                            },
                          ),
                          hintText: 'Password',
                          hintStyle: TextStyle(color: Colors.grey),
                        ),
                        validator: (value){
                          if(value!.isEmpty) {
                            return 'password must be not empty';
                          }
                        },
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      DefaultButton(
                        label: 'Sign Up',
                        onTap: () {
                          if (formKey.currentState!.validate()) {
                            RegisterCubit.get(context).userRegister(
                                email: emailController.text,
                                name: nameController.text,
                                phone: phoneController.text,
                                password: passwordController.text);
                          }
                        },
                        buttonColor: kPrimaryColor,
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

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sports_project/pages/login_page/cubit/states.dart';

class LoginCubit extends Cubit<LoginStates> {

  LoginCubit() : super(LoginInitialState());

  static LoginCubit get(context) => BlocProvider.of(context);

  void userLogin({required String email, required String password}) {

    emit(LoginLoadingState());

    FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password).then((value) {
      print(value.user?.email);
      emit(LoginSuccessState(value.user!.uid));
    }).catchError((error){
      emit(LoginErrorState(error.toString()));
    });
  }
  IconData suffix = Icons.visibility_outlined;
  bool isPassword = true;

  void changePasswordVisibility(){
    isPassword = !isPassword;
    if(isPassword)
    {
      suffix = Icons.visibility_outlined;
    }
    else{
      suffix =Icons.visibility_off_outlined;
    }
    emit(ChangePasswordVisibilityState());
  }

  Future passwordReset({required String email}) async{
    await FirebaseAuth.instance.sendPasswordResetEmail(email: email).then((value){
      emit(ResetPasswordSuccessState());
    }).catchError((error){
      emit(ResetPasswordErrorState(error));
    });

  }
}

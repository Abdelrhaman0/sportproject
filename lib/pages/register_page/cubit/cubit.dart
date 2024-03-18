import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sports_project/models/user_model.dart';
import 'package:sports_project/pages/register_page/cubit/states.dart';

class RegisterCubit extends Cubit<RegisterStates>{

  RegisterCubit() : super(RegisterInitialState());

  static RegisterCubit get(context) => BlocProvider.of(context);

  void userRegister(
      {required String name,
        required String email,
        required String password,
        required String phone}) {
    FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password)
        .then((value) {
      userCreate(name: name, email: email, uid: value.user!.uid, phone: phone);
    }).catchError((error) {
      print(error.toString());
      emit(RegisterErrorState(error.toString()));
    });
  }

  void userCreate(
      {required String name,
        required String email,
        required String uid,
        required String phone}) {
    emit(CreateUserLoadingState());
    UserModel model = UserModel(
      name: name,
      email: email,
      phone: phone,
      uid: uid,
      image: 'https://plus.unsplash.com/premium_photo-1684241183904-9fc59d3a96e5?q=80&w=1887&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
      cover: 'https://img.freepik.com/free-photo/friends-having-fun-with-traditional-games_23-2149332630.jpg?t=st=1696504517~exp=1696505117~hmac=9843b537ba4946ef3e1f3dfb8d01c4f34da63abd69e54d073b618960e87bdca8',
      bio: 'write your bio...',
      isEmailVerified: false,
    );

    FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .set(model.toMap())
        .then((value) {
      emit(CreateUserSuccessState());
    }).catchError((error) {
      print(error.toString());
      emit(CreateUserErrorState(error.toString()));
    });
  }

  IconData suffix = Icons.visibility_outlined;
  bool isPassword = true;

  void changePasswordVisibility() {
    isPassword = !isPassword;
    if (isPassword) {
      suffix = Icons.visibility_outlined;
    } else {
      suffix = Icons.visibility_off_outlined;
    }

    print(isPassword);
    emit(RegisterChangePasswordVisibilityState());
  }


}
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class UserManager{
  storeNewUser(user,context){
    Firestore.instance.collection('/users').add({
      'email': user.email,
      'uid': user.uid,
    }).then((value){
Navigator.of(context).pop();
Navigator.of(context).pushReplacementNamed('/CropPred');
    }).catchError((e){
      print(e);
    });
  }
}
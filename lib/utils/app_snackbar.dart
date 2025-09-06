
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';


showErrorBar(message){
  Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.TOP,
      timeInSecForIosWeb: 3,
      backgroundColor: const Color(0xff50212a),
      textColor: Colors.white,
      fontSize: 14.0,
      webBgColor: "linear-gradient(to right, #FF4F4F, #FF4F4F)",
      webShowClose: true,
      webPosition: 'center'
  );
}

showSuccessBar(message){

  Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.TOP,
      timeInSecForIosWeb: 3,
      backgroundColor: const Color(0xff504e21),
      textColor: Colors.white,
      fontSize: 14.0,
      webBgColor: "linear-gradient(to right, #1B9968, #1B9968)",
      webShowClose: true,
      webPosition: 'center'

  );

}

showInfoBar(message){
  Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.TOP,
      timeInSecForIosWeb: 3,
      backgroundColor: const Color(0xff726f2f),
      textColor: Colors.white,
      fontSize: 14.0
  );


}
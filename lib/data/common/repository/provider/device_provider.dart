import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:subcript/config/enviroment/enviroment.dart';




class DeviceProvider extends GetConnect {

  String url = Environment.apiUrl;
  String? token = GetStorage().read('token');


  Future<void> postTokenFireBase(String tokenFireBase,String id) async {
    Response response = await post('$url/users/update-fcm-token', {"tokenFirebase": tokenFireBase,"userId": id

        },
        headers: {'Authorization': 'Bearer $token','Content-Type': 'application/json'});

    if(response.hasError==401){
     // Get.snackbar('Error', 'error al actualizar FCM',backgroundColor: const Color(0xFFe5133d), colorText: Colors.white);
      GetStorage().erase();
      Get.offNamedUntil('/login', (route) => false);
    }

    //log("hola"+response.body.toString());

  }


}

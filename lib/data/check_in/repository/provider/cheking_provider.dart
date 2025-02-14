import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:subcript/config/enviroment/enviroment.dart';
import 'package:subcript/ui/theme/colors.dart';

class ChekingProvider extends GetConnect {
  String url = Environment.apiUrl;
  String? token = GetStorage().read('token');

  Future<Response> cheking(
    double? lat,
    double? long,
    String? comment,
    String device,
    String? idCompany,
    String? username,
    String? pinCode,
  ) async {
    Response response = await post('$url/time-records/checkin-checkout', {
      if (lat != null) "latitude": lat,
      if (long != null) "longitude": long,
      if (comment != null) "comment": comment,
      "device": device,
      "companySelected": idCompany,
      if (username != null) "username": username,
      if (pinCode != null) "pinCode": pinCode,
    }, headers: {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json'
    });


    return response;
  }

  Future<Response> getPurpose(String? idCompany) async {
    Response response = await post('$url/pause-purpose/get-company-purpose', {
      "companyId": idCompany
    }, headers: {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json'
    });

    if (response.body['data'] == null) {
      //Get.snackbar('Error', 'No se pudo ejecutar la peticion');
      return response;
    }

    return response;
  }

  Future<Response> getIsCheking() async {
    Response response = await post('$url/time-records/is-checkin', {},
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json'
        });

    if (response.body['data'] == null) {
      //Get.snackbar('Error', 'No se pudo ejecutar la peticion');
      return response;
    }

    return response;
  }

  Future<Response> getIsBreakIn(String? idCompany,String? username) async {
    Response response = await post('$url/break-time/is-breakin', {
      if (username != null) "username":username
    }, headers: {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json'
    });

    if (response.body['data'] == null) {
      //Get.snackbar('Error', 'No se pudo ejecutar la peticion');
      return response;
    }

    return response;
  }

  Future<Response> getListCheking(
      String? idCompany, int page, int? month, int? year) async {
    Response response = await post('$url/timerecord/getAppTimeRecord', {
      "monthNumber": month,
      "yearNumber": year,
      "limit": 30,
      "page": page
    }, headers: {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json'
    });

    if (response.body == null) {
      //Get.snackbar('Error', 'No se pudo ejecutar la peticion');
      return response;
    }

    return response;
  }

  Future<Response> checkInCheckOutPause(
      String? pin, String? userName, int? purpose, String? companyId) async {
    Response response = await post('$url/break-time/breakin-breakout', {
       "purposeId": purpose.toString(),
      if (userName != null) "username": userName,
      if (pin != null) "pinCode": pin,
      if (pin != null) "companySelected": companyId,
    }, headers: {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json'
    });

    if (response.body['success'] == true) {
      Get.snackbar('Pausa', response.body['message'],
          backgroundColor: mainGreenColorButton, colorText: Colors.white);

      return response;
    } else {

        Get.snackbar('Pausa', response.body['message'],
            backgroundColor: orangeColorButton, colorText: Colors.white);

        return response;
      }

  }

  Future<Response> listPausePurposeHub(String? cif) async {
    Response response = await post('$url/company/get-break-types/$cif', {},
        headers: {'Content-Type': 'application/json'});

    return response;
  }
}

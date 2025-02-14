import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:subcript/config/enviroment/enviroment.dart';
import 'package:subcript/data/auth/model/companyConfi.dart';
import 'package:subcript/data/auth/repository/provider/user_provider.dart';
import 'package:subcript/data/check_in/model/listCheking.dart';
import 'package:subcript/data/check_in/model/purpose.dart';
import 'package:subcript/data/check_in/repository/provider/cheking_provider.dart';
import 'package:subcript/ui/theme/colors.dart';


class ChekingController extends GetxController {
  String url = Environment.apiUrl;

  cheking(double? lat,double? long,String? comment,String device,String? idCompany) async {
    Response responseApi = await ChekingProvider().cheking(lat,long,comment,device,idCompany,null,null);

    if (responseApi.body['success'] != null) {
      /*Get.snackbar(
        "Checkin",
        responseApi.body['message'],
        backgroundColor: greenColorButton,
        colorText: Colors.white,
      );*/
    } else {
      Get.snackbar('Error', 'Error durante el cheking',
          backgroundColor: const Color(0xFFe5133d), colorText: Colors.white);
    }
  }

  Future<CompanyConfi> getConfigCompany(String? idCompany) async {
    Response responseApi = await UserProvider().getConfigCompany(idCompany);
    CompanyConfi config;
    config = CompanyConfi.fromJson(responseApi.body['data']);
    return config;
  }

   Future<Response> pause(int? purpose_id) async {
    Response responseApi = await ChekingProvider().checkInCheckOutPause(null,null,purpose_id,null);
/*
    if (responseApi.body['data']['id'] == null) {
     Get.snackbar('Error', 'Ha ocurrido un error al generar la pausa.',
          backgroundColor: orangeColorButton, colorText: Colors.white);
    }
*/


    return responseApi;
  }

 /* Future<bool> validatorCheckin(double? lat_user, double? long_user, String? idCompany) async {
    Response responseApi =
        await UserProvider().validatorCheckin(lat_user, long_user,idCompany);
    bool check = responseApi.body['data'];


    return check;
  }*/

  Future<List<Purpose>> getPurposeList(String? idCompany) async {
    Response responseApi = await ChekingProvider().getPurpose(idCompany);

    if (responseApi.body['data'] != null) {
      List<Purpose> listPurpose =
          Purpose.fromJsonList(responseApi.body['data']);
      return listPurpose;
      /*Get.snackbar('Cheking', responseApi.body['message'] ,
          backgroundColor: const Color(0xFF00dba2a), colorText: Colors.white);*/
    }
      return [];

  }

  Future<Response> getIsCheking() async {
    Response responseApi = await ChekingProvider().getIsCheking();

    if (responseApi.body['data'] != null) {
      GetStorage()
          .write('statusCheking', responseApi.body['data']['isCheckIn']);
      return responseApi;
    } else {
      Get.snackbar('Error', 'Sesión expirada,reiniciando',
          backgroundColor: const Color(0xFFe5133d), colorText: Colors.white);
      Get.offNamedUntil('/', (route) => false);
      return Response();
    }
  }

  Future<Response> getIsBreakIn(String? idCompany) async {
    Response responseApi = await ChekingProvider().getIsBreakIn(idCompany, null);
    if (responseApi.body['data'] != null) {
      GetStorage()
          .write('statusBreakIn', responseApi.body['data']);

    }
    return responseApi;
  }

  Future<List<ListCheking>> chekingList(String? idCompany,int page, int? month, int? year) async {

    Response responseApi =
        await ChekingProvider().getListCheking(idCompany,page, month, year);

    if (responseApi.body != null) {
      List<ListCheking> listCheking =
          ListCheking.fromJsonList(responseApi.body['data']['data_list']);

      return listCheking;
    } else {
      Get.snackbar('Error', 'Sesión expirada,reiniciando',
          backgroundColor: const Color(0xFFe5133d), colorText: Colors.white);
      Get.offNamedUntil('/', (route) => false);
      return [];
    }
  }
}

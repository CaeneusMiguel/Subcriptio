import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:subcript/config/enviroment/enviroment.dart';

class HolidaysProvider extends GetConnect {
  String url = Environment.apiUrl;
  String? token = GetStorage().read('token');

  Future<Response> getListHolidays(
      int page, String? status, String idUser) async {
    Map<String, dynamic> filterFilters = {
      "user": idUser,
    };

    if (status != "4") {
      filterFilters["accepted"] = status;
    }

    Response response = await post('$url/holidays-aux/get', {


      "filter_orders": {},
      "filter_filters": filterFilters,
      "limit": 20,
      "page": page,

    }, headers: {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json'
    });

    if (response.body == null) {
     // Get.snackbar('Error', 'No se pudo ejecutar la peticion');
      return response;
    }

    return response;
  }

  Future<Response> requestHolidays(String? message, String? idUser, int? companyId, String? startDate, String? endDate) async {
    Response response = await post('$url/holidays-aux/create', {
      "userSelected": idUser, "startDate": startDate, "endDate": endDate, "description": message
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
}

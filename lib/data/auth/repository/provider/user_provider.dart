import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:subcript/config/enviroment/enviroment.dart';
import 'package:http/http.dart' as http;

class UserProvider extends GetConnect {
  String url = Environment.apiUrl;
  String? token = GetStorage().read('token');

  Future<Response> login(String email, String pass, String device) async {
    Response response = await post('$url/login_check',
        {'_username': email, '_password': pass, '_type': device},
        contentType: 'application/x-www-form-urlencoded');
    if (response.body['data'] == null) {
      //Get.snackbar('Error', 'No se pudo ejecutar la peticion');
      return response;
    }

    return response;
  }

  Future<Response> loginCifCompany(
      String email, String pass, String cif, String device) async {
    Response response = await post('$url/login_check',
        {'_username': email, '_password': pass, '_cif': cif, '_type': device},
        contentType: 'application/x-www-form-urlencoded');
    if (response.body['data'] == null) {
      Get.snackbar('Error', '${response.body['message']}',
          backgroundColor: const Color(0xFFe5133d), colorText: Colors.white);
      return response;
    }

    return response;
  }

  Future<Response> validatorCheckin(
      double? lat_user, double? long_user, String? idCompany) async {
    lat_user ??= 0.0;
    long_user ??= 0.0;

    Response response = await post('$url/users/validate-location', {
      "latitude": lat_user,
      "longitude": long_user,
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

  Future<String> recoverPassword(String? user) async {
    var uri = Uri.parse('$url/users/forgot-password');

    var request = http.MultipartRequest('POST', uri);
    request.fields['email'] = user!;

    request.headers['Content-Type'] = 'multipart/form-data';

    var streamedResponse = await request.send();
    var response = await http.Response.fromStream(streamedResponse);

    if (response.body.contains('true')) {
      return "Email enviado con exito, revisa tu email para modificar tu contraseña.";
    } else {
      return "No se encontro al usuario introducido. Por favor intentelo de nuevo";
    }
  }

  Future<String> recoverPinHub(String? user) async {
    var uri = Uri.parse('$url/users/forgot-pin-code');

    var request = http.MultipartRequest('POST', uri);
    request.fields['email'] = user!;

    request.headers['Content-Type'] = 'multipart/form-data';

    var streamedResponse = await request.send();
    var response = await http.Response.fromStream(streamedResponse);

    if (response.body.contains('true')) {
      return "Email enviado con exito, revisa tu email para modificar tu contraseña.";
    } else {
      return "No se encontro al usuario introducido. Por favor intentelo de nuevo";
    }
  }

  Future<Response> getConfigCompany(String? idCompany) async {
    Response response = await post('$url/company/get-config', {
      "companyId": idCompany
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

  Future<Response> updatePassword(
      String? id, String password, String rePassword) async {
    Response response = await post('$url/users/modify-password', {
      "userId": id,
      "password": password,
      "re_password": rePassword
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

  Future<Response> updatePin(String? id, String password) async {
    Response response = await post('$url/users/change-pin-code', {
      "userId": id,
      "pinCode": password,
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

  Future<void> updateImage(String? id_user, File? profileImg) async {
    if (profileImg != null) {
      try {
        final uri = Uri.parse('$url/users/update-image-admin');
        final request = http.MultipartRequest('POST', uri);

        request.headers.addAll({
          'Authorization': 'Bearer $token',
          'Content-Type': 'multipart/form-data',
        });

        request.fields['userId'] = id_user ?? '';

        request.files.add(await http.MultipartFile.fromPath(
          'file',
          profileImg.path,
        ));

        final response = await request.send();

        if (response.statusCode == 200) {
          final responseData = await response.stream.bytesToString();
          print('Imagen actualizada correctamente: $responseData');
        } else if (response.statusCode == 401) {
          Get.snackbar(
            'Error',
            'Usuario desactivado',
            backgroundColor: const Color(0xFFe5133d),
            colorText: Colors.white,
          );
          GetStorage().erase();
          Get.offNamedUntil('/login', (route) => false);
        } else {
          final responseData = await response.stream.bytesToString();
          print('Error al actualizar la imagen: $responseData');
          Get.snackbar(
            'Error',
            'No se pudo actualizar la imagen',
            backgroundColor: const Color(0xFFe5133d),
            colorText: Colors.white,
          );
        }
      } catch (e) {
        print('Error al enviar la imagen: $e');
        Get.snackbar(
          'Error',
          'Error al enviar la imagen',
          backgroundColor: const Color(0xFFe5133d),
          colorText: Colors.white,
        );
      }
    } else {
      print('No se seleccionó ninguna imagen');
      Get.snackbar(
        'Error',
        'No se seleccionó ninguna imagen',
        backgroundColor: const Color(0xFFe5133d),
        colorText: Colors.white,
      );
    }
  }

  Future<String> imageToBase64(File filePath) async {
    try {
      // Lee el archivo de imagen como bytes
      List<int> imageBytes = await filePath.readAsBytes();

      // Convierte los bytes a una cadena base64
      String base64String = base64Encode(Uint8List.fromList(imageBytes));

      return base64String;
    } catch (e) {
      return "";
    }
  }
}

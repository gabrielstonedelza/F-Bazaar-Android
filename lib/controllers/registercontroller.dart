import 'package:get/get.dart';

import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

import '../screens/loginview.dart';
import '../statics/appcolors.dart';

class RegistrationController extends GetxController {
  bool isPosting = false;
  registerUser(String uname, String email, String phoneNumber, String uPassword,
      String uRePassword) async {
    const loginUrl = "https://f-bazaar.com/auth/users/";
    final myLogin = Uri.parse(loginUrl);

    http.Response response = await http.post(myLogin, headers: {
      "Content-Type": "application/x-www-form-urlencoded"
    }, body: {
      "username": uname,
      "email": email,
      "phone": phoneNumber,
      "password": uPassword,
      "re_password": uRePassword,
      "user_type": "Customer"
    });

    if (response.statusCode == 201) {
      isPosting = false;
      Get.snackbar("Success", "Your account was created successfully.",
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: defaultYellow,
          duration: const Duration(seconds: 5));
      Get.offAll(() => const LoginView());
    } else {
      Get.snackbar("Error 😢", response.body.toString(),
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 5));
      return;
    }
  }
}

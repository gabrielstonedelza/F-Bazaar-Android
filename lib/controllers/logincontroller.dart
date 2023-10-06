import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

import '../../screens/homepage.dart';
import '../../statics/appcolors.dart';

class LoginController extends GetxController {
  final client = http.Client();
  final storage = GetStorage();
  late List allCustomers = [];
  late List customersEmails = [];
  bool isLoading = false;

  @override
  void onInit() {
    super.onInit();
    getAllCustomers();
  }

  Future<void> getAllCustomers() async {
    try {
      isLoading = true;
      const profileLink = "https://f-bazaar.com/users/customers/";
      var link = Uri.parse(profileLink);
      http.Response response = await http.get(link, headers: {
        "Content-Type": "application/x-www-form-urlencoded",
      });
      if (response.statusCode == 200) {
        var jsonData = jsonDecode(response.body);
        allCustomers = jsonData;
        for (var i in allCustomers) {
          if (!customersEmails.contains(i['email'])) {
            customersEmails.add(i['email']);
          }
        }

        update();
      } else {
        if (kDebugMode) {
          print(response.body);
        }
      }
    } catch (e) {
      // Get.snackbar("Sorry","something happened or please check your internet connection",snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading = false;
      update();
    }
  }

  loginUser(String email, String password) async {
    const loginUrl = "https://f-bazaar.com/auth/token/login/";
    final myLink = Uri.parse(loginUrl);
    http.Response response = await client.post(myLink,
        headers: {"Content-Type": "application/x-www-form-urlencoded"},
        body: {"email": email, "password": password});

    if (response.statusCode == 200) {
      final resBody = response.body;
      var jsonData = jsonDecode(resBody);
      var userToken = jsonData['auth_token'];
      if (customersEmails.contains(email)) {
        storage.write("token", userToken);
        Get.offAll(() => const HomePage());
      } else {
        Get.snackbar("Sorry 😢", "you are not a customer",
            duration: const Duration(seconds: 5),
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: warning,
            colorText: defaultTextColor1);
        storage.remove("token");
        storage.remove("username");
      }
    } else {
      Get.snackbar("Sorry 😢", "invalid details",
          duration: const Duration(seconds: 5),
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: warning,
          colorText: defaultTextColor1);
      storage.remove("token");
    }
  }
}

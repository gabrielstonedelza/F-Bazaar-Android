import 'package:fbazaar/screens/homepage.dart';
import 'package:fbazaar/statics/appcolors.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

import '../screens/pages/mainhome.dart';

class OrderController extends GetxController {
  bool isLoading = true;
  late List allMyOrders = [];
  late List pendingOrders = [];
  late List deliveredOrders = [];
  late List processingOrders = [];
  late List pickedUpOrders = [];
  int responseStatus = 0;

  Future<void> getAllMyOrders(String token) async {
    const profileLink = "https://f-bazaar.com/order/my_orders/";
    var link = Uri.parse(profileLink);
    http.Response response = await http.get(link, headers: {
      "Content-Type": "application/x-www-form-urlencoded",
      "Authorization": "Token $token"
    });
    if (response.statusCode == 200) {
      var jsonData = jsonDecode(response.body);
      allMyOrders.assignAll(jsonData);
      // print(response.body);
      update();
    } else {
      if (kDebugMode) {
        print(response.body);
      }
    }
  }

  Future<void> getAllPendingOrders(String token) async {
    const profileLink = "https://f-bazaar.com/order/get_all_my_pending_orders/";
    var link = Uri.parse(profileLink);
    http.Response response = await http.get(link, headers: {
      "Content-Type": "application/x-www-form-urlencoded",
      "Authorization": "Token $token"
    });
    if (response.statusCode == 200) {
      var jsonData = jsonDecode(response.body);
      pendingOrders.assignAll(jsonData);
      update();
    } else {
      if (kDebugMode) {
        print(response.body);
      }
    }
  }

  Future<void> getAllProcessingOrders(String token) async {
    const profileLink =
        "https://f-bazaar.com/order/get_all_my_processing_orders/";
    var link = Uri.parse(profileLink);
    http.Response response = await http.get(link, headers: {
      "Content-Type": "application/x-www-form-urlencoded",
      "Authorization": "Token $token"
    });
    if (response.statusCode == 200) {
      var jsonData = jsonDecode(response.body);
      processingOrders.assignAll(jsonData);
      update();
    } else {
      if (kDebugMode) {
        print(response.body);
      }
    }
  }

  Future<void> getAllPickedUpOrders(String token) async {
    const profileLink =
        "https://f-bazaar.com/order/get_all_my_picked_up_orders/";
    var link = Uri.parse(profileLink);
    http.Response response = await http.get(link, headers: {
      "Content-Type": "application/x-www-form-urlencoded",
      "Authorization": "Token $token"
    });
    if (response.statusCode == 200) {
      var jsonData = jsonDecode(response.body);
      pickedUpOrders.assignAll(jsonData);

      update();
    } else {
      if (kDebugMode) {
        print(response.body);
      }
    }
  }

  Future<void> getAllDeliveredOrders(String token) async {
    const profileLink =
        "https://f-bazaar.com/order/get_all_my_delivered_orders/";
    var link = Uri.parse(profileLink);
    http.Response response = await http.get(link, headers: {
      "Content-Type": "application/x-www-form-urlencoded",
      "Authorization": "Token $token"
    });
    if (response.statusCode == 200) {
      var jsonData = jsonDecode(response.body);
      deliveredOrders.assignAll(jsonData);
      update();
    } else {
      if (kDebugMode) {
        print(response.body);
      }
    }
  }

  Future<void> placeOrder(
      String token,
      String cartId,
      String quantity,
      String price,
      String category,
      String size,
      String paymentMethod,
      String dropOffLat,
      String dropOffLng,
      String deliveryMethod,
      String unCode) async {
    final requestUrl = "https://f-bazaar.com/order/place_order/$cartId/";
    final myLink = Uri.parse(requestUrl);
    final response = await http.post(myLink, headers: {
      "Content-Type": "application/x-www-form-urlencoded",
      'Accept': 'application/json',
      "Authorization": "Token $token"
    }, body: {
      "cart": cartId,
      "quantity": quantity,
      "category": category,
      "size": size,
      "payment_method": paymentMethod,
      "delivery_method": deliveryMethod,
      "drop_off_location_lat": dropOffLat,
      "drop_off_location_lng": dropOffLng,
      "price": price,
      "ordered": "True",
      "unique_order_code": unCode,
    });
    if (response.statusCode == 201) {
      responseStatus = response.statusCode;
      // Get.snackbar("Hurray 😀", "your order was successful.",
      //     colorText: defaultTextColor1,
      //     snackPosition: SnackPosition.TOP,
      //     backgroundColor: newDefault,
      //     duration: const Duration(seconds: 5));
      update();
      Get.offAll(() => const HomePage());
    } else {
      responseStatus = response.statusCode;
      Get.snackbar(
        "Order Error",
        "Something went wrong",
        duration: const Duration(seconds: 5),
        colorText: defaultTextColor1,
        backgroundColor: warning,
      );
    }
  }

  Future<void> deleteOrder(String id, String token) async {
    final url = "https://f-bazaar.com/cart/cart/$id/delete/";
    var myLink = Uri.parse(url);
    final response = await http.get(myLink, headers: {
      "Content-Type": "application/x-www-form-urlencoded",
      'Accept': 'application/json',
      "Authorization": "Token $token"
    });

    if (response.statusCode == 204) {
      Get.snackbar("Oh no 😢", "Order was deleted successfully.",
          colorText: defaultTextColor1,
          snackPosition: SnackPosition.TOP,
          backgroundColor: newDefault,
          duration: const Duration(seconds: 5));
      update();
    } else {
      // print(response.body);
      Get.snackbar("Sorry 😝", "something went wrong. Please try again later",
          colorText: defaultTextColor1,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: warning,
          duration: const Duration(seconds: 5));
    }
  }
}

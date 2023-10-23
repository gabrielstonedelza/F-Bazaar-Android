import 'package:fbazaar/statics/appcolors.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

class CartController extends GetxController {
  bool isLoading = true;
  late List cartItems = [];
  late List cartItemsPrices = [];

  late List cartIds = [];
  late List cartItemsIds = [];
  double sumTotal = 0.0;

  Future<void> getAllMyCartItems(String token) async {
    const profileLink = "https://f-bazaar.com/cart/get_all_my_cart_items/";
    var link = Uri.parse(profileLink);
    http.Response response = await http.get(link, headers: {
      "Content-Type": "application/x-www-form-urlencoded",
      "Authorization": "Token $token"
    });
    if (response.statusCode == 200) {
      var jsonData = jsonDecode(response.body);
      cartItems.assignAll(jsonData);
      for (var i in cartItems) {
        if (!cartIds.contains(i['id'].toString())) {
          cartIds.add(i['id'].toString());
          sumTotal = sumTotal + double.parse(i['price'].toString());
        }
        if (!cartItemsIds.contains(i['item'].toString())) {
          cartItemsIds.add(i['item'].toString());
        }
      }

      update();
    } else {
      if (kDebugMode) {
        print("Printing this from cart controller ${response.body}");
      }
    }
  }

  Future<void> addToCart(
      String token, String id, String quantity, String price) async {
    final requestUrl = "https://f-bazaar.com/cart/add_to_cart/$id/";
    final myLink = Uri.parse(requestUrl);
    final response = await http.post(myLink, headers: {
      "Content-Type": "application/x-www-form-urlencoded",
      'Accept': 'application/json',
      "Authorization": "Token $token"
    }, body: {
      "item": id,
      "quantity": quantity,
      "price": price,
    });
    if (response.statusCode == 201) {
      Get.snackbar("Hurray 😀", "item has been added to your cart",
          colorText: defaultTextColor1,
          snackPosition: SnackPosition.TOP,
          backgroundColor: newDefault,
          duration: const Duration(seconds: 5));
      update();
    } else {
      Get.snackbar(
        "Cart Error",
        "item is already in your cart.",
        duration: const Duration(seconds: 5),
        colorText: defaultTextColor1,
        backgroundColor: warning,
      );
    }
  }

  Future<void> removeFromCart(String id, String token, String itemPrice) async {
    final url = "https://f-bazaar.com/cart/cart/$id/delete/";
    var myLink = Uri.parse(url);
    final response = await http.get(myLink, headers: {
      "Content-Type": "application/x-www-form-urlencoded",
      'Accept': 'application/json',
      "Authorization": "Token $token"
    });

    if (response.statusCode == 204) {
      sumTotal = sumTotal - double.parse(itemPrice);
      Get.snackbar("Oh no 😢", "item was removed from your cart",
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

  Future<void> clearCart(String token) async {
    const postUrl = "https://f-bazaar.com/cart/clear_cart/";
    final pLink = Uri.parse(postUrl);
    http.Response res = await http.get(pLink, headers: {
      "Content-Type": "application/x-www-form-urlencoded",
      'Accept': 'application/json',
      "Authorization": "Token $token"
    });
    if (res.statusCode == 204) {
      sumTotal = 0.0;
      update();
    } else {
      // print(res.body);
    }
  }

  Future<void> increaseQuantity(
      String id, String itemId, String token, String itemPrice) async {
    final requestUrl = "https://f-bazaar.com/cart/cart/$id/increase/$itemId/";
    final myLink = Uri.parse(requestUrl);
    final response = await http.put(myLink, headers: {
      "Content-Type": "application/x-www-form-urlencoded",
      'Accept': 'application/json',
      "Authorization": "Token $token"
    }, body: {
      "item": itemId,
    });
    if (response.statusCode == 200) {
      sumTotal = sumTotal + double.parse(itemPrice);
      Get.snackbar("Hurray 😀", "your item quantity has increased",
          colorText: defaultTextColor1,
          snackPosition: SnackPosition.TOP,
          backgroundColor: newDefault,
          duration: const Duration(seconds: 5));
      update();
    } else {
      if (kDebugMode) {
        print(response.body);
      }
    }
  }

  Future<void> decreaseQuantity(
      String id, String itemId, String token, String itemPrice) async {
    final requestUrl = "https://f-bazaar.com/cart/cart/$id/decrease/$itemId/";
    final myLink = Uri.parse(requestUrl);
    final response = await http.put(myLink, headers: {
      "Content-Type": "application/x-www-form-urlencoded",
      'Accept': 'application/json',
      "Authorization": "Token $token"
    }, body: {
      "item": itemId,
    });
    if (response.statusCode == 200) {
      sumTotal = sumTotal - double.parse(itemPrice);
      Get.snackbar("Oh 🥹", "your item quantity has decreased",
          colorText: defaultTextColor1,
          snackPosition: SnackPosition.TOP,
          backgroundColor: newDefault,
          duration: const Duration(seconds: 5));
      update();
    } else {
      if (kDebugMode) {
        print(response.body);
      }
    }
  }
}

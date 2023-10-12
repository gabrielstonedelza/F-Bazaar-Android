import 'dart:convert';

import 'package:fbazaar/statics/appcolors.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class FavoritesController extends GetxController {
  bool isLoading = true;
  List allMyFavorites = [];
  List favoriteIds = [];
  bool isAddingToFavorites = false;
  bool isFavorite = false;

  Future<void> getAllMyFavorites(String token) async {
    try {
      isLoading = true;
      const postUrl = "https://f-bazaar.com/favorites/favorites/";
      final pLink = Uri.parse(postUrl);
      http.Response res = await http.get(pLink, headers: {
        "Content-Type": "application/x-www-form-urlencoded",
        'Accept': 'application/json',
        "Authorization": "Token $token"
      });
      if (res.statusCode == 200) {
        final codeUnits = res.body;
        var jsonData = jsonDecode(codeUnits);
        var allPosts = jsonData;
        allMyFavorites.assignAll(allPosts);
        for (var i in allMyFavorites) {
          if (!favoriteIds.contains(i['item'].toString())) {
            favoriteIds.add(i['item'].toString());
          }
        }
        update();
      } else {
        // print(res.body);
      }
    } catch (e) {
      Get.snackbar("Sorry", "please check your internet connection");
    } finally {
      isLoading = false;
      update();
    }
  }

  Future<void> addToFavorites(String token, String id) async {
    final requestUrl = "https://f-bazaar.com/favorites/add_to_favorites/$id/";
    final myLink = Uri.parse(requestUrl);
    final response = await http.post(myLink, headers: {
      "Content-Type": "application/x-www-form-urlencoded",
      'Accept': 'application/json',
      "Authorization": "Token $token"
    }, body: {
      "item": id,
    });
    if (response.statusCode == 201) {
      Get.snackbar("Hurray 😀", "item was added to your favorites",
          colorText: CupertinoColors.white,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: primaryYellow,
          duration: const Duration(seconds: 5));
    } else {
      print(response.body);
      Get.snackbar(
        "Favorites Error",
        "item is already in your favorites.",
        duration: const Duration(seconds: 5),
        colorText: defaultTextColor1,
        backgroundColor: newDefault,
      );
    }
  }

  Future<void> removeFromFavorites(String id, String token) async {
    final url = "https://f-bazaar.com/favorites/favorite/$id/remove/";
    var myLink = Uri.parse(url);
    final response = await http.get(myLink, headers: {
      "Content-Type": "application/x-www-form-urlencoded",
      'Accept': 'application/json',
      "Authorization": "Token $token"
    });

    if (response.statusCode == 204) {
      Get.snackbar("oh 😢", "item was removed from your favorites",
          colorText: CupertinoColors.white,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: primaryYellow,
          duration: const Duration(seconds: 5));
    } else {
      print(response.body);
      Get.snackbar("Sorry 😝", "something went wrong. Please try again later",
          colorText: CupertinoColors.white,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: CupertinoColors.destructiveRed,
          duration: const Duration(seconds: 5));
    }
  }

  Future<void> clearFavorites(String token) async {
    const postUrl = "https://f-bazaar.com/favorites/favorite/clear_favorites/";
    final pLink = Uri.parse(postUrl);
    http.Response res = await http.get(pLink, headers: {
      "Content-Type": "application/x-www-form-urlencoded",
      'Accept': 'application/json',
      "Authorization": "Token $token"
    });
    if (res.statusCode == 204) {
      // final codeUnits = res.body;
      // var jsonData = jsonDecode(codeUnits);
      // var allPosts = jsonData;
      // allMyOrders.assignAll(allPosts);
      update();
      // print(allMyOrders);
    } else {
      // print(res.body);
    }
  }
}

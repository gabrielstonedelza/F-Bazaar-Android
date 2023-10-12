import 'dart:convert';

import 'package:fbazaar/widgets/loadingui.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../controllers/cartcontroller.dart';
import '../../statics/appcolors.dart';
import 'package:http/http.dart' as http;

class MyCart extends StatefulWidget {
  const MyCart({super.key});

  @override
  State<MyCart> createState() => _MyCartState();
}

class _MyCartState extends State<MyCart> {
  final CartController cartController = Get.find();
  bool isLoading = true;
  late List cartItems = [];
  double sumTotal = 0.0;
  final storage = GetStorage();
  late String uToken = "";

  @override
  void initState() {
    if (storage.read("token") != null) {
      uToken = storage.read("token");
    }
    getAllMyCartItems();
    super.initState();
  }

  Future<void> getAllMyCartItems() async {
    const profileLink = "https://f-bazaar.com/cart/get_all_my_cart_items/";
    var link = Uri.parse(profileLink);
    http.Response response = await http.get(link, headers: {
      "Content-Type": "application/x-www-form-urlencoded",
      "Authorization": "Token $uToken"
    });
    if (response.statusCode == 200) {
      var jsonData = jsonDecode(response.body);
      cartItems.assignAll(jsonData);
      for (var i in cartItems) {
        sumTotal = sumTotal + double.parse(i['price'].toString());
        print(i['price'].toString());
        print(sumTotal);
      }
      setState(() {
        isLoading = false;
      });
    } else {
      if (kDebugMode) {
        print(response.body);
      }
    }
  }

  var items;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: isLoading
            ? const LoadingUi()
            : CustomScrollView(
                slivers: [
                  const SliverAppBar(
                    backgroundColor: defaultTextColor1,
                    pinned: true,
                    stretch: true,
                    elevation: 0,
                    centerTitle: false,
                    expandedHeight: 300,
                    flexibleSpace: const FlexibleSpaceBar(
                      background: Image(
                        image: AssetImage(
                            "assets/images/animation_lnlhh3ko_medium.gif"),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  SliverAppBar(
                    automaticallyImplyLeading: false,
                    backgroundColor: defaultTextColor1,
                    pinned: true,
                    elevation: 0,
                    bottom: const PreferredSize(
                        preferredSize: Size.fromHeight(-10), child: SizedBox()),
                    flexibleSpace: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: RawMaterialButton(
                        fillColor: buttonColor,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                        onPressed: () {
                          //   add a dropdown for users to select quantity
                        },
                        child: Text(
                          "Proceed to checkout ${cartItems.length}",
                          style: const TextStyle(
                              color: defaultTextColor1,
                              fontWeight: FontWeight.bold,
                              fontSize: 20),
                        ),
                      ),
                    ),
                  ),
                  SliverList(
                    delegate: SliverChildBuilderDelegate((context, index) {
                      items = cartItems[index];
                      return Padding(
                        padding: const EdgeInsets.only(
                            left: 8.0, right: 8, bottom: 8.0),
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              color: muted[300]),
                          height: 200,
                          width: MediaQuery.of(context).size.width,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Image(
                                      height: 150,
                                      width: 150,
                                      image:
                                          NetworkImage(items['get_item_pic']),
                                    ),
                                    Column(
                                      children: [
                                        Text(items['get_item_name'],
                                            style: const TextStyle(
                                                fontWeight: FontWeight.w500)),
                                        const SizedBox(height: 5),
                                        Text(
                                            "₵ ${items['get_item_price'].toString()}",
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 18)),
                                      ],
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                      );
                    }, childCount: cartItems != null ? cartItems.length : 0),
                  )
                ],
              ));
  }
}

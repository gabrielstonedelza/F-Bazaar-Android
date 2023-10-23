import 'dart:async';
import 'dart:convert';

import 'package:get/get.dart';
import 'package:fbazaar/widgets/loadingui.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import '../../controllers/cartcontroller.dart';
import '../../controllers/storeitemscontroller.dart';
import '../../statics/appcolors.dart';
import 'package:http/http.dart' as http;

import '../../widgets/components/item_detail_remarks.dart';

class DetailPage extends StatefulWidget {
  final id;
  const DetailPage({super.key, required this.id});

  @override
  State<DetailPage> createState() => _DetailPageState(id: this.id);
}

class _DetailPageState extends State<DetailPage> {
  final id;
  _DetailPageState({required this.id});
  bool isLoading = true;
  final storage = GetStorage();
  late String uToken = "";
  final StoreItemsController storeItemsController = Get.find();

  late List customersRemarks = [];
  late List customersRatings = [];
  late String name = "";
  late String size = "";
  late String oldPrice = "";
  late String newPrice = "";
  late String retailPrice = "";
  late String wholesalePrice = "";
  late String itemPic = "";
  late String description = "";
  int itemQuantity = 1;
  late final TextEditingController _reviewController;
  final FocusNode _reviewFocusNode = FocusNode();
  final _formKey = GlobalKey<FormState>();
  bool isAddingToCart = false;
  bool isAddingToFavorites = false;
  bool isAddingToRemarks = false;
  double itemPrice = 0.0;

  void _addToCart() async {
    setState(() {
      isAddingToCart = true;
    });
    await Future.delayed(const Duration(seconds: 5));
    setState(() {
      isAddingToCart = false;
    });
  }

  void _addToRemarks() async {
    setState(() {
      isAddingToRemarks = true;
    });
    await Future.delayed(const Duration(seconds: 5));
    setState(() {
      isAddingToRemarks = false;
    });
  }

  Future<void> getItem() async {
    final profileLink = "https://f-bazaar.com/store_api/items/$id/detail/";
    var link = Uri.parse(profileLink);
    http.Response response = await http.get(link, headers: {
      "Content-Type": "application/x-www-form-urlencoded",
      "Authorization": "Token $uToken"
    });
    if (response.statusCode == 200) {
      var jsonData = jsonDecode(response.body);
      name = jsonData['name'];
      size = jsonData['size'];
      oldPrice = jsonData['old_price'];
      newPrice = jsonData['new_price'];
      retailPrice = jsonData['retail_price'];
      wholesalePrice = jsonData['wholesale_price'];
      itemPic = jsonData['get_item_pic'];
      description = jsonData['description'];

      setState(() {
        isLoading = false;
        itemPrice = double.parse(newPrice);
      });
    } else {
      if (kDebugMode) {
        print(response.body);
      }
    }
  }

  Future<void> getItemRemarks() async {
    final profileLink = "https://f-bazaar.com/store_api/item/$id/remarks/";
    var link = Uri.parse(profileLink);
    http.Response response = await http.get(link, headers: {
      "Content-Type": "application/x-www-form-urlencoded",
      "Authorization": "Token $uToken"
    });
    if (response.statusCode == 200) {
      var jsonData = jsonDecode(response.body);
      customersRemarks = jsonData;
      setState(() {
        isLoading = false;
      });
    } else {
      if (kDebugMode) {
        print(response.body);
      }
    }
  }

  late Timer _timer;

  @override
  void initState() {
    if (storage.read("token") != null) {
      uToken = storage.read("token");
    }
    getItem();
    getItemRemarks();

    storeItemsController.getItemRemarks(uToken, id);
    _reviewController = TextEditingController();
    super.initState();
  }

  var customersReviews;
  void showReviewForm() {
    showMaterialModalBottomSheet(
      context: context,
      builder: (context) => Card(
        elevation: 12,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(10), topLeft: Radius.circular(10))),
        child: SizedBox(
          height: 450,
          child: Column(
            children: [
              const SizedBox(
                height: 20,
              ),
              Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        maxLength: 100,
                        focusNode: _reviewFocusNode,
                        cursorColor: defaultTextColor2,
                        controller: _reviewController,
                        maxLines: 10,
                        decoration: InputDecoration(
                            labelText: "Enter review here...",
                            labelStyle:
                                const TextStyle(color: defaultTextColor2),
                            focusColor: defaultTextColor2,
                            // fillColor: defaultTextColor2,
                            focusedBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                    color: defaultTextColor2, width: 2),
                                borderRadius: BorderRadius.circular(12)),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12))),
// cursorColor: Colors.black,
// style: const TextStyle(color: Colors.black),
                        keyboardType: TextInputType.text,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Enter review";
                          } else {
                            return null;
                          }
                        },
                      ),
                    ),
                    isAddingToRemarks
                        ? const LoadingUi()
                        : Padding(
                            padding: const EdgeInsets.only(
                                top: 18.0, left: 18.0, right: 18),
                            child: RawMaterialButton(
                              fillColor: newButton,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12)),
                              onPressed: () {
                                setState(() {
                                  isLoading = true;
                                });
                                _addToRemarks();
                                getItem();
                                FocusScopeNode currentFocus =
                                    FocusScope.of(context);

                                if (!currentFocus.hasPrimaryFocus) {
                                  currentFocus.unfocus();
                                }
                                if (!_formKey.currentState!.validate()) {
                                  return;
                                } else {
                                  Navigator.pop(context);
                                  storeItemsController.addToReviews(
                                      uToken, id, _reviewController.text);
                                }
                              },
                              child: const Text(
                                "Save",
                                style: TextStyle(
                                    color: defaultTextColor1,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20),
                              ),
                            ),
                          ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _reviewController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? const LoadingUi()
          : CustomScrollView(
              slivers: [
                SliverAppBar(
                  leading: IconButton(
                      onPressed: () {
                        Get.back();
                      },
                      icon: const Icon(Icons.arrow_back,
                          color: defaultTextColor2, size: 30)),
                  backgroundColor: defaultTextColor1,
                  pinned: true,
                  stretch: true,
                  elevation: 0,
                  centerTitle: false,
                  expandedHeight: 300,
                  flexibleSpace: SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: FlexibleSpaceBar(
                        background: itemPic == ""
                            ? const Image(
                                image: AssetImage("assets/images/fbazaar.png"),
                                fit: BoxFit.fitHeight,
                              )
                            : Image(
                                image: NetworkImage(itemPic),
                                fit: BoxFit.fitHeight,
                              ),
                      ),
                    ),
                  ),
                ),
                SliverList(
                    delegate: SliverChildListDelegate([
                  //     item name and favorite icon
                  Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(name,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 20)),
                      ],
                    ),
                  ),
                  // increase and decrease item quantity and price
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 18.0, right: 18, top: 10, bottom: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Card(
                              elevation: 10,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              child: TextButton(
                                  onPressed: () {
                                    setState(() {
                                      if (itemQuantity == 1) {
                                        Get.snackbar("Order Error",
                                            "Your order cannot be 0",
                                            colorText: Colors.white,
                                            backgroundColor: newPrimary,
                                            duration:
                                                const Duration(seconds: 5));
                                      } else {
                                        itemQuantity--;
                                        itemPrice =
                                            itemPrice - double.parse(newPrice);
                                      }
                                    });
                                  },
                                  child: const Text("—",
                                      style: TextStyle(color: newButton))),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(itemQuantity.toString(),
                                  style: const TextStyle(
                                      color: warning,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20)),
                            ),
                            Card(
                              elevation: 10,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              child: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      itemQuantity++;
                                      itemPrice =
                                          itemPrice + double.parse(newPrice);
                                    });
                                  },
                                  icon: const Icon(Icons.add,
                                      color: newButton, size: 30)),
                            )
                          ],
                        ),
                        Text("₵ $newPrice",
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 20))
                      ],
                    ),
                  ),
                  //       divider
                  const Padding(
                    padding: EdgeInsets.only(top: 5.0, left: 10, right: 10),
                    child: Divider(height: 5, color: newShadow),
                  ),
                  // item description
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(bottom: 8.0),
                          child: Text("Description"),
                        ),
                        Text(
                          description,
                          style: TextStyle(
                              color: muted[600], fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            Text(
                              "Size: ",
                              style: TextStyle(
                                  color: muted[600],
                                  fontWeight: FontWeight.bold),
                            ),
                            Text(
                              size,
                              style: TextStyle(
                                  color: muted[600],
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Padding(
                      padding: const EdgeInsets.only(
                          left: 10.0, top: 10, bottom: 10.0),
                      child: Row(
                        children: [
                          Text("Reviews (${customersRemarks.length})",
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                  color: defaultTextColor2)),
                        ],
                      )),
                  SizedBox(
                    height: 150,
                    child: ItemDetailRemarks(token: uToken, id: id),
                  ),
                  //       add to cart button
                  isAddingToCart
                      ? const LoadingUi()
                      : GetBuilder<CartController>(builder: (controller) {
                          return Padding(
                            padding: const EdgeInsets.only(
                                left: 18.0, right: 18, top: 10, bottom: 10),
                            child: RawMaterialButton(
                              fillColor: newButton,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12)),
                              onPressed: () {
                                _addToCart();
                                controller.addToCart(
                                    uToken,
                                    id,
                                    itemQuantity.toString(),
                                    itemPrice.toString());
                                //   add a dropdown for users to select quantity
                              },
                              child: Text(
                                "Add to cart $itemPrice",
                                style: const TextStyle(
                                    color: defaultTextColor1,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20),
                              ),
                            ),
                          );
                        }),

                  const SizedBox(height: 20)
                ]))
              ],
            ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: newShadow,
        onPressed: () {
          showReviewForm();
        },
        child: const Icon(Icons.message_outlined),
      ),
    );
  }
}

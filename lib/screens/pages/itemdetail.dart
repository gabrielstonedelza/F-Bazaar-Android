import 'package:fbazaar/controllers/cartcontroller.dart';
import 'package:fbazaar/controllers/storeitemscontroller.dart';
import 'package:fbazaar/widgets/loadingui.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'package:get/get.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import '../../controllers/favoritescontroller.dart';
import '../../statics/appcolors.dart';

class ItemDetail extends StatefulWidget {
  final id;
  const ItemDetail({super.key, required this.id});

  @override
  State<ItemDetail> createState() => _ItemDetailState(id: this.id);
}

class _ItemDetailState extends State<ItemDetail> {
  final id;
  _ItemDetailState({required this.id});
  bool isLoading = true;
  final storage = GetStorage();
  late String uToken = "";
  late final TextEditingController _reviewController;
  final FocusNode _reviewFocusNode = FocusNode();
  final client = http.Client();
  final FavoritesController favController = Get.find();
  final CartController cartControllers = Get.find();
  final StoreItemsController storeItemsController = Get.find();
  final List quantityNum = [
    "Quantity",
    "1",
    "2",
    "3",
    "4",
    "5",
    "6",
    "7",
    "8",
    "9",
    "10",
    "11",
    "12",
    "13",
    "14",
    "15",
    "16",
    "17",
    "18",
    "19",
    "20",
    "21",
    "22",
    "23",
    "24",
    "25",
    "26",
    "27",
    "28",
    "29",
    "30",
    "31",
    "32",
    "33",
    "34",
    "35",
    "36",
    "37",
    "38",
    "39",
    "40",
    "41",
    "42",
    "43",
    "44",
    "45",
    "46",
    "47",
    "48",
    "49",
    "50",
  ];
  var _currentSelectedQuantity = "Quantity";
  bool isPosting = false;

  void _startPosting() async {
    setState(() {
      isPosting = true;
    });
    await Future.delayed(const Duration(seconds: 5));
    setState(() {
      isPosting = false;
    });
  }

  final _formKey = GlobalKey<FormState>();
  bool isFavorite = false;

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
                            return "Enter username";
                          } else {
                            return null;
                          }
                        },
                      ),
                    ),
                    isPosting
                        ? const LoadingUi()
                        : Padding(
                            padding: const EdgeInsets.only(
                                top: 18.0, left: 18.0, right: 18),
                            child: RawMaterialButton(
                              fillColor: buttonColor,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12)),
                              onPressed: () {
                                _startPosting();
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
  void initState() {
    if (storage.read("token") != null) {
      uToken = storage.read("token");
    }
    storeItemsController.getItem(uToken, id);
    storeItemsController.getItemRemarks(uToken, id);
    storeItemsController.getItemRatings(uToken, id);
    _reviewController = TextEditingController();

    super.initState();
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
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: const Icon(Icons.arrow_back,
                size: 30, color: defaultTextColor2)),
        actions: [
          IconButton(
              onPressed: () {
                // setState(() {
                //   isLoading = true;
                // });
                storeItemsController.getItem(uToken, id);
              },
              icon: const Icon(Icons.refresh, color: defaultTextColor2))
        ],
      ),
      body: ListView(
        children: [
          // item image
          GetBuilder<StoreItemsController>(builder: (controller) {
            return Card(
              // elevation: 10,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              child: Container(
                  height: 300,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: NetworkImage(controller.itemPic)))),
            );
          }),
          const Divider(color: Colors.blueGrey),
          // item name and size
          Padding(
            padding: const EdgeInsets.only(top: 18.0, left: 18),
            child: Row(
              children: [
                GetBuilder<StoreItemsController>(builder: (controller) {
                  return Text(controller.name,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 18));
                }),
                const Padding(
                  padding: EdgeInsets.only(left: 8.0, right: 8.0),
                  child: Text("-",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                ),
                GetBuilder<StoreItemsController>(builder: (controller) {
                  return Text(controller.size,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 18));
                }),
              ],
            ),
          ),
          // item description
          Padding(
              padding: const EdgeInsets.only(top: 18.0, left: 18, right: 18),
              child: GetBuilder<StoreItemsController>(builder: (controller) {
                return Text(controller.description,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        color: muted));
              })),
          const Divider(color: Colors.blueGrey),
          // item price and favorite
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding:
                    const EdgeInsets.only(left: 18.0, top: 18, bottom: 18.0),
                child: GetBuilder<StoreItemsController>(builder: (controller) {
                  return Text("₵ ${controller.newPrice}",
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 20));
                }),
              ),
              // GetBuilder<FavoritesController>(builder: (controller) {
              //   return IconButton(
              //     onPressed: () {
              //       if (controller.allMyFavoritesItemNames.contains(controller.name)) {
              //         controller.removeFromFavorites(uToken, id);
              //       } else {
              //         controller.addToFavorites(uToken, id);
              //       }
              //     },
              //     icon: controller.allMyFavoritesItemNames.contains(name)
              //         ? const Icon(
              //             Icons.favorite_sharp,
              //             color: warning,
              //             size: 30,
              //           )
              //         : const Icon(
              //             Icons.favorite_border_outlined,
              //           ),
              //   );
              // })
            ],
          ),
          // old price
          Padding(
            padding: const EdgeInsets.only(left: 18.0, bottom: 18.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Text("List Price: ",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                            color: muted)),
                    GetBuilder<StoreItemsController>(builder: (controller) {
                      return Text("₵ ${controller.oldPrice}",
                          style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                              color: muted,
                              decoration: TextDecoration.lineThrough));
                    }),
                  ],
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(
                        bottom: 10.0, right: 18, left: 120),
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey, width: 1)),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 10.0, right: 10),
                        child: DropdownButton(
                          hint: const Text("Quantity"),
                          isExpanded: true,
                          underline: const SizedBox(),
                          items: quantityNum.map((dropDownStringItem) {
                            return DropdownMenuItem(
                              value: dropDownStringItem,
                              child: Text(dropDownStringItem),
                            );
                          }).toList(),
                          onChanged: (newValueSelected) {
                            _onDropDownItemSelectedQuantity(newValueSelected);
                          },
                          value: _currentSelectedQuantity,
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
          // add to cart button
          isPosting
              ? const LoadingUi()
              : Padding(
                  padding:
                      const EdgeInsets.only(top: 18.0, left: 18.0, right: 18),
                  child: GetBuilder<CartController>(builder: (controller) {
                    return RawMaterialButton(
                      fillColor: buttonColor,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      onPressed: () {
                        _startPosting();
                        if (_currentSelectedQuantity == "Quantity") {
                          Get.snackbar(
                              "Quantity Error", "please select quantity",
                              colorText: defaultTextColor1,
                              snackPosition: SnackPosition.TOP,
                              backgroundColor: warning);
                          return;
                        } else {
                          controller.addToCart(
                              uToken,
                              id,
                              _currentSelectedQuantity,
                              storeItemsController.newPrice);
                        }
                        //   add a dropdown for users to select quantity
                      },
                      child: const Text(
                        "Add to cart",
                        style: TextStyle(
                            color: defaultTextColor1,
                            fontWeight: FontWeight.bold,
                            fontSize: 20),
                      ),
                    );
                  }),
                ),
          // customer reviews
          Padding(
            padding: const EdgeInsets.only(left: 18.0, top: 18, bottom: 18.0),
            child: GetBuilder<StoreItemsController>(builder: (controller) {
              return Text(
                  "Customer Reviews (${controller.customersRemarks.length})",
                  style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: defaultTextColor2));
            }),
          ),
          SizedBox(
            height: 100,
            child: GetBuilder<StoreItemsController>(builder: (controller) {
              return ListView.builder(
                  itemCount: controller.customersRemarks != null
                      ? controller.customersRemarks.length
                      : 0,
                  itemBuilder: (context, index) {
                    customersReviews = controller.customersRemarks[index];
                    return Card(
                      elevation: 10,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      child: ListTile(
                        title: Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(customersReviews['get_username'],
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold)),
                              Text(customersReviews['date_added']
                                  .toString()
                                  .split("T")
                                  .first),
                            ],
                          ),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(bottom: 8.0),
                              child: Text(customersReviews['remark']),
                            ),
                          ],
                        ),
                      ),
                    );
                  });
            }),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: buttonColor,
        onPressed: () {
          showReviewForm();
        },
        child: const Icon(Icons.message_outlined),
      ),
    );
  }

  void _onDropDownItemSelectedQuantity(newValueSelected) {
    setState(() {
      _currentSelectedQuantity = newValueSelected;
    });
  }
}

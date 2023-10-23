import 'package:fbazaar/controllers/storeitemscontroller.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

import '../../controllers/cartcontroller.dart';
import '../../screens/pages/detailnew.dart';
import '../../statics/appcolors.dart';
import '../loadingui.dart';

class Products extends StatefulWidget {
  final token;
  const Products({super.key, required this.token});

  @override
  State<Products> createState() => _ProductsState(token: this.token);
}

class _ProductsState extends State<Products> {
  final StoreItemsController storeItemsController = Get.find();
  var items;
  final token;

  _ProductsState({required this.token});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetBuilder<StoreItemsController>(builder: (controller) {
        return ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: controller.storeItems != null
                ? controller.otherItems.length
                : 0,
            itemBuilder: (context, index) {
              items = controller.otherItems[index];
              return InkWell(
                onTap: () {
                  Get.to(() => DetailPage(
                      id: controller.otherItems[index]['id'].toString()));
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          //   item image
                          Expanded(
                            flex: 2,
                            child: Center(
                              child: Image.network(items['get_item_pic'],
                                  width: 200, height: 200),
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(left: 5.0, top: 18),
                              child: Column(
                                children: [
                                  Text(
                                    items['name'],
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 17),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(items['size'],
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 13,
                                          color: muted)),
                                ],
                              ),
                            ),
                          ),
                          Expanded(
                            child: Row(
                              children: [
                                Text("₵ ${items['new_price']}",
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 17,
                                        color: primaryYellow)),
                                const SizedBox(width: 90),
                                GetBuilder<CartController>(
                                    builder: (cartController) {
                                  return InkWell(
                                    onTap: () {
                                      cartController.addToCart(
                                          token,
                                          storeItemsController.otherItems[index]
                                                  ['id']
                                              .toString(),
                                          "1",
                                          storeItemsController.otherItems[index]
                                                  ['new_price']
                                              .toString());
                                    },
                                    child: ClipRRect(
                                        borderRadius: BorderRadius.circular(5),
                                        child: Container(
                                            decoration: const BoxDecoration(
                                                color: newButton),
                                            child: const Padding(
                                              padding: EdgeInsets.all(5.0),
                                              child: Icon(FontAwesomeIcons.add,
                                                  color: defaultTextColor1),
                                            ))),
                                  );
                                })
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              );
            });
      }),
    );
  }
}

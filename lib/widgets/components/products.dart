import 'package:fbazaar/controllers/storeitemscontroller.dart';
import 'package:flutter/material.dart';
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
                child: Card(
                  // elevation: 10,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  child: Column(
                    children: [
                      Expanded(
                        child: Container(
                          height: 200,
                          width: 250,
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: NetworkImage(items['get_item_pic']))),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8.0, top: 10),
                        child: Text(items['name'],
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 18)),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Card(
                            elevation: 10,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text("₵ ${items['new_price'].toString()}",
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20)),
                            ),
                          ),
                          const SizedBox(width: 70),
                          Card(
                            elevation: 10,
                            color: newButton,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            child: GetBuilder<CartController>(
                                builder: (controller) {
                              return IconButton(
                                onPressed: () {
                                  controller.addToCart(
                                      token,
                                      storeItemsController.exclusiveItems[index]
                                              ['id']
                                          .toString(),
                                      "1",
                                      storeItemsController.exclusiveItems[index]
                                          ['new_price']);
                                },
                                icon: const Icon(Icons.add,
                                    color: defaultTextColor1, size: 30),
                              );
                            }),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              );
            });
      }),
    );
  }
}

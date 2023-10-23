import 'package:fbazaar/controllers/ordercontroller.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

import '../../statics/appcolors.dart';

class Orders extends StatefulWidget {
  const Orders({super.key});

  @override
  State<Orders> createState() => _OrdersState();
}

class _OrdersState extends State<Orders> {
  final OrderController orderController = Get.find();
  var items;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(""),
      ),
      body: GetBuilder<OrderController>(builder: (controller) {
        return ListView.builder(
            itemCount: controller.allMyOrders != null
                ? controller.allMyOrders.length
                : 0,
            itemBuilder: (context, index) {
              items = controller.allMyOrders[index];
              return Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            flex: 1,
                            child: items['get_item_pic'] == ""
                                ? Image.asset("assets/images/fbazaar.png",
                                    width: 100, height: 100)
                                : Image.network(items['get_item_pic'],
                                    width: 100, height: 100),
                          ),
                          const SizedBox(width: 15),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(items['get_item_name'],
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15)),
                                const SizedBox(height: 10),
                                Text(
                                    items['date_order_created']
                                        .toString()
                                        .split("T")
                                        .first,
                                    style: const TextStyle(
                                        color: muted,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 10)),
                                const SizedBox(height: 10),
                                Text("₵ ${items['get_item_price']}",
                                    style: const TextStyle(
                                        color: primaryYellow,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15)),
                              ],
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                              child: Card(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)),
                            color: muted[300],
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Center(
                                child: Text(items['order_status'],
                                    style: const TextStyle(
                                        color: defaultTextColor2,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15)),
                              ),
                            ),
                          ))
                        ],
                      )
                    ],
                  ),
                ),
              );
            });
      }),
    );
  }
}

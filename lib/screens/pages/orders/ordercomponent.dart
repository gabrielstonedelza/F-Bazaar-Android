import 'package:fbazaar/screens/pages/orders/pending.dart';
import 'package:fbazaar/screens/pages/orders/pickedup.dart';
import 'package:fbazaar/screens/pages/orders/processing.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

import '../../../controllers/ordercontroller.dart';
import '../../../statics/appcolors.dart';
import 'delivered.dart';

class OrderComponent extends StatefulWidget {
  const OrderComponent({super.key});

  @override
  State<OrderComponent> createState() => _OrderComponentState();
}

class _OrderComponentState extends State<OrderComponent> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetBuilder<OrderController>(builder: (controller) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {
                      Get.to(() => const PendingOrder());
                    },
                    child: Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        child: SizedBox(
                          height: 150,
                          width: 150,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.shopping_bag, size: 50),
                              const SizedBox(
                                height: 10,
                              ),
                              const Text("Pending",
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                              const SizedBox(
                                height: 10,
                              ),
                              Text("(${controller.pendingOrders.length})",
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold))
                            ],
                          ),
                        )),
                  ),
                  GestureDetector(
                    onTap: () {
                      Get.to(() => const ProcessingOrders());
                    },
                    child: Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        child: SizedBox(
                          height: 150,
                          width: 150,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.shopping_bag, size: 50),
                              const SizedBox(
                                height: 10,
                              ),
                              const Text("Processing",
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                              const SizedBox(
                                height: 10,
                              ),
                              Text("(${controller.processingOrders.length})",
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold))
                            ],
                          ),
                        )),
                  ),
                ],
              ),
            ),
            const Divider(),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {
                      Get.to(() => const PickedUpOrders());
                    },
                    child: Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        child: SizedBox(
                          height: 150,
                          width: 150,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.shopping_bag, size: 50),
                              const SizedBox(
                                height: 10,
                              ),
                              const Text("Picked Up",
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                              const SizedBox(
                                height: 10,
                              ),
                              Text("(${controller.pickedUpOrders.length})",
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold))
                            ],
                          ),
                        )),
                  ),
                  GestureDetector(
                    onTap: () {
                      Get.to(() => const DeliveredOrders());
                    },
                    child: Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        child: SizedBox(
                          height: 150,
                          width: 150,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.shopping_bag, size: 50),
                              const SizedBox(
                                height: 10,
                              ),
                              const Text("Delivered",
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                              const SizedBox(
                                height: 10,
                              ),
                              Text("(${controller.deliveredOrders.length})",
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold))
                            ],
                          ),
                        )),
                  ),
                ],
              ),
            ),
          ],
        );
      }),
    );
  }
}

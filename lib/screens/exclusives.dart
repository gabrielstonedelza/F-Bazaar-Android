import 'package:fbazaar/screens/pages/detailnew.dart';
import 'package:fbazaar/statics/appcolors.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get_storage/get_storage.dart';
import '../../controllers/cartcontroller.dart';
import '../../controllers/storeitemscontroller.dart';
import 'package:get/get.dart';

class AllExclusives extends StatefulWidget {
  const AllExclusives({super.key});

  @override
  State<AllExclusives> createState() => _AllExclusivesState();
}

class _AllExclusivesState extends State<AllExclusives> {
  var items;
  final storage = GetStorage();
  late String uToken = "";

  @override
  void initState() {
    if (storage.read("token") != null) {
      uToken = storage.read("token");
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Exclusives"),
          leading: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: const Icon(FontAwesomeIcons.arrowLeftLong,
                color: defaultTextColor2),
          ),
        ),
        body: GetBuilder<StoreItemsController>(builder: (controller) {
          return ListView.builder(
              itemCount: controller.exclusiveItems != null
                  ? controller.exclusiveItems.length
                  : 0,
              itemBuilder: (context, index) {
                items = controller.exclusiveItems[index];
                return GestureDetector(
                  onTap: () {
                    Get.to(() => DetailPage(
                        id: controller.exclusiveItems[index]['id'].toString()));
                  },
                  child: Card(
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
                                    Text(items['name'],
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15)),
                                    const SizedBox(height: 10),
                                    Text(items['size'],
                                        style: const TextStyle(
                                            color: muted,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 10)),
                                    const SizedBox(height: 10),
                                    Text("₵ ${items['new_price']}",
                                        style: const TextStyle(
                                            color: primaryYellow,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15)),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 10),
                              Card(
                                color: newButton,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)),
                                child: GetBuilder<CartController>(
                                    builder: (cController) {
                                  return IconButton(
                                    onPressed: () {
                                      cController.addToCart(
                                          uToken,
                                          controller.exclusiveItems[index]['id']
                                              .toString(),
                                          "1",
                                          controller.exclusiveItems[index]
                                                  ['new_price']
                                              .toString());
                                    },
                                    icon: const Icon(Icons.add,
                                        color: defaultTextColor1, size: 30),
                                  );
                                }),
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                );
              });
        }));
  }
}

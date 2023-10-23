import 'package:fbazaar/controllers/storeitemscontroller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';

import '../../statics/appcolors.dart';

class ItemDetailRemarks extends StatefulWidget {
  final token;
  final id;
  const ItemDetailRemarks({super.key, required this.token, required this.id});

  @override
  State<ItemDetailRemarks> createState() =>
      _ItemDetailRemarksState(token: this.token, id: this.id);
}

class _ItemDetailRemarksState extends State<ItemDetailRemarks> {
  final token;
  final id;

  _ItemDetailRemarksState({required this.token, required this.id});
  final StoreItemsController storeItemsController = Get.find();
  var items;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetBuilder<StoreItemsController>(builder: (controller) {
        return ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: controller.customersRemarks != null
                ? controller.customersRemarks.length
                : 0,
            itemBuilder: (context, index) {
              items = controller.customersRemarks[index];
              return Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      //   user image,name,and date
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Padding(
                            padding:
                                const EdgeInsets.only(right: 8.0, bottom: 8),
                            child: CircleAvatar(
                              backgroundImage:
                                  NetworkImage(items['get_profile_pic']),
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 5.0, bottom: 8.0),
                                child: Text(items['get_username'],
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold)),
                              ),
                              RatingBarIndicator(
                                rating:
                                    double.parse(items['rating'].toString()),
                                itemBuilder: (context, index) => const Icon(
                                  Icons.star,
                                  color: primaryYellow,
                                ),
                                itemCount: 5,
                                itemSize: 20.0,
                                direction: Axis.horizontal,
                              ),
                            ],
                          ),
                          const SizedBox(
                            width: 40,
                          ),
                          Text(items['date_added'].toString().split("T").first,
                              style: const TextStyle(color: muted))
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(items['remark'],
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, color: muted)),
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

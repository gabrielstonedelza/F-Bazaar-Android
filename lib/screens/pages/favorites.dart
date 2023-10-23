import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../controllers/cartcontroller.dart';
import '../../controllers/favoritescontroller.dart';
import '../../statics/appcolors.dart';

class Favorites extends StatefulWidget {
  const Favorites({super.key});

  @override
  State<Favorites> createState() => _FavoritesState();
}

class _FavoritesState extends State<Favorites> {
  bool isLoading = true;
  final storage = GetStorage();
  late String uToken = "";

  @override
  void initState() {
    if (storage.read("token") != null) {
      uToken = storage.read("token");
    }
    super.initState();
  }

  var items;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: GetBuilder<FavoritesController>(builder: (favController) {
      return CustomScrollView(
        slivers: [
          const SliverAppBar(
            backgroundColor: defaultTextColor1,
            pinned: true,
            stretch: true,
            elevation: 0,
            centerTitle: true,
            expandedHeight: 300,
            flexibleSpace: SafeArea(
              child: FlexibleSpaceBar(
                background: Image(
                  image:
                      AssetImage("assets/images/animation_lnn9a1d0_medium.gif"),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate((context, index) {
              items = favController.allMyFavorites[index];
              return Padding(
                padding:
                    const EdgeInsets.only(left: 8.0, right: 8, bottom: 8.0),
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
                        //
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            // item image
                            Image(
                              height: 80,
                              width: 80,
                              image: NetworkImage(items['get_item_pic']),
                            ),
                            // item name,increase and decrease buttons
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(items['get_item_name'],
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15)),
                                const SizedBox(height: 5),
                              ],
                            ),
                            // item price
                            Text("₵ ${items['get_item_price']}",
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 20)),
                            IconButton(
                                onPressed: () {
                                  favController.removeFromFavorites(
                                    favController.allMyFavorites[index]['id']
                                        .toString(),
                                    uToken,
                                  );
                                },
                                icon: const Icon(Icons.cancel, color: warning))
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              );
            },
                childCount: favController.allMyFavorites != null
                    ? favController.allMyFavorites.length
                    : 0),
          )
        ],
      );
    }));
  }
}

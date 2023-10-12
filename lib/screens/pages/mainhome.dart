import 'dart:async';
import 'package:badges/badges.dart' as badges;
import 'package:fbazaar/controllers/storeitemscontroller.dart';
import 'package:fbazaar/widgets/components/exclusives.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:carousel_slider/carousel_slider.dart';
import '../../controllers/cartcontroller.dart';
import '../../controllers/favoritescontroller.dart';
import '../../controllers/notificationcontroller.dart';
import '../../controllers/profilecontroller.dart';
import '../../statics/appcolors.dart';
import '../../widgets/components/horizontal_listview.dart';
import '../../widgets/components/products.dart';
import '../../widgets/components/promotions.dart';
import '../../widgets/components/searchcontainer.dart';
import 'cart.dart';

class MainHome extends StatefulWidget {
  const MainHome({super.key});

  @override
  State<MainHome> createState() => _MainHomeState();
}

class _MainHomeState extends State<MainHome> {
  var storeItems;
  final StoreItemsController storeItemController = Get.find();
  final ProfileController profileController = Get.find();
  final CartController cartController = Get.find();
  final NotificationController notificationController = Get.find();
  final FavoritesController favController = Get.find();
  final storage = GetStorage();
  late String uToken = "";

  late Timer _timer;

  @override
  void initState() {
    if (storage.read("token") != null) {
      uToken = storage.read("token");
    }
    scheduleTimers();
    super.initState();
  }

  void scheduleTimers() {
    storeItemController.getAllStoreItems(uToken);
    profileController.getMyProfile(uToken);
    cartController.getAllMyCartItems(uToken);
    favController.getAllMyFavorites(uToken);
    Timer.periodic(const Duration(hours: 3), (Timer timer) {
      storeItemController.getAllStoreItems(uToken);
      profileController.getMyProfile(uToken);
      cartController.getAllMyCartItems(uToken);
      favController.getAllMyFavorites(uToken);
      // notificationController.getAllTriggeredNotifications(uToken);
      // notificationController.getAllUnReadNotifications(uToken);
    });

    // _timer = Timer.periodic(const Duration(seconds: 5), (timer) {
    //   for (var e in notificationController.triggered) {
    //     notificationController.unTriggerNotifications(e["id"], uToken);
    //   }
    // });
  }

  @override
  Widget build(BuildContext context) {
    Widget myCarouselOne() {
      return CarouselSlider(
          items: [
            Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  image: const DecorationImage(
                      image: NetworkImage(
                          "https://images.unsplash.com/photo-1622483767028-3f66f32aef97?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MTB8fGJvdHRsZWQlMjBkcmlua3N8ZW58MHx8MHx8fDA%3D&auto=format&fit=crop&w=900&q=60"),
                      fit: BoxFit.cover)),
            ),
            Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  image: DecorationImage(
                      image: NetworkImage(
                          "https://plus.unsplash.com/premium_photo-1665203632873-0f845413fcf1?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8NXx8Ym90dGxlZCUyMHdhdGVyfGVufDB8fDB8fHww&auto=format&fit=crop&w=900&q=60"),
                      fit: BoxFit.cover)),
            ),
            Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  image: DecorationImage(
                      image: NetworkImage(
                          "https://images.unsplash.com/photo-1550505095-81378a674395?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Nnx8Ym90dGxlZCUyMHdhdGVyfGVufDB8fDB8fHww&auto=format&fit=crop&w=900&q=60"),
                      fit: BoxFit.cover)),
            ),
            Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  image: DecorationImage(
                      image: NetworkImage(
                          "https://images.unsplash.com/photo-1563903370181-48241c5c8e21?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MjB8fGJvdHRsZWQlMjB3YXRlcnxlbnwwfHwwfHx8MA%3D%3D&auto=format&fit=crop&w=900&q=60"),
                      fit: BoxFit.cover)),
            ),
            Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  image: DecorationImage(
                      image: NetworkImage(
                          "https://media.istockphoto.com/id/1303013182/photo/a-woman-with-bottle-of-water.webp?b=1&s=170667a&w=0&k=20&c=x4OUnLgHTJRNsKvubt-GoBZLPPRti3UzWOtQ5QEKSwM="),
                      fit: BoxFit.cover)),
            ),
            Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  image: DecorationImage(
                      image: NetworkImage(
                          "https://images.unsplash.com/photo-1645971498382-134a3e734e1c?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MzV8fGJvdHRsZWQlMjBkcmlua3N8ZW58MHx8MHx8fDA%3D&auto=format&fit=crop&w=900&q=60"),
                      fit: BoxFit.cover)),
            ),
            Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  image: DecorationImage(
                      image: NetworkImage(
                          "https://images.unsplash.com/photo-1563340605-4b8bfa223b32?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MzR8fGJvdHRsZWQlMjB3YXRlcnxlbnwwfHwwfHx8MA%3D%3D&auto=format&fit=crop&w=900&q=60"),
                      fit: BoxFit.cover)),
            ),
            Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  image: DecorationImage(
                      image: NetworkImage(
                          "https://images.unsplash.com/photo-1633949698015-0f8a8b261c07?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8NDJ8fGJvdHRsZWQlMjB3YXRlcnxlbnwwfHwwfHx8MA%3D%3D&auto=format&fit=crop&w=900&q=60"),
                      fit: BoxFit.cover)),
            ),
            Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  image: DecorationImage(
                      image: NetworkImage(
                          "https://images.unsplash.com/photo-1601418921726-849e6c6e9d6a?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8NTJ8fGJvdHRsZWQlMjB3YXRlcnxlbnwwfHwwfHx8MA%3D%3D&auto=format&fit=crop&w=900&q=60"),
                      fit: BoxFit.cover)),
            ),
          ],
          options: CarouselOptions(
            height: 180,
            aspectRatio: 16 / 9,
            viewportFraction: 0.8,
            initialPage: 0,
            enableInfiniteScroll: true,
            reverse: false,
            autoPlay: true,
            autoPlayInterval: const Duration(seconds: 3),
            autoPlayAnimationDuration: const Duration(milliseconds: 800),
            autoPlayCurve: Curves.fastOutSlowIn,
            enlargeCenterPage: true,
            scrollDirection: Axis.horizontal,
          ));
    }

    return Scaffold(
      // appBar: AppBar(
      //   elevation: 0,
      //   title: const Text("FBazaar"),
      //   centerTitle: true,
      //   actions: [
      //     IconButton(
      //       onPressed: () {},
      //       icon: const Icon(Icons.search_rounded),
      //     ),
      //     IconButton(
      //       onPressed: () {
      //         Get.to(() => const MyCart());
      //       },
      //       icon: Padding(
      //         padding: const EdgeInsets.all(8.0),
      //         child: badges.Badge(
      //             badgeContent:
      //                 GetBuilder<CartController>(builder: (rController) {
      //               return Text("${rController.cartItems.length}",
      //                   style: const TextStyle(color: Colors.white));
      //             }),
      //             badgeAnimation: const badges.BadgeAnimation.rotation(
      //               animationDuration: Duration(seconds: 1),
      //               colorChangeAnimationDuration: Duration(seconds: 1),
      //               loopAnimation: false,
      //               curve: Curves.fastOutSlowIn,
      //               colorChangeAnimationCurve: Curves.easeInCubic,
      //             ),
      //             child: const Icon(Icons.shopping_cart, size: 30)),
      //       ),
      //     ),
      //   ],
      // ),
      // drawer: Drawer(
      //   child: ListView(
      //     children: [
      //       GetBuilder<ProfileController>(builder: (controller) {
      //         return UserAccountsDrawerHeader(
      //           accountName: Text(controller.fullName),
      //           accountEmail: Text(controller.email),
      //           currentAccountPicture: CircleAvatar(
      //             backgroundColor: Colors.grey,
      //             backgroundImage: NetworkImage(controller.profilePicture),
      //           ),
      //           decoration: const BoxDecoration(color: primaryYellow),
      //         );
      //       }),
      //       const ListTile(title: Text("Categories")),
      //       const ListTile(title: Text("Favorites")),
      //       const ListTile(title: Text("About")),
      //     ],
      //   ),
      // ),
      body: ListView(
        children: [
          const SizedBox(height: 20),
          const SearchComponent(),
          // carousel
          myCarouselOne(),
          const SizedBox(height: 10),
          const Divider(
            color: Colors.blueGrey,
          ),

          Padding(
            padding: const EdgeInsets.only(top: 18.0, bottom: 8.0, left: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Exclusive Offer",
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                TextButton(
                  onPressed: () {},
                  child: const Text("See All",
                      style: TextStyle(color: newSecondary)),
                )
              ],
            ),
          ),
          SizedBox(
            height: 300,
            child: Exclusives(
              token: uToken,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 18.0, bottom: 8.0, left: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Promotion",
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                TextButton(
                  onPressed: () {},
                  child: const Text("See All",
                      style: TextStyle(color: newSecondary)),
                )
              ],
            ),
          ),
          SizedBox(
            height: 300,
            child: Promotions(
              token: uToken,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 18.0, bottom: 8.0, left: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Recent Products",
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                TextButton(
                  onPressed: () {},
                  child: const Text("See All",
                      style: TextStyle(color: newSecondary)),
                )
              ],
            ),
          ),
          SizedBox(
            height: 300,
            child: Products(token: uToken),
          )
        ],
      ),
    );
  }
}

import 'package:fbazaar/controllers/cartcontroller.dart';
import 'package:fbazaar/screens/pages/cart.dart';
import 'package:fbazaar/screens/pages/explore.dart';
import 'package:fbazaar/screens/pages/mainhome.dart';
import 'package:badges/badges.dart' as badges;
import 'package:fbazaar/screens/pages/orders.dart';
import 'package:fbazaar/screens/pages/profile.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';
import 'package:get/get.dart';
import '../statics/appcolors.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var _currentIndex = 0;
  static const List<Widget> _widgetOptions = <Widget>[
    MainHome(),
    Explore(),
    Orders(),
    MyCart(),
    Profile()
  ];

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
      body: _widgetOptions[_currentIndex],
      bottomNavigationBar: SalomonBottomBar(
        selectedItemColor: primaryYellow,
        unselectedItemColor: muted,
        backgroundColor: Colors.white,
        currentIndex: _currentIndex,
        onTap: (i) => setState(() => _currentIndex = i),
        items: [
          /// Home
          SalomonBottomBarItem(
            icon: const Icon(Icons.store_mall_directory),
            title: const Text("Shop"),
            activeIcon: const Icon(Icons.store_mall_directory_outlined),
            selectedColor: primaryYellow,
          ),

          // Explore
          SalomonBottomBarItem(
            icon: const Icon(Icons.manage_search),
            title: const Text("Explore"),
            activeIcon: const Icon(Icons.manage_search_outlined),
            selectedColor: primaryYellow,
          ),

          // order
          SalomonBottomBarItem(
              icon: const Icon(Icons.shopping_bag_rounded),
              title: const Text("Order"),
              selectedColor: primaryYellow,
              activeIcon: const Icon(Icons.shopping_bag_outlined)),

          /// cart
          SalomonBottomBarItem(
            icon: Padding(
              padding: const EdgeInsets.all(8.0),
              child: badges.Badge(
                  badgeContent:
                      GetBuilder<CartController>(builder: (rController) {
                    return Text("${rController.cartItems.length}",
                        style: const TextStyle(color: Colors.white));
                  }),
                  badgeAnimation: const badges.BadgeAnimation.rotation(
                    animationDuration: Duration(seconds: 1),
                    colorChangeAnimationDuration: Duration(seconds: 1),
                    loopAnimation: false,
                    curve: Curves.fastOutSlowIn,
                    colorChangeAnimationCurve: Curves.easeInCubic,
                  ),
                  child: const Icon(Icons.shopping_cart)),
            ),
            title: const Text("Cart"),
            activeIcon: const Icon(Icons.shopping_cart_outlined),
            selectedColor: primaryYellow,
          ),

          /// Profile
          SalomonBottomBarItem(
              icon: const Icon(Icons.person),
              title: const Text("Profile"),
              selectedColor: primaryYellow,
              activeIcon: const Icon(Icons.person_outline_outlined)),
        ],
      ),
    );
  }
}

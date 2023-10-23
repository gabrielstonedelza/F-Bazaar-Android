import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import '../../controllers/cartcontroller.dart';
import '../../controllers/mapcontroller.dart';
import '../../controllers/ordercontroller.dart';
import '../../controllers/profilecontroller.dart';
import '../../statics/appcolors.dart';
import 'checkout.dart';
import 'new_checkout.dart';

class MyCart extends StatefulWidget {
  const MyCart({super.key});

  @override
  State<MyCart> createState() => _MyCartState();
}

class _MyCartState extends State<MyCart> {
  late GoogleMapController mapController;
  late String pickedDropOffName = "Location Unknown";
  late double dropOffLat = 0.0;
  late double dropOffLng = 0.0;

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  final MapController _mapController = Get.find();
  final CartController cartController = Get.find();
  final ProfileController profileController = Get.find();
  bool isLoading = true;
  final storage = GetStorage();
  late String uToken = "";
  late String deliveryMethod = "";
  bool isDelivery = false;
  bool isPickup = false;
  List paymentMethods = [
    "Select payment method",
    "Cash On Delivery",
    "Mobile Money",
  ];

  var _currrentSelectedPaymentMethod = "Select payment method";

  @override
  void initState() {
    if (storage.read("token") != null) {
      uToken = storage.read("token");
    }
    super.initState();
  }

  var items;

  void showCheckOut() {
    showMaterialModalBottomSheet(
      context: context,
      builder: (context) => Card(
        elevation: 12,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(10), topLeft: Radius.circular(10))),
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: Padding(
            padding: const EdgeInsets.all(18.0),
            child: ListView(
              children: [
                RowWidget(
                  prefixTitle: 'Delivering to:',
                  profileDetailName: profileController.fullName,
                ),
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Divider(color: newSnack),
                ),
                RowWidget(
                  prefixTitle: 'Delivery Location:',
                  profileDetailName: pickedDropOffName,
                ),
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Divider(color: newSnack),
                ),
                RowWidget(
                  prefixTitle: 'Items:',
                  profileDetailName: cartController.cartItems.length.toString(),
                ),
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Divider(color: newSnack),
                ),
                const RowWidget(
                  prefixTitle: 'Delivery Fee:',
                  profileDetailName: "₵ 10.0",
                ),
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Divider(color: newSnack),
                ),
                const SizedBox(height: 10),
                const Center(
                  child: Text("Choose a delivery method",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    InkWell(
                      onTap: () {
                        setState(() {
                          isDelivery = true;
                          isPickup = false;
                          deliveryMethod = "Delivery";
                        });
                      },
                      child: Card(
                        color: isDelivery ? defaultTextColor2 : muted[100],
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        child: const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              Icon(Icons.delivery_dining_rounded,
                                  color: newButton, size: 30),
                              SizedBox(width: 30),
                              Text("Delivery",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                      color: newButton)),
                            ],
                          ),
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        setState(() {
                          isDelivery = false;
                          isPickup = true;
                          deliveryMethod = "Pick Up";
                        });
                      },
                      child: Card(
                        color: isPickup ? defaultTextColor2 : muted[100],
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        child: const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              Icon(FontAwesomeIcons.store,
                                  color: newButton, size: 30),
                              SizedBox(width: 30),
                              Text("Pick Up",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                      color: newButton))
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                SizedBox(
                    height: 200,
                    child: GoogleMap(
                        onMapCreated: _onMapCreated,
                        initialCameraPosition: CameraPosition(
                          target: LatLng(_mapController.userLatitude,
                              _mapController.userLongitude),
                          zoom: 15.0,
                        ),
                        myLocationEnabled: true,
                        myLocationButtonEnabled: true,
                        scrollGesturesEnabled: true,
                        onTap: (latLng) async {
                          List<Placemark> placemark =
                              await placemarkFromCoordinates(
                                  latLng.latitude, latLng.longitude);
                          setState(() {
                            pickedDropOffName = placemark[2].street!;
                            dropOffLat = latLng.latitude;
                            dropOffLng = latLng.longitude;
                          });
                        })),
                const SizedBox(height: 20),
                const Center(
                  child: Text("Choose a payment method",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.only(bottom: 10.0),
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey, width: 1)),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 10.0, right: 10),
                      child: DropdownButton(
                        hint: const Text("Select payment method"),
                        isExpanded: true,
                        underline: const SizedBox(),
                        items: paymentMethods.map((dropDownStringItem) {
                          return DropdownMenuItem(
                            value: dropDownStringItem,
                            child: Text(dropDownStringItem),
                          );
                        }).toList(),
                        onChanged: (newValueSelected) {
                          _onDropDownItemSelectedPaymentMethod(
                              newValueSelected);
                        },
                        value: _currrentSelectedPaymentMethod,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                GetBuilder<OrderController>(builder: (orderController) {
                  return RawMaterialButton(
                    fillColor: newButton,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    onPressed: () {
                      for (var i in cartController.cartItemsIds) {
                        // orderController.placeOrder(
                        //     uToken,
                        //     i,
                        //     quantity,
                        //     price,
                        //     category,
                        //     size,
                        //     paymentMethod,
                        //     dropOffLat,
                        //     dropOffLng);
                      }
                      // orderController.placeOrder(uToken, id, quantity, price,
                      //     category, size, paymentMethod, dropOffLat, dropOffLng);
                    },
                    child: const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        "Order",
                        style: TextStyle(
                            color: defaultTextColor1,
                            fontWeight: FontWeight.bold,
                            fontSize: 20),
                      ),
                    ),
                  );
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: GetBuilder<CartController>(builder: (cController) {
      return CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: defaultTextColor1,
            pinned: true,
            stretch: true,
            elevation: 0,
            centerTitle: true,
            expandedHeight: 200,
            flexibleSpace: SafeArea(
              child: FlexibleSpaceBar(
                background: Image(
                  image: cController.cartItems.isEmpty
                      ? const AssetImage(
                          "assets/images/animation_lnna0ptf_medium.gif")
                      : const AssetImage(
                          "assets/images/animation_lnlhh3ko_medium.gif"),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          SliverAppBar(
            expandedHeight: 140,
            automaticallyImplyLeading: false,
            backgroundColor: defaultTextColor1,
            pinned: true,
            elevation: 0,
            bottom: const PreferredSize(
                preferredSize: Size.fromHeight(-10), child: SizedBox()),
            flexibleSpace: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Expanded(
                    child: Text("Subtotal ₵ ${cController.sumTotal}",
                        style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: defaultTextColor2)),
                  ),
                  Expanded(
                    child: TextButton(
                        onPressed: () {
                          Get.defaultDialog(
                              buttonColor: newPrimary,
                              title: "Confirm Clear",
                              middleText:
                                  "Are you sure you want to clear your cart?",
                              confirm: RawMaterialButton(
                                  shape: const StadiumBorder(),
                                  fillColor: newPrimary,
                                  onPressed: () {
                                    cController.clearCart(uToken);
                                    Get.back();
                                  },
                                  child: const Text(
                                    "Yes",
                                    style: TextStyle(color: Colors.white),
                                  )),
                              cancel: RawMaterialButton(
                                  shape: const StadiumBorder(),
                                  fillColor: newPrimary,
                                  onPressed: () {
                                    Get.back();
                                  },
                                  child: const Text(
                                    "Cancel",
                                    style: TextStyle(color: Colors.white),
                                  )));
                        },
                        child: const Text("Clear Cart",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: warning,
                            ))),
                  ),
                  RawMaterialButton(
                    fillColor: newButton,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    onPressed: () {
                      Get.to(() => const NewCheckOut());
                      // showCheckOut();
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "Proceed to checkout ${cController.cartItems.length}",
                        style: const TextStyle(
                            color: defaultTextColor1,
                            fontWeight: FontWeight.bold,
                            fontSize: 20),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate((context, index) {
              items = cController.cartItems[index];
              return Padding(
                padding:
                    const EdgeInsets.only(left: 8.0, right: 8, bottom: 8.0),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    // color: muted[300]
                  ),
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
                            Expanded(
                              child: items['get_item_pic'] == ""
                                  ? const Image(
                                      height: 100,
                                      width: 100,
                                      image: AssetImage(
                                          "assets/images/fbazaar.png"),
                                    )
                                  : Image(
                                      height: 100,
                                      width: 100,
                                      image:
                                          NetworkImage(items['get_item_pic']),
                                    ),
                            ),
                            // item name,increase and decrease buttons

                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 5.0),
                                    child: Text(items['get_item_name'],
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15)),
                                  ),
                                  Text(items['get_item_size'],
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12,
                                          color: muted)),
                                  const SizedBox(height: 5),
                                  Text("₵ ${items['price']}",
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15)),
                                  Padding(
                                      padding: const EdgeInsets.only(top: 18.0),
                                      child: IconButton(
                                          onPressed: () {
                                            cController.removeFromCart(
                                                cController.cartItems[index]
                                                        ['id']
                                                    .toString(),
                                                uToken,
                                                cController.cartItems[index]
                                                        ['price']
                                                    .toString());
                                          },
                                          icon: const Icon(Icons.cancel,
                                              color: warning)))
                                ],
                              ),
                            ),
                            // item price

                            Expanded(
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  InkWell(
                                    onTap: () {
                                      setState(() {
                                        if (cController.cartItems[index]
                                                ['quantity'] ==
                                            1) {
                                          Get.snackbar("Order Error",
                                              "Your order cannot be 0",
                                              colorText: Colors.white,
                                              backgroundColor: newPrimary,
                                              duration:
                                                  const Duration(seconds: 5));
                                        } else {
                                          cController.decreaseQuantity(
                                              cController.cartItems[index]['id']
                                                  .toString(),
                                              cController.cartItems[index]
                                                      ['item']
                                                  .toString(),
                                              uToken,
                                              cController.cartItems[index]
                                                      ['get_item_price']
                                                  .toString());
                                        }
                                      });
                                    },
                                    child: ClipRRect(
                                        borderRadius: BorderRadius.circular(5),
                                        child: Container(
                                            decoration: const BoxDecoration(
                                                color: newButton),
                                            child: const Padding(
                                              padding: EdgeInsets.all(5.0),
                                              child: Icon(
                                                  FontAwesomeIcons.minus,
                                                  color: defaultTextColor1),
                                            ))),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(items['quantity'].toString(),
                                        style: const TextStyle(
                                            color: defaultTextColor2,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20)),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      cController.increaseQuantity(
                                          cController.cartItems[index]['id']
                                              .toString(),
                                          cController.cartItems[index]['item']
                                              .toString(),
                                          uToken,
                                          cController.cartItems[index]
                                                  ['get_item_price']
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
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const Divider(color: Colors.blueGrey)
                      ],
                    ),
                  ),
                ),
              );
            },
                childCount: cController.cartItems != null
                    ? cController.cartItems.length
                    : 0),
          )
        ],
      );
    }));
  }

  void _onDropDownItemSelectedPaymentMethod(newValueSelected) {
    setState(() {
      _currrentSelectedPaymentMethod = newValueSelected;
    });
  }
}

class RowWidget extends StatelessWidget {
  const RowWidget({
    super.key,
    required this.prefixTitle,
    required this.profileDetailName,
  });

  final String prefixTitle;
  final String profileDetailName;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(prefixTitle,
            style: TextStyle(
                fontWeight: FontWeight.bold, fontSize: 15, color: muted[500])),
        Text(profileDetailName,
            style: TextStyle(
                fontWeight: FontWeight.bold, fontSize: 15, color: muted[500])),
      ],
    );
  }
}

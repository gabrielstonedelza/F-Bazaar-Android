import 'package:fbazaar/widgets/loadingui.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'dart:math';
import '../../controllers/cartcontroller.dart';
import '../../controllers/mapcontroller.dart';
import '../../controllers/ordercontroller.dart';
import '../../controllers/profilecontroller.dart';
import '../../statics/appcolors.dart';
import 'checkout.dart';

class NewCheckOut extends StatefulWidget {
  const NewCheckOut({super.key});

  @override
  State<NewCheckOut> createState() => _NewCheckOutState();
}

class _NewCheckOutState extends State<NewCheckOut> {
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
  int uniqueCode = 0;
  late String itemUniqueCode = "";

  var _currentSelectedPaymentMethod = "Select payment method";
  String getRandomString(int length) {
    const chars = 'abcdefghijklmnopqrstuvwxyz';
    final rand = Random();

    return String.fromCharCodes(
      List.generate(
          length, (index) => chars.codeUnitAt(rand.nextInt(chars.length))),
    );
  }

  generateUnique() {
    var rng = Random();
    var rand = rng.nextInt(9000) + 9000;
    uniqueCode = rand.toInt();
    setState(() {
      itemUniqueCode = uniqueCode.toString() + getRandomString(10);
    });
  }

  bool isPosting = false;
  void _startPosting() async {
    setState(() {
      isPosting = true;
    });
    await Future.delayed(const Duration(seconds: 5));
    setState(() {
      isPosting = false;
    });
  }

  @override
  void initState() {
    if (storage.read("token") != null) {
      uToken = storage.read("token");
    }
    generateUnique();
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
                        value: _currentSelectedPaymentMethod,
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
    return Scaffold(
        appBar: AppBar(
          title: const Text("Checkout"),
          leading: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: const Icon(FontAwesomeIcons.arrowLeftLong,
                color: defaultTextColor2),
          ),
        ),
        body: GetBuilder<CartController>(builder: (cController) {
          return ListView.builder(
              itemCount: 1,
              itemBuilder: (context, index) {
                items = cController.cartItems[index];
                return Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
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
                        profileDetailName:
                            cartController.cartItems.length.toString(),
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
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 20)),
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
                              color:
                                  isDelivery ? defaultTextColor2 : muted[100],
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              child: Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Row(
                                  children: [
                                    const Icon(Icons.delivery_dining_rounded,
                                        color: newButton, size: 30),
                                    const SizedBox(width: 30),
                                    Text("Delivery",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20,
                                            color: isDelivery
                                                ? defaultTextColor1
                                                : newButton)),
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
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  children: [
                                    const Icon(FontAwesomeIcons.store,
                                        color: newButton, size: 30),
                                    const SizedBox(width: 30),
                                    Text("Pick Up",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20,
                                            color: isPickup
                                                ? defaultTextColor1
                                                : newButton))
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                          height: 300,
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
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 20)),
                      ),
                      const SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10.0),
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.grey, width: 1)),
                          child: Padding(
                            padding:
                                const EdgeInsets.only(left: 10.0, right: 10),
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
                              value: _currentSelectedPaymentMethod,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      isPosting
                          ? const LoadingUi()
                          : GetBuilder<OrderController>(
                              builder: (orderController) {
                              return RawMaterialButton(
                                fillColor: newButton,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12)),
                                onPressed: () {
                                  _startPosting();
                                  Get.snackbar("Hurray 😀",
                                      "your order is being sent for processing,please wait.",
                                      colorText: defaultTextColor1,
                                      snackPosition: SnackPosition.TOP,
                                      backgroundColor: newDefault,
                                      duration: const Duration(seconds: 5));
                                  if (deliveryMethod == "") {
                                    Get.snackbar(
                                      "Delivery Error",
                                      "Please select a delivery method",
                                      duration: const Duration(seconds: 5),
                                      colorText: defaultTextColor1,
                                      backgroundColor: warning,
                                    );
                                    return;
                                  } else if (_currentSelectedPaymentMethod ==
                                      "Select payment method") {
                                    Get.snackbar(
                                      "Payment Error",
                                      "Please select a payment method",
                                      duration: const Duration(seconds: 5),
                                      colorText: defaultTextColor1,
                                      backgroundColor: warning,
                                    );
                                    return;
                                  } else if (pickedDropOffName ==
                                      "Location Unknown") {
                                    Get.snackbar(
                                      "Location Error",
                                      "Please select your location",
                                      duration: const Duration(seconds: 5),
                                      colorText: defaultTextColor1,
                                      backgroundColor: warning,
                                    );
                                    return;
                                  } else {
                                    for (var c in cartController.cartItems) {
                                      setState(() {
                                        isPosting = true;
                                      });

                                      orderController.placeOrder(
                                          uToken,
                                          c['id'].toString(),
                                          c['quantity'].toString(),
                                          c['get_item_price'].toString(),
                                          c['get_item_category'],
                                          c['get_item_size'].toString(),
                                          _currentSelectedPaymentMethod,
                                          dropOffLat.toString(),
                                          dropOffLng.toString(),
                                          deliveryMethod,
                                          itemUniqueCode);
                                      // orderController.placeOrder(
                                      //     uToken,
                                      //     c['id'].toString(),
                                      //     c['quantity'].toString(),
                                      //     c['get_item_price'].toString(),
                                      //     c['get_item_category'],
                                      //     c['get_item_size'].toString(),
                                      //     _currentSelectedPaymentMethod,
                                      //     dropOffLat.toString(),
                                      //     dropOffLng.toString(),
                                      //     deliveryMethod,
                                      //     itemUniqueCode);
                                    }
                                  }
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
                );
              });
        }));
  }

  void _onDropDownItemSelectedPaymentMethod(newValueSelected) {
    setState(() {
      _currentSelectedPaymentMethod = newValueSelected;
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

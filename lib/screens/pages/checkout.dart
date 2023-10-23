import 'package:animate_do/animate_do.dart';
import 'package:fbazaar/controllers/ordercontroller.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get_storage/get_storage.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../controllers/cartcontroller.dart';
import '../../controllers/profilecontroller.dart';
import '../../statics/appcolors.dart';
import '../../controllers/mapcontroller.dart';

class CheckOut extends StatefulWidget {
  const CheckOut({super.key});

  @override
  State<CheckOut> createState() => _CheckOutState();
}

class _CheckOutState extends State<CheckOut> {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: const Icon(FontAwesomeIcons.arrowLeftLong,
              color: defaultTextColor2),
        ),
        title: const Text(
          "Check Out",
        ),
      ),
      body: SlideInUp(
        animate: true,
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: ListView(
            children: [
              cartController.sumTotal > 100
                  ? const Padding(
                      padding: EdgeInsets.only(top: 18.0, bottom: 18),
                      child: Text("Order qualifies for Free Delivery.",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: newSecondary,
                          )),
                    )
                  : Container(),
              const SizedBox(height: 20),
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
                        _onDropDownItemSelectedPaymentMethod(newValueSelected);
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
    );
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

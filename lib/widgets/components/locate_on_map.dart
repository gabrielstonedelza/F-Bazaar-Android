import "package:flutter/material.dart";
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import "package:get/get.dart";
import '../../controllers/mapcontroller.dart';

class LocateOnMap extends StatefulWidget {
  String dropOff;
  LocateOnMap({Key? key, required this.dropOff}) : super(key: key);

  @override
  State<LocateOnMap> createState() => _LocateOnMapState(dropOff: this.dropOff);
}

class _LocateOnMapState extends State<LocateOnMap> {
  String dropOff;
  _LocateOnMapState({required this.dropOff});
  late GoogleMapController mapController;
  late String pickedDropOffName = "Location Unknown";
  late double dropOffLat = 0.0;
  late double dropOffLng = 0.0;

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  final MapController _mapController = Get.find();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
//       appBar: AppBar(
//         title: const Text("Tap on map to pick location",
//             style: TextStyle(
//                 fontWeight: FontWeight.bold,
//                 fontSize: 15,
//                 color: Colors.black)),
//         backgroundColor: Colors.transparent,
//         elevation: 0,
//         leading: IconButton(
//             onPressed: () {
//               Get.back();
//             },
//             icon: const Icon(Icons.arrow_back, color: defaultTextColor2)),
//         actions: [
//           pickedDropOffName != "nothing"
//               ? TextButton(
//                   onPressed: () {
//                     _mapController.setDropOffLocation(pickedDropOffName);
//                     _mapController.setDropOffLat(dropOffLat);
//                     _mapController.setDropOffLng(dropOffLng);
//
// // _mapController.dropOffLocation.text = pickedDropOffName;
//                     Get.back();
//                   },
//                   child: const Text("Okay",
//                       style: TextStyle(fontWeight: FontWeight.bold)))
//               : Container()
//         ],
//       ),
      body: GoogleMap(
          onMapCreated: _onMapCreated,
          initialCameraPosition: CameraPosition(
            target: LatLng(
                _mapController.userLatitude, _mapController.userLongitude),
            zoom: 15.0,
          ),
          myLocationEnabled: true,
          myLocationButtonEnabled: true,
          onTap: (latLng) async {
            List<Placemark> placemark = await placemarkFromCoordinates(
                latLng.latitude, latLng.longitude);
            setState(() {
              pickedDropOffName = placemark[2].street!;
              dropOffLat = latLng.latitude;
              dropOffLng = latLng.longitude;
            });
          }),
    ));
  }
}

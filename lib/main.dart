import 'package:fbazaar/screens/splashscreen.dart';
import 'package:fbazaar/statics/appcolors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'controllers/cartcontroller.dart';
import 'controllers/favoritescontroller.dart';
import 'controllers/logincontroller.dart';
import 'controllers/notificationcontroller.dart';
import 'controllers/profilecontroller.dart';
import 'controllers/registercontroller.dart';
import 'controllers/storeitemscontroller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  await GetStorage.init();
  Get.put(LoginController());
  Get.put(RegistrationController());
  Get.put(StoreItemsController());
  Get.put(CartController());
  Get.put(ProfileController());
  Get.put(FavoritesController());
  Get.put(NotificationController());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      defaultTransition: Transition.leftToRightWithFade,
      theme: ThemeData(
          primaryColor: primaryYellow,
          appBarTheme: const AppBarTheme(
            elevation: 0,
            backgroundColor: defaultTextColor2,
          )),
      home: const SplashScreen(),
    );
  }
}

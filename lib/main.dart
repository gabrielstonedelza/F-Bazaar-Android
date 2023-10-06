import 'package:fbazaar/screens/splashscreen.dart';
import 'package:fbazaar/statics/appcolors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'controllers/logincontroller.dart';
import 'controllers/registercontroller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  await GetStorage.init();
  Get.put(LoginController());
  Get.put(RegistrationController());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      defaultTransition: Transition.downToUp,
      theme: ThemeData(
          primaryColor: primaryYellow,
          appBarTheme: const AppBarTheme(
            elevation: 0,
            backgroundColor: defaultYellow,
          )),
      home: const SplashScreen(),
    );
  }
}

import 'package:fbazaar/controllers/logincontroller.dart';
import 'package:fbazaar/controllers/profilecontroller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get_storage/get_storage.dart';
import '../../statics/appcolors.dart';
import 'editprofile.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final storage = GetStorage();
  late String uToken = "";

  @override
  void initState() {
    // TODO: implement initState
    if (storage.read("token") != null) {
      uToken = storage.read("token");
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // appBar: AppBar(title: const Text("Profile")),
        body: GetBuilder<ProfileController>(builder: (controller) {
      return Padding(
        padding: const EdgeInsets.all(18.0),
        child: ListView(
          children: [
            const SizedBox(height: 20),
            // profile pic,name and email
            Center(
                child: CircleAvatar(
              backgroundImage: NetworkImage(controller.profilePicture),
              radius: 50,
            )),
            IconButton(
                onPressed: () {
                  Get.to(() => const EditProfile());
                },
                icon: const Icon(FontAwesomeIcons.edit)),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Divider(color: newSnack),
            ),
            ListTile(
                leading: const Icon(FontAwesomeIcons.person),
                title: Text(controller.fullName)),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Divider(color: newSnack),
            ),
            ListTile(
                leading: const Icon(FontAwesomeIcons.phone),
                title: Text(controller.phoneNumber)),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Divider(color: newSnack),
            ),
            ListTile(
                leading: const Icon(FontAwesomeIcons.envelope),
                title: Text(controller.email)),

            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Divider(color: newSnack),
            ),
            const ListTile(
                leading: Icon(FontAwesomeIcons.info), title: Text("About")),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Divider(color: newSnack),
            ),
            GetBuilder<LoginController>(builder: (loginController) {
              return RawMaterialButton(
                fillColor: newButton,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                onPressed: () {
                  loginController.logoutUser(uToken);
                },
                child: const Text(
                  "Log Out",
                  style: TextStyle(
                      color: defaultTextColor1,
                      fontWeight: FontWeight.bold,
                      fontSize: 20),
                ),
              );
            })
          ],
        ),
      );
    }));
  }
}

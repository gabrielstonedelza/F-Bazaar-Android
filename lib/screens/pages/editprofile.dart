import 'package:fbazaar/controllers/profilecontroller.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../controllers/registercontroller.dart';
import '../../statics/appcolors.dart';
import '../../widgets/loadingui.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final ProfileController profileController = Get.find();
  final RegistrationController registrationController = Get.find();
  late final TextEditingController _usernameController;
  late final TextEditingController _phoneController;
  late final TextEditingController _emailController;
  final _formKey = GlobalKey<FormState>();
  final FocusNode _usernameFocusNode = FocusNode();
  final FocusNode _phoneFocusNode = FocusNode();
  final FocusNode _emailFocusNode = FocusNode();

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

  final storage = GetStorage();
  late String uToken = "";

  @override
  void initState() {
    // TODO: implement initState
    if (storage.read("token") != null) {
      uToken = storage.read("token");
    }
    _usernameController =
        TextEditingController(text: profileController.username);
    _phoneController =
        TextEditingController(text: profileController.phoneNumber);
    _emailController = TextEditingController(text: profileController.email);
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _usernameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    super.dispose();
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
            title: const Text("Edit Profile")),
        body: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.all(18.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(
                      height: 40,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 18.0),
                      child: TextFormField(
                        controller: _usernameController,
                        focusNode: _usernameFocusNode,
                        decoration: InputDecoration(
                            labelText: "Username",
                            labelStyle:
                                const TextStyle(color: defaultTextColor2),
                            focusColor: defaultTextColor2,
                            fillColor: defaultTextColor2,
                            focusedBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                    color: defaultTextColor2, width: 2),
                                borderRadius: BorderRadius.circular(12)),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12))),
                        cursorColor: defaultTextColor2,
                        style: const TextStyle(color: defaultTextColor2),
                        keyboardType: TextInputType.text,
                        textInputAction: TextInputAction.next,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Enter username";
                          } else {
                            return null;
                          }
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 18.0),
                      child: TextFormField(
                        controller: _emailController,
                        focusNode: _emailFocusNode,
                        decoration: InputDecoration(
                            labelText: "Email",
                            labelStyle:
                                const TextStyle(color: defaultTextColor2),
                            focusColor: defaultTextColor2,
                            fillColor: defaultTextColor2,
                            focusedBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                    color: defaultTextColor2, width: 2),
                                borderRadius: BorderRadius.circular(12)),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12))),
                        cursorColor: defaultTextColor2,
                        style: const TextStyle(color: defaultTextColor2),
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.next,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Enter email";
                          } else {
                            return null;
                          }
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 12.0),
                      child: TextFormField(
                        controller: _phoneController,
                        focusNode: _phoneFocusNode,
                        decoration: InputDecoration(
                            labelText: "Phone",
                            labelStyle:
                                const TextStyle(color: defaultTextColor2),
                            focusColor: defaultTextColor2,
                            fillColor: defaultTextColor2,
                            focusedBorder: OutlineInputBorder(
                                borderSide: const BorderSide(
                                    color: defaultTextColor2, width: 2),
                                borderRadius: BorderRadius.circular(12)),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12))),
                        cursorColor: defaultTextColor2,
                        style: const TextStyle(color: defaultTextColor2),
                        keyboardType: TextInputType.number,
                        textInputAction: TextInputAction.next,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Enter phone";
                          } else {
                            return null;
                          }
                        },
                      ),
                    ),
                    isPosting
                        ? const LoadingUi()
                        : RawMaterialButton(
                            onPressed: () {
                              _startPosting();
                              FocusScopeNode currentFocus =
                                  FocusScope.of(context);

                              if (!currentFocus.hasPrimaryFocus) {
                                currentFocus.unfocus();
                              }
                              if (!_formKey.currentState!.validate()) {
                                return;
                              } else {
                                registrationController.updateUser(
                                    _usernameController.text,
                                    _emailController.text,
                                    _phoneController.text,
                                    profileController.userId,
                                    uToken);
                              }
                            },
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8)),
                            elevation: 8,
                            fillColor: newButton,
                            splashColor: primaryYellow,
                            child: const Text(
                              "Update",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                  color: defaultTextColor1),
                            ),
                          ),
                    const SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ));
  }
}

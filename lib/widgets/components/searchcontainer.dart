import 'package:flutter/material.dart';

import '../../screens/pages/explore.dart';
import '../../statics/appcolors.dart';
import 'package:get/get.dart';

class SearchComponent extends StatelessWidget {
  const SearchComponent({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(18.0),
      child: TextFormField(
        cursorColor: defaultTextColor2,
        readOnly: true,
        onTap: () {
          Get.to(() => const Explore());
        },
        decoration: InputDecoration(
            labelText: "Search Store",
            prefixIcon: const Icon(Icons.search, color: defaultTextColor2),
            labelStyle: const TextStyle(color: defaultTextColor2),
            focusColor: defaultTextColor2,
            fillColor: defaultTextColor2,
            focusedBorder: OutlineInputBorder(
                borderSide:
                    const BorderSide(color: defaultTextColor2, width: 2),
                borderRadius: BorderRadius.circular(12)),
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(12))),
        // cursorColor: Colors.black,
        // style: const TextStyle(color: Colors.black),
        keyboardType: TextInputType.text,
      ),
    );
  }
}

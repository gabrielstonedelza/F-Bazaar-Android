import 'package:fbazaar/statics/appcolors.dart';
import 'package:flutter/material.dart';

class HorizontalListView extends StatelessWidget {
  HorizontalListView({super.key});
  List categories = [
    "Water",
    "Drinks",
    "Furniture",
    "Electronics",
    "Fashion",
    "Groceries",
    "Pharmacy",
  ];
  var categoryItems;

  @override
  Widget build(BuildContext context) {
    return ListView(
      scrollDirection: Axis.horizontal,
      children: const [
        Category(name: "Water"),
        Category(name: "Drinks"),
        Category(name: "Furniture"),
        Category(name: "Electronics"),
        Category(name: "Fashion"),
        Category(name: "Groceries"),
        Category(name: "Pharmacy"),
      ],
    );
  }
}

class Category extends StatelessWidget {
  const Category({super.key, required this.name});
  final String name;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      child: Card(
        color: muted,
        elevation: 10,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Padding(
          padding:
              const EdgeInsets.only(top: 12.0, left: 8, right: 8, bottom: 2),
          child: Text(name,
              style: const TextStyle(
                  fontWeight: FontWeight.bold, color: defaultTextColor1)),
        ),
      ),
    );
  }
}

import 'dart:convert';
import 'package:animate_do/animate_do.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:fbazaar/screens/categories/drinks.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:get/get.dart';
import '../../statics/appcolors.dart';
import '../categories/water.dart';
import 'detailnew.dart';

class Explore extends StatefulWidget {
  const Explore({super.key});

  @override
  State<Explore> createState() => _ExploreState();
}

class _ExploreState extends State<Explore> {
  late final TextEditingController _searchItem;
  final storage = GetStorage();
  late String uToken = "";
  final _formKey = GlobalKey<FormState>();
  FocusNode searchFocusNode = FocusNode();
  late List searchedItems = [];

  bool isSearching = false;
  bool hasData = false;
  var items;

  Future<void> searchStore(String searchItem) async {
    final url = "https://f-bazaar.com/store_api/search_item?search=$searchItem";
    var myLink = Uri.parse(url);
    final response = await http.get(myLink, headers: {
      "Content-Type": "application/x-www-form-urlencoded",
      "Authorization": "Token $uToken"
    });

    if (response.statusCode == 200) {
      final codeUnits = response.body.codeUnits;
      var jsonData = const Utf8Decoder().convert(codeUnits);
      searchedItems = json.decode(jsonData);
      setState(() {
        isSearching = false;
        hasData = true;
      });
    } else {
      if (kDebugMode) {
        print(response.body);
        setState(() {
          hasData = false;
        });
      }
    }
  }

  @override
  void initState() {
    if (storage.read("token") != null) {
      uToken = storage.read("token");
    }
    _searchItem = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _searchItem.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: const Text("Explore Shop"),
      //   elevation: 0,
      // ),
      body: ListView(
        children: [
          // search input box
          Padding(
            padding: const EdgeInsets.all(18.0),
            child: TextFormField(
              onTap: () {
                setState(() {
                  isSearching = true;
                });
              },
              onTapOutside: ((event) {
                FocusScope.of(context).unfocus();
                setState(() {
                  isSearching = false;
                  hasData = false;
                  searchedItems.clear();
                });
              }),
              onChanged: (value) {
                if (value == "") {
                  setState(() {
                    isSearching = false;
                    hasData = false;
                    searchedItems.clear();
                  });
                  FocusScope.of(context).unfocus();
                } else {
                  searchStore(value);
                }
              },
              focusNode: searchFocusNode,
              controller: _searchItem,
              cursorColor: defaultTextColor2,
              decoration: InputDecoration(
                  labelText: "Search Store",
                  prefixIcon:
                      const Icon(Icons.search, color: defaultTextColor2),
                  labelStyle: const TextStyle(color: defaultTextColor2),
                  focusColor: defaultTextColor2,
                  fillColor: defaultTextColor2,
                  focusedBorder: OutlineInputBorder(
                      borderSide:
                          const BorderSide(color: defaultTextColor2, width: 2),
                      borderRadius: BorderRadius.circular(12)),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12))),
              // cursorColor: Colors.black,
              // style: const TextStyle(color: Colors.black),
              keyboardType: TextInputType.text,
            ),
          ),
          //   product categories container

          !isSearching
              ? !hasData
                  ? SlideInUp(
                      animate: true,
                      child: Padding(
                        padding: const EdgeInsets.all(18.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: InkWell(
                                splashColor: muted[300],
                                onTap: () {
                                  Get.to(() => const AllDrinks());
                                },
                                child: Card(
                                  elevation: 10,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                  child: Padding(
                                    padding: const EdgeInsets.all(18.0),
                                    child: Column(
                                      children: [
                                        Image.asset(
                                          "assets/images/drinks_pack.jpeg",
                                          width: 150,
                                          height: 150,
                                        ),
                                        const Padding(
                                          padding: EdgeInsets.only(top: 18.0),
                                          child: Center(
                                            child: Text("Drinks",
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 20,
                                                )),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: InkWell(
                                splashColor: muted[300],
                                onTap: () {
                                  Get.to(() => const AllWater());
                                },
                                child: Card(
                                  elevation: 10,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                  child: Padding(
                                    padding: const EdgeInsets.all(18.0),
                                    child: Column(
                                      children: [
                                        Image.asset(
                                          "assets/images/water.jpeg",
                                          width: 150,
                                          height: 150,
                                        ),
                                        const Padding(
                                          padding: EdgeInsets.only(top: 18.0),
                                          child: Center(
                                            child: Text("Water",
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 20,
                                                )),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  : Container()
              : Container(),
          Padding(
            padding: const EdgeInsets.only(left: 18.0, right: 18),
            child: SizedBox(
              height: 400,
              child: ListView.builder(
                  itemCount: searchedItems != null ? searchedItems.length : 0,
                  itemBuilder: (context, index) {
                    items = searchedItems[index];
                    return Card(
                      child: ListTile(
                        onTap: () {
                          Get.to(() => DetailPage(
                              id: searchedItems[index]['id'].toString()));
                        },
                        title: Text(items['name'],
                            style:
                                const TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text("₵ ${items['new_price']}"),
                        ),
                      ),
                    );
                  }),
            ),
          )
        ],
      ),
    );
  }
}

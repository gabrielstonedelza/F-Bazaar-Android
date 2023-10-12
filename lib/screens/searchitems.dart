import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:flutter/foundation.dart';

class SearchItems extends StatefulWidget {
  const SearchItems({super.key});

  @override
  State<SearchItems> createState() => _SearchItemsState();
}

class _SearchItemsState extends State<SearchItems> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _searchFilter;
  FocusNode searchFocusNode = FocusNode();
  late List searchedItems = [];
  late List allItems = [];
  bool isSearching = false;
  bool hasData = false;
  var items;

  Future<void> fetchItems(String searchItem) async {
    final url = "https://f-bazaar.com/store_api/search_item?search=$searchItem";
    var myLink = Uri.parse(url);
    final response = await http.get(myLink);

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
    // TODO: implement initState
    super.initState();
    _searchFilter = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    _searchFilter.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

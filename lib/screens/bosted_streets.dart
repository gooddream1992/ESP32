import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../utils/app_const.dart';
import '../utils/color_utils.dart';
import '../utils/textStyles.dart';
import 'add_boost_location_map.dart';

class BostedStreets extends StatefulWidget {
  const BostedStreets({Key? key}) : super(key: key);

  @override
  State<BostedStreets> createState() => _BostedStreetsState();
}

class _BostedStreetsState extends State<BostedStreets> {
  ColorUtils colorUtils = ColorUtils();
  FontUtils fontUtils = FontUtils();
  List dataList = [];
  List searchList = [];
  bool isSearch = false;
  TextEditingController _searchController = TextEditingController();

// something like 2013-04-20
  getBoostData() async {
    await FirebaseFirestore.instance.collection("Boost").get().then((value) {
      value.docs.forEach((element) {
        setState(() {
          dataList.add(element.data());
        });
      });
    });
  }

  @override
  void initState() {
    super.initState();
    getBoostData();
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
          title: Text(
            "Boosted Streets",
            style: fontUtils.robotoRegular.copyWith(
                fontSize: height * 0.020, color: colorUtils.whiteColor),
          ),
          backgroundColor: colorUtils.appBarBgColor,
          centerTitle: true,
          actions: [
            GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AddBoostLocationMap(),
                    ));
              },
              child: Container(
                child: Icon(Icons.location_on),
              ),
            ),
          ]),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.only(left: width * 0.02, right: width * 0.02),
              child: TextFormField(
                controller: _searchController,
                style: TextStyle(fontSize: height * 0.022),
                decoration: InputDecoration(
                  hintText: "Search Your Street",
                ),
                onChanged: (val) {
                  dataList.forEach((element) {
                    setState(() {
                      if (_searchController.text.length != 0) {
                        isSearch = true;
                        if (element["street"]
                                .toString()
                                .contains(_searchController.text) &&
                            !searchList.contains(element)) {
                          searchList.add(element);
                        }
                      } else {
                        searchList.clear();
                      }
                    });
                  });
                },
              ),
            ),
            Container(
                height: height * 0.8,
                width: width,
                padding: EdgeInsets.only(
                  right: width * 0.03,
                  left: width * 0.03,
                  // top: height * 0.02,
                  /*bottom: height * 0.02*/
                ),
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage("assets/images/jpg/bg.jpg"),
                        fit: BoxFit.fill)),
                child: ListView.builder(
                  physics: BouncingScrollPhysics(),
                  itemCount: isSearch ? searchList.length : dataList.length,
                  itemBuilder: (context, index) {
                    return customText(
                      state: isSearch
                          ? searchList[index]["street"]
                          : dataList[index]["street"],
                      city: isSearch
                          ? searchList[index]["city"]
                          : dataList[index]["city"],
                      country: isSearch
                          ? searchList[index]["country"]
                          : dataList[index]["country"],
                    );
                  },
                )),
          ],
        ),
      ),
    );
  }

  Widget customText({
    String? city,
    String? country,
    String? state,
  }) {
    return Container(
      padding: EdgeInsets.only(left: 4, top: 12, bottom: 12),
      alignment: Alignment.centerLeft,
      decoration: BoxDecoration(
          color: Colors.white38,
          borderRadius: BorderRadius.circular(width * 0.015)),
      // height: height * 0.05,
      margin: EdgeInsets.only(top: height * 0.01),
      child: Row(
        children: [
          Text(state! + ",",
              overflow: TextOverflow.clip,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: height * 0.018,
                  color: Colors.black)),
          Text(city! + ",",
              overflow: TextOverflow.clip,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: height * 0.018,
                  color: Colors.black)),
          Text(country!,
              overflow: TextOverflow.clip,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: height * 0.018,
                  color: Colors.black)),
        ],
      ),
    );
  }
}

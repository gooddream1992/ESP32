import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:esp_32/utils/app_const.dart';
import 'package:flutter/material.dart';

import '../utils/color_utils.dart';
import '../utils/textStyles.dart';

class allUserList extends StatefulWidget {
  const allUserList({Key? key}) : super(key: key);

  @override
  State<allUserList> createState() => _allUserListState();
}

class _allUserListState extends State<allUserList> {
  List users = [];
  ColorUtils colorUtils = ColorUtils();
  FontUtils fontUtils = FontUtils();
  @override
  void initState() {
    getAllUsers();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: colorUtils.appBarBgColor,
        title: Text("All Users list"),
      ),
      body: Container(
        child: ListView.builder(
          padding: EdgeInsets.only(top: height * 0.02),
          itemCount: users.length,
          itemBuilder: (context, index) => Container(
            margin: EdgeInsets.only(top: height * 0.01,left: width*0.05,right: width*0.05),
            padding: EdgeInsets.only(left: width * 0.02, right: width * 0.02),
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(width*0.012),color: Colors.black12,),
            height: height * 0.04,
            width: width,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(users[index]["name"]),
                Text(users[index]["isActive"].toString()),
              ],
            ),
          ),
        ),
      ),
    );
  }

  getAllUsers() async {
    await FirebaseFirestore.instance.collection("Users").get().then((value) {
      value.docs.forEach((element) {
        setState(() {
          users.add(element.data());
        });
        //latLongList = element.data().toString();
        log(element.data().toString());
      });
    });
  }
}

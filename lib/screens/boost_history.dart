import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../utils/app_const.dart';
import '../utils/color_utils.dart';
import '../utils/textStyles.dart';
import 'package:intl/intl.dart';

class BoostHistoryScreen extends StatefulWidget {
  const BoostHistoryScreen({Key? key}) : super(key: key);

  @override
  State<BoostHistoryScreen> createState() => _BoostHistoryScreenState();
}

class _BoostHistoryScreenState extends State<BoostHistoryScreen> {
  ColorUtils colorUtils = ColorUtils();
  FontUtils fontUtils = FontUtils();
  List dataList = [];
  final DateTime now = DateTime.now();
  final DateFormat formatter = DateFormat('yyyy-MM-dd');

  getBoostData() async {
    await FirebaseFirestore.instance
        .collection("Boost")
        .where("userId", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((value) {
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
            "Boost History",
            style: fontUtils.robotoRegular.copyWith(
                fontSize: height * 0.020, color: colorUtils.whiteColor),
          ),
          backgroundColor: colorUtils.appBarBgColor,
          centerTitle: true,
         ),
      body: Container(
          height: height,
          width: width,
          padding: EdgeInsets.only(
              right: width * 0.03,
              left: width * 0.03,
              top: height * 0.02,
              bottom: height * 0.02),
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("assets/images/jpg/bg.jpg"),
                  fit: BoxFit.fill)),
          child: ListView.builder(
            physics: BouncingScrollPhysics(),
            itemCount: dataList.length,
            itemBuilder: (context, index) {
              return customText(
                title: dataList[index]["street"],
                value: dataList[index]["totalAmount"],
                date: formatter.format(dataList[index]["date"].toDate()),
              );
            },
          )),
    );
  }

  Widget customText({
    required String title,
    required String value,
    required String date,
  }) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white38,
          borderRadius: BorderRadius.circular(width * 0.015)),
      height: height * 0.05,
      margin: EdgeInsets.only(top: height * 0.04),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Text(title,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: height * 0.018,
                  color: Colors.black)),
          Text(value,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: height * 0.018,
                  color: Colors.black)),
          Text(date,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: height * 0.018,
                  color: Colors.black)),
        ],
      ),
    );
  }
}

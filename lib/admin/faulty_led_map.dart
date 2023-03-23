import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../utils/app_const.dart';

class FaultyLedMap extends StatefulWidget {
  const FaultyLedMap({Key? key}) : super(key: key);

  @override
  State<FaultyLedMap> createState() => _FaultyLedMapState();
}

class _FaultyLedMapState extends State<FaultyLedMap> {
  List latLongList = [];

  @override
  void initState() {
    getLatLng();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text("All Malfunctions Led report"),
      ),
      body: Container(
        child: Column(
          children: [

            Container(
              padding: EdgeInsets.all(10),
              margin: EdgeInsets.only(left: width*0.05,),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Id", style: TextStyle(fontWeight: FontWeight.bold,fontSize: width * 0.04),),
                  Text("Fault reason",style: TextStyle(fontWeight: FontWeight.bold,fontSize: width * 0.04)),
                  Text("date of fault",style: TextStyle(fontWeight: FontWeight.bold,fontSize: width * 0.04)),
                ],
              ),
            ),

            ListView.builder(
              shrinkWrap: true,
              padding: EdgeInsets.only(top: height * 0.006),
              itemCount: latLongList.length,
              itemBuilder: (context, index) => Container(

                margin: EdgeInsets.only(top: height * 0.009,right: width*0.04,left: width*0.04),
                padding: EdgeInsets.only(left: width * 0.02, right: width * 0.02,top: height*0.01,bottom: height*0.01),
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(width*0.01),color: Colors.black12,),
                // height: height,
                width: width,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(margin: EdgeInsets.only(right: width*0.03,left: width*0.03),child: Text(latLongList[index]["id"])),
                    Container(
                        child: Flexible(
                      child: Column(
                        children: [
                          Text(latLongList[index]["faultReason"]),
                        ],
                      ),
                    )),
                    Container(margin: EdgeInsets.only(right: width*0.01,left: width*0.03),child: Text(latLongList[index]["date"])),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  getLatLng() async {
    await FirebaseFirestore.instance.collection("LEDs").get().then((value) {
      value.docs.forEach((element) {
        setState(() {
          latLongList.add(element.data());
        });
        //latLongList = element.data().toString();
        log(element.data().toString());
      });

    });
  }
}

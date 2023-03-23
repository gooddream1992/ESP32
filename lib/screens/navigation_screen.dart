import 'dart:developer';
import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:esp_32/auth/login_screen.dart';
import 'package:esp_32/screens/plan_screen.dart';
import 'package:esp_32/screens/privacy_screen.dart';
import 'package:esp_32/screens/terms_condition_screen.dart';
import 'package:esp_32/screens/walking_map_screen.dart';
import 'package:excel/excel.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:url_launcher/url_launcher.dart';

import '../auth/profile_screen.dart';
import '../utils/app_const.dart';
import '../utils/color_utils.dart';
import '../utils/textStyles.dart';
import 'boost_history.dart';
import 'bosted_streets.dart';
import 'led_map_screen.dart';

class NavigationScreen extends StatefulWidget {
  const NavigationScreen({Key? key}) : super(key: key);

  @override
  _NavigationScreenState createState() => _NavigationScreenState();
}

class _NavigationScreenState extends State<NavigationScreen> {
  ColorUtils colorUtils = ColorUtils();
  FontUtils fontUtils = FontUtils();
  int selectedIndex = 0;
  int IsSelected = 0;

  bool minimum = false;
  bool medium = false;
  bool maximum = false;

  String isUserProfile =
      "https://www.unoreads.com/user_profile_pic/demo-user.png";
  String isUserName = "Name";

  String totalUsers = "";
  List TitleList = [
    {
      "title": "minimum",
      "star": 2.0,
      "starCount": 2,
    },
    {
      "title": "maximum",
      "star": 5.0,
      "starCount": 5,
    },
    {
      "title": "high beams",
      "star": 10.0,
      "starCount": 10,
    },
  ];

  List tbleRows = [];
  List transports = [];

  getAllTransports() async {
    await FirebaseFirestore.instance
        .collection("Transports")
        .get()
        .then((value) {
      value.docs.forEach((element) {
        transports.add(element.data());
        log("transports ======>>>>>>>> " + transports.toString());
      });
      setState(() {});
    });
  }

  ///==== Get user Profile =====
  getProfile() {
    FirebaseFirestore.instance
        .collection("Users")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((value) {
      isUserProfile = value.data()!["profile"].toString();
      isUserName = value.data()!["name"].toString();
      setState(() {});
      log(value.data()!["profile"].toString() + "*--*-*-*-*-*-*-*");
    });
    FirebaseFirestore.instance.collection("Users").get().then((value) {
      totalUsers = value.docs.length.toString();
      setState(() {});
    });
  }

  ///==== Set user Collection Manually (not calling)====
  setUser() {
    FirebaseFirestore.instance
        .collection("Users")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .set({
      "lat": "35.861590",
      "long": "104.196709",
      "isActive": true,
    }, SetOptions(merge: true));
  }

  Excel? selectedExcel;
  String sheetName = "";

  ///==== Excel File get and set =====
  pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      File file = File(result.files.single.path.toString());
      var bytes = file.readAsBytesSync();
      var excel = Excel.decodeBytes(bytes);
      selectedExcel = excel;
      log(selectedExcel!["Sheet1"].sheetName + "--------");
      Sheet sheet = selectedExcel!["Sheet1"];
      sheetName = sheet.sheetName;

      getList();
    } else {
      // User canceled the picker
    }
    log("The final List of List Length is ${tbleRows.length}");
  }

  getList() async {
    // tbleRows.clear();
    log(selectedExcel!["Sheet1"].rows.length.toString() + "++++++");
    for (var row in selectedExcel![sheetName].rows) {
      log(row.toString() + "+-+-++--+-+");
      tbleRows.add(row);
      log(tbleRows.toString() + "/*/*/*/*/*/*/*");
    }
    setState(() {});
  }

  ///=== Firebase Set =====
  Position? position;

  // setFirebase() async {
  //   await FirebaseFirestore.instance
  //       .collection("Users")
  //       .doc(FirebaseAuth.instance.currentUser!.uid)
  //       .set({
  //     "name": "",
  //     "emailId": FirebaseAuth.instance.currentUser!.email,
  //     "profile": "",
  //     "doorNumber": "",
  //     "street": "",
  //     "city": "",
  //     "country": "",
  //     "mobileNumber": "",
  //     "age": "",
  //     "gender": "",
  //     "brand": "",
  //     "model": "",
  //     "lightSide": "",
  //     "isSubscribe": "",
  //     "userVelocity": "",
  //     "userDistance": "",
  //     "closestUser": "",
  //   }, SetOptions(merge: true));
  // }

  ///=== User current location for Dangerous (pending)===
  getLocation() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    log(position.toString() + "/*-/*-*-/");
  }

  @override
  void initState() {
    getProfile();
    getAllTransports();
    setUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
          title: Text(
            "Navigation",
            style: fontUtils.robotoRegular.copyWith(
                fontSize: height * 0.020, color: colorUtils.whiteColor),
          ),
          backgroundColor: colorUtils.appBarBgColor,
          // actions: [
          //   GestureDetector(
          //     onTap: () {
          //       getLocation();
          //       log("/*-/*-/*-/*-/*-/*-/");
          //       //getUserPosition();
          //       //FirebaseFirestore.instance.collection("admin").doc(FirebaseAuth.instance.currentUser!.uid).set({"dLat":"","dLong":""});
          //     },
          //     child: Container(
          //         margin: EdgeInsets.only(right: width * 0.02),
          //         height: height * 0.04,
          //         width: height * .04,
          //         decoration: BoxDecoration(
          //             shape: BoxShape.circle, color: Colors.red.shade50),
          //         child: Icon(
          //           Icons.emergency_share_outlined,
          //           color: Colors.black,
          //         )),
          //   )
          // ],
          centerTitle: true),
      body: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/images/jpg/bg.jpg"),
                fit: BoxFit.fill)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              margin: EdgeInsets.only(bottom: height * 0.0),
              height: height * 0.14,
              width: width,
              color: Colors.white30,
              child: Column(
                children: [
                  // Row(
                  //   children: [
                  //     GestureDetector(
                  //       onTap: () {
                  //         Navigator.push(
                  //             context,
                  //             MaterialPageRoute(
                  //               builder: (context) => CustomDrawerScreen(),
                  //             ));
                  //       },
                  //       child: Container(
                  //         margin: EdgeInsets.only(
                  //           left: width * 0.05,
                  //           top: height * 0.05,
                  //         ),
                  //         height: height * 0.025,
                  //         width: height * 0.025,
                  //         child: Image.asset("assets/images/png/menu.png",
                  //             fit: BoxFit.fill, color: Colors.white),
                  //       ),
                  //     ),
                  //     Container(
                  //         margin: EdgeInsets.only(
                  //             top: height * 0.06,
                  //             bottom: height * 0.01,
                  //             left: width * 0.3),
                  //         child: GestureDetector(
                  //           onTap: () {
                  //             Navigator.push(
                  //                 context,
                  //                 MaterialPageRoute(
                  //                   builder: (context) => MapScreen(),
                  //                 ));
                  //           },
                  //           child: Text(
                  //             "Navigation",
                  //             style: fontUtils.robotoRegular.copyWith(
                  //                 fontSize: height * 0.020,
                  //                 color: colorUtils.whiteColor),
                  //           ),
                  //         )),
                  //   ],
                  // ),
                  // Divider(
                  //   color: Colors.red,
                  //   thickness: height * 0.0015,
                  // ),
                  Container(
                    margin:
                        EdgeInsets.only(left: width * 0.05, top: height * 0.02),
                    child: Column(
                      children: [
                        /* Row(
                          children: [
                            Text(
                              "Velocity : ",
                              style: fontUtils.robotoBold.copyWith(
                                  fontSize: height * 0.022,
                                  color: colorUtils.whiteColor),
                            ),
                            Text(
                              "35KM/H",
                              style: fontUtils.robotoRegular.copyWith(
                                  fontSize: height * 0.018,
                                  color: colorUtils.whiteColor),
                            ),
                          ],
                        ),
                        Container(
                          margin: EdgeInsets.only(top: height * 0.015),
                          child: Row(
                            children: [
                              Text(
                                "Distance : ",
                                style: fontUtils.robotoBold.copyWith(
                                    fontSize: height * 0.020,
                                    color: colorUtils.whiteColor),
                              ),
                              Text(
                                "10KM/Today",
                                style: fontUtils.robotoRegular.copyWith(
                                    fontSize: height * 0.018,
                                    color: colorUtils.whiteColor),
                              ),
                            ],
                          ),
                        ),*/
                        Container(
                          margin: EdgeInsets.only(top: height * 0.015),
                          child: Row(
                            children: [
                              Text(
                                "N User : ",
                                style: fontUtils.robotoBold.copyWith(
                                    fontSize: height * 0.025,
                                    color: colorUtils.whiteColor),
                              ),
                              Text(
                                totalUsers,
                                style: fontUtils.robotoRegular.copyWith(
                                    fontSize: height * 0.025,
                                    color: colorUtils.whiteColor),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: height * 0.01),
                          child: Row(
                            children: [
                              Text(
                                "Who's Closest : ",
                                style: fontUtils.robotoBold.copyWith(
                                    fontSize: height * 0.025,
                                    color: colorUtils.whiteColor),
                              ),
                              Container(
                                height: height * 0.045,
                                width: width * 0.1,
                                child: Image.asset(
                                    "assets/images/png/motorcycle.png",
                                    fit: BoxFit.fill),
                              )
                            ],
                          ),
                        ),
                        // Container(
                        //   margin: EdgeInsets.only(top: height * 0.015),
                        //   child: Row(
                        //     children: [
                        //       Text(
                        //         "Velocity : ",
                        //         style: fontUtils.robotoBold.copyWith(
                        //             fontSize: height * 0.025,
                        //             color: colorUtils.whiteColor),
                        //       ),
                        //       Text(
                        //         totalUsers,
                        //         style: fontUtils.robotoRegular.copyWith(
                        //             fontSize: height * 0.025,
                        //             color: colorUtils.whiteColor),
                        //       ),
                        //     ],
                        //   ),
                        // ),
                        // Container(
                        //   margin: EdgeInsets.only(top: height * 0.015),
                        //   child: Row(
                        //     children: [
                        //       Text(
                        //         "Distance : ",
                        //         style: fontUtils.robotoBold.copyWith(
                        //             fontSize: height * 0.025,
                        //             color: colorUtils.whiteColor),
                        //       ),
                        //       Text(
                        //         totalUsers,
                        //         style: fontUtils.robotoRegular.copyWith(
                        //             fontSize: height * 0.025,
                        //             color: colorUtils.whiteColor),
                        //       ),
                        //     ],
                        //   ),
                        // ),
                      ],
                    ),
                  )
                ],
              ),
            ),

            // GestureDetector(
            //   onTap: () {
            //     pickFile();
            //   },
            //   child: Container(
            //     child: Text("data"),
            //   ),
            // ),

            Column(
              children: [
                Container(
                  margin: EdgeInsets.only(bottom: height * 0.03),
                  child: Text(
                    "This is me",
                    style: fontUtils.robotoMedium.copyWith(
                        fontSize: height * 0.028, color: colorUtils.blackColor),
                  ),
                ),
                Container(
                  height: height * 0.15,
                  child: PageView.builder(
                      itemCount: transports.length,
                      pageSnapping: true,
                      itemBuilder: (context, pagePosition) {
                        return Container(
                            margin: EdgeInsets.all(10),
                            child: Image.network(
                                transports[pagePosition]["image"]));
                      }),
                  /* child: CarouselSlider(
                    items: [
                      //1st Image of Slider
                      Container(
                        padding: EdgeInsets.all(2.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.0),
                          image: DecorationImage(
                            image: AssetImage("assets/images/png/men.png"),
                            fit: BoxFit.fitHeight,
                          ),
                        ),
                      ),

                      //2nd Image of Slider
                      Container(
                        padding: EdgeInsets.all(5.0),
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage("assets/images/png/bike.png"),
                            fit: BoxFit.fitHeight,
                          ),
                        ),
                      ),

                      //3rd Image of Slider
                      Container(
                        padding: EdgeInsets.all(5.0),
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage("assets/images/jpg/bycycle.png"),
                            fit: BoxFit.fitHeight,
                          ),
                        ),
                      ),

                      //4th Image of Slider
                      Container(
                        padding: EdgeInsets.all(5.0),
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image:
                                AssetImage("assets/images/png/motorcycle.png"),
                            fit: BoxFit.fitHeight,
                          ),
                        ),
                      ),

                      //5th Image of Slider
                      Container(
                        margin: EdgeInsets.all(5.0),
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage("assets/images/png/car.png"),
                            fit: BoxFit.fitHeight,
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.all(5.0),
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage("assets/images/png/truck.png"),
                            fit: BoxFit.fitHeight,
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(5.0),
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage("assets/images/png/train.png"),
                            fit: BoxFit.fitHeight,
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(5.0),
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage("assets/images/png/boat.png"),
                            fit: BoxFit.fitHeight,
                          ),
                        ),
                      ),
                    ],

                    //Slider Container properties
                    options: CarouselOptions(
                      height: 180.0,
                      enlargeCenterPage: true,
                      autoPlay: false,
                      aspectRatio: 16 / 9,
                      autoPlayCurve: Curves.ease,
                      enableInfiniteScroll: false,
                      autoPlayAnimationDuration: Duration(milliseconds: 800),
                      viewportFraction: 0.8,
                    ),
                  ),*/
                ),
              ],
            ),

            // Container(
            //   child: Column(
            //     children: [
            //       Container(
            //         margin: EdgeInsets.only(bottom: height * 0.03),
            //         child: Text(
            //           "This is me",
            //           style: fontUtils.robotoMedium.copyWith(
            //               fontSize: height * 0.028,
            //               color: colorUtils.blackColor),
            //         ),
            //       ),
            //       Row(
            //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //         children: [
            //           GestureDetector(
            //             onTap: () {
            //               setState(() {
            //                 selectedIndex == 0
            //                     ? selectedIndex = 0
            //                     : selectedIndex = selectedIndex - 1;
            //               });
            //             },
            //             child: Container(
            //               height: height * 0.04,
            //               width: width * 0.1,
            //               margin: EdgeInsets.only(left: width * 0.03),
            //               child: Row(
            //                 children: [
            //                   Image(
            //                     image: AssetImage(
            //                         "assets/images/png/backbutton.png"),
            //                     fit: BoxFit.fill,
            //                   )
            //                 ],
            //               ),
            //             ),
            //           ),
            //           Container(
            //               height: height * 0.15,
            //               width: height * 0.15,
            //               child: Image(
            //                 image: AssetImage(itemList[selectedIndex]["icon"]),
            //                 fit: BoxFit.fill,
            //               )),
            //           GestureDetector(
            //             onTap: () {
            //               setState(() {
            //                 selectedIndex == 7
            //                     ? selectedIndex = 7
            //                     : selectedIndex = selectedIndex + 1;
            //               });
            //             },
            //             child: RotatedBox(
            //               quarterTurns: 6,
            //               child: Container(
            //                 height: height * 0.04,
            //                 width: width * 0.1,
            //                 margin: EdgeInsets.only(left: width * 0.03),
            //                 child: Row(
            //                   children: [
            //                     Image(
            //                       image: AssetImage(
            //                           "assets/images/png/backbutton.png"),
            //                       fit: BoxFit.fill,
            //                     )
            //                   ],
            //                 ),
            //               ),
            //             ),
            //           )
            //         ],
            //       )
            //     ],
            //   ),
            // ),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                GestureDetector(
                  onTap: () {
                    FirebaseFirestore.instance
                        .collection("Users")
                        .doc(FirebaseAuth.instance.currentUser!.uid)
                        .set({"lightSide": "Left"}, SetOptions(merge: true));
                  },
                  child: Icon(
                    Icons.keyboard_double_arrow_left_outlined,
                    size: height * 0.08,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    FirebaseFirestore.instance
                        .collection("Users")
                        .doc(FirebaseAuth.instance.currentUser!.uid)
                        .set({"lightSide": "Hazard"}, SetOptions(merge: true));
                  },
                  child: Container(
                    height: height * 0.06,
                    width: height * 0.07,
                    padding: EdgeInsets.only(
                        bottom: height * 0.015, top: height * 0.01),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Colors.black54,
                      shape: BoxShape.circle,
                    ),
                    child: Image(image: AssetImage("assets/icons/hazard.png")),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    FirebaseFirestore.instance
                        .collection("Users")
                        .doc(FirebaseAuth.instance.currentUser!.uid)
                        .set({"lightSide": "Right"}, SetOptions(merge: true));
                  },
                  child: RotatedBox(
                      quarterTurns: 6,
                      child: Icon(
                        Icons.keyboard_double_arrow_left_outlined,
                        size: height * 0.08,
                      )),
                ),
              ],
            ),

            Container(
              height: height * 0.18,
              width: width,
              color: Colors.transparent,
              child: Column(
                children: [
                  Divider(
                    color: Colors.red,
                    thickness: height * 0.0015,
                  ),
                  Container(
                    margin: EdgeInsets.only(bottom: height * 0.02),
                    child: Text(
                      "Range",
                      style: fontUtils.robotoBold.copyWith(
                          fontSize: height * 0.024,
                          color: colorUtils.blackColor),
                    ),
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            minimum = true;
                            medium = false;
                            maximum = false;
                          });

                          FirebaseFirestore.instance
                              .collection("Users")
                              .doc(FirebaseAuth.instance.currentUser!.uid)
                              .set({"range": "Minimum"},
                                  SetOptions(merge: true));
                        },
                        child: Container(
                          height: height * 0.055,
                          width: width * 0.25,
                          padding: EdgeInsets.only(top: height * 0.005),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(width * 0.02),
                            color: minimum == true
                                ? Colors.amber.withOpacity(0.8)
                                : Colors.white,
                          ),
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text("Minimum",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    customStat(15.0),
                                    customStat(15.0),
                                    customStat(15.0),
                                  ],
                                )
                              ]),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            minimum = false;
                            medium = true;
                            maximum = false;
                          });
                          FirebaseFirestore.instance
                              .collection("Users")
                              .doc(FirebaseAuth.instance.currentUser!.uid)
                              .set(
                                  {"range": "Medium"}, SetOptions(merge: true));
                        },
                        child: Container(
                          height: height * 0.055,
                          width: width * 0.25,
                          padding: EdgeInsets.only(top: height * 0.005),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(width * 0.02),
                            color: medium == true
                                ? Colors.amber.withOpacity(0.8)
                                : Colors.white,
                          ),
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text("Medium",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    customStat(15.0),
                                    customStat(15.0),
                                    customStat(15.0),
                                    customStat(15.0),
                                    customStat(15.0),
                                  ],
                                )
                              ]),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            minimum = false;
                            medium = false;
                            maximum = true;

                            FirebaseFirestore.instance
                                .collection("Users")
                                .doc(FirebaseAuth.instance.currentUser!.uid)
                                .set({"range": "Maximum"},
                                    SetOptions(merge: true));
                          });
                        },
                        child: Container(
                          height: height * 0.055,
                          width: width * 0.25,
                          padding: EdgeInsets.only(top: height * 0.005),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(width * 0.02),
                            color: maximum == true
                                ? Colors.amber.withOpacity(0.8)
                                : Colors.white,
                          ),
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text("Maximum",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    customStat(11.0),
                                    customStat(11.0),
                                    customStat(11.0),
                                    customStat(11.0),
                                    customStat(11.0),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    customStat(11.0),
                                    customStat(11.0),
                                    customStat(11.0),
                                    customStat(11.0),
                                    customStat(11.0),
                                  ],
                                ),
                              ]),
                        ),
                      ),
                    ],
                  )

                  // Container(
                  //   height: height * 0.06,
                  //   child: ListView.builder(
                  //     scrollDirection: Axis.horizontal,
                  //     physics: BouncingScrollPhysics(),
                  //     shrinkWrap: true,
                  //     itemCount: TitleList.length,
                  //     itemBuilder: (context, index) {
                  //       return GestureDetector(
                  //         onTap: () {
                  //           setState(() {
                  //             IsSelected = index;
                  //           });
                  //         },
                  //         child: Container(
                  //           alignment: Alignment.center,
                  //           decoration: BoxDecoration(
                  //             borderRadius: BorderRadius.circular(width * 0.03),
                  //             color: IsSelected != index
                  //                 ? Colors.white
                  //                 : Colors.amber.withOpacity(0.8),
                  //           ),
                  //           margin: EdgeInsets.only(left: width * 0.05),
                  //           height: height * 0.03,
                  //           width: width * 0.25,
                  //           child: Column(
                  //             mainAxisAlignment: MainAxisAlignment.center,
                  //             children: [
                  //               Container(
                  //                 margin:
                  //                     EdgeInsets.only(bottom: height * 0.002),
                  //                 child: Text(TitleList[index]["title"],
                  //                     style: fontUtils.robotoBold
                  //                         .copyWith(color: Colors.black)),
                  //               ),
                  //               Container(
                  //                 padding: EdgeInsets.only(
                  //                     left: width * 0.04, right: width * 0.04),
                  //                 child: RatingBar.builder(
                  //                   glow: false,
                  //
                  //                   initialRating: TitleList[index]["star"],
                  //                   // minRating: 3,
                  //                   direction: Axis.horizontal,
                  //                   unratedColor: Colors.black,
                  //                   itemSize: width * 0.03,
                  //                   allowHalfRating: false,
                  //                   itemCount: TitleList[index]["starCount"],
                  //                   glowRadius: 0.0,
                  //                   itemPadding: EdgeInsets.zero,
                  //                   itemBuilder: (context, _) => Icon(
                  //                     Icons.star,
                  //                     color: Colors.black,
                  //                   ),
                  //                   onRatingUpdate: (rating) {
                  //                     print(rating);
                  //                   },
                  //                 ),
                  //               ),
                  //             ],
                  //           ),
                  //         ),
                  //       );
                  //     },
                  //   ),
                  // ),
                ],
              ),
            )
          ],
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: colorUtils.appBarBgColor,
              ),
              child: Column(
                children: [
                  Container(
                    margin: EdgeInsets.only(bottom: height * 0.01),
                    height: height * 0.1,
                    width: height * 0.1,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        image: DecorationImage(
                            image: NetworkImage(isUserProfile.toString()),
                            fit: BoxFit.fill),
                        shape: BoxShape.circle),
                  ),
                  Text(
                    isUserName.toString(),
                    style: fontUtils.robotoBold.copyWith(
                        fontSize: height * 0.020, color: colorUtils.whiteColor),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: Icon(Icons.map_outlined),
              title: Text('Walking Map'),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => WalkingMapScreen(),
                    ));
              },
            ),
            ListTile(
              leading: Icon(Icons.map),
              title: Text('LED Network map'),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => LedMapScreen(),
                    ));
              },
            ),
            ListTile(
              leading: Icon(Icons.account_circle_outlined),
              title: Text('Profile'),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProfilePage(),
                    ));
              },
            ),
            ListTile(
              leading: Icon(Icons.account_tree_outlined),
              title: Text('Boosted Streets'),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BostedStreets(),
                    ));
              },
            ),
            ListTile(
              leading: Icon(Icons.history_edu_outlined),
              title: Text('Boost History'),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BoostHistoryScreen(),
                    ));
              },
            ),
            ListTile(
              leading: Icon(Icons.payments_outlined),
              title: Text('Payment'),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PlanScreen(),
                    ));
              },
            ),
            ListTile(
              leading: Icon(Icons.privacy_tip_outlined),
              title: Text('Privacy'),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PrivacyScreen(),
                    ));
              },
            ),
            ListTile(
              leading: Icon(Icons.notifications_none_rounded),
              title: Text('Notification'),
              onTap: () {
                // Update the state of the app
                // ...
                // Then close the drawer
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.policy_outlined),
              title: Text('Terms Condition'),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TermsConditionScreen(),
                    ));
              },
            ),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text('Logout'),
              onTap: () {
                logout();
              },
            ),
            ListTile(
              title: Text('www.way5g.com',
                  style: TextStyle(color: Colors.blueAccent)),
              onTap: () {
                launchUrl("http://www.way5g.com/");
              },
            ),
          ],
        ),
      ),
    );
  }

  customStat(double size) {
    return Icon(
      Icons.star,
      color: Colors.black,
      size: size,
    );
  }

  void logout() async {
    await FirebaseAuth.instance.signOut();

    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => LoginScreen(),
        ));
  }

  Future launchUrl(String url) async {
    if (await canLaunch(url))
      await launch(url);
    else
      throw "Could not launch $url";
  }
}

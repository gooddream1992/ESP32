import 'dart:async';
import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:uuid/uuid.dart';
import '../utils/app_const.dart';
import '../utils/color_utils.dart';
import '../utils/textStyles.dart';
import 'boost_screen.dart';

class LedMapScreen extends StatefulWidget {
  const LedMapScreen({Key? key}) : super(key: key);

  @override
  _LedMapScreenState createState() => _LedMapScreenState();
}

class _LedMapScreenState extends State<LedMapScreen> {
  Completer<GoogleMapController> _controller = Completer();
  var uuid = Uuid();
  var markers = [];
  TextEditingController _faultController = TextEditingController();

  loopLocation() async {
    var markerImageGreen = await BitmapDescriptor.fromAssetImage(
      ImageConfiguration(size: Size(1, 1)),
      'assets/images/png/greenLight.png',
    );

    var markerImageRed = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(size: Size(0.5, 0.5)),
        'assets/images/png/redLight.png');

    /*for (int i = 0; i < latLongList.length; i++) {
      setState(() {
        log("==============");
        log(latLongList.toString());
        log(latLongList[i].toString());
        log((latLongList[i] is String).toString());

        log(latLongList[i]["long"]);
        listLatLong.add(
          {
            "title": latLongList[i]["lat"].toString(),
            "id": latLongList[i]["lat"].toString(),
            "lat": double.parse(latLongList[i]["lat"]),
            "lon": double.parse(latLongList[i]["long"])
          },
        );
      });
      log(listLatLong.toString());
    }*/
    for (var i = 0; i < latLongList.length; i++) {
      var now = new DateTime.now().millisecondsSinceEpoch;
      markers.add(
        Marker(
            markerId: MarkerId(latLongList[i].toString() + now.toString()),
            position: LatLng(double.parse(latLongList[i]["lat"]),
                double.parse(latLongList[i]["long"])),
            infoWindow: InfoWindow(
                title: (latLongList[i]["isFaulty"].toString() == "false")
                    ? "Any Issue"
                    : "",
                onTap: () {
                  if (latLongList[i]["isFaulty"].toString() == "false") {
                    popupCustom(latLongList[i]["isFaulty"].toString(),
                        latLongList[i]["id"]);
                  }
                }),
            icon: latLongList[i]["isFaulty"].toString() == "false"
                ? markerImageGreen
                : markerImageRed
            // infoWindow: InfoWindow(title: address, snippet: "go here"),
            ),
      );
    }
  }

  List<Map<String, dynamic>> listLatLong = [];

  // static List<Map<String, dynamic>> listLat = List.from(latLongList)
  // [

  // {"title": "one", "id": "1", "lat": 35.861590, "lon": 104.195689},
  // {"title": "two", "id": "2",   "lat": 35.861268, "lon": 104.195411},
  // {"title": "three", "id": "3", "lat": 35.862051, "lon": 104.196709},
  // ];

  // Iterable _markers = Iterable.generate(listLat.length, (index) {
  //   return Marker(
  //       markerId: MarkerId(listLat[index]['id']),
  //       position: LatLng(
  //         listLat[index]['lat'],
  //         listLat[index]['lon'],
  //       ),
  //       infoWindow: InfoWindow(title:listLat[index]["title"]));
  // });

  ColorUtils colorUtils = ColorUtils();
  FontUtils fontUtils = FontUtils();
  late GoogleMapController mapController;
  List latLongList = [];

  //Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  final LatLng _center = LatLng(35.8617, 104.1954);

  getLatlong() async {
    await FirebaseFirestore.instance.collection("LEDs").get().then((value) {
      value.docs.forEach((element) {
        setState(() {
          latLongList.add(element.data());
        });
        //latLongList = element.data().toString();
        log(element.data().toString());
      });
      loopLocation();
    });
  }

  Map<String, dynamic> isFaultyMap = {};

  reportLed(String id) async {
    log(id.toString());
    await FirebaseFirestore.instance
        .collection("LEDs")
        .where("id", isEqualTo: id)
        .get()
        .then((value) {
      value.docs.forEach((element) async {
        setState(() {
          isFaultyMap = element.data();
          isFaultyMap["isFaulty"] = true;
          isFaultyMap["faultReason"] = _faultController.text.toString();
          isFaultyMap["date"] = DateTime.now().month.toString() +
              "/" +
              DateTime.now().day.toString() +
              "/" +
              DateTime.now().year.toString();
          log(isFaultyMap.toString() + "/*//*/***/**/*/*/*");
        });
        log(element.data().toString() + "----89898989");
        log(element.id.toString() + "----787878");

        await FirebaseFirestore.instance
            .collection("LEDs")
            .doc(element.id)
            .set(isFaultyMap, SetOptions(merge: true))
            .onError(
              (error, stackTrace) => Fluttertoast.showToast(
                msg: error.toString(),
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 1,
              ),
            );
        Fluttertoast.showToast(
          msg: "Thank you for malfunction error",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
        );
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => LedMapScreen(),
            ));
      });
    });
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  ///===== Sahre Function ====
  Future<void> share() async {
    await FlutterShare.share(
        title: 'way5g',
        text: 'way5g',
        linkUrl: 'www.way5g.com',
        chooserTitle: 'way5g');
  }

  // Future<void> _onMapCreated(GoogleMapController controller) async {
  //   final googleOffices = await locations.getGoogleOffices();
  //   setState(() {
  //     _markers.clear();
  //     for (final office in googleOffices.offices) {
  //       final marker = Marker(
  //         markerId: MarkerId(office.name),
  //         position: LatLng(office.lat, office.lng),
  //         infoWindow: InfoWindow(
  //           title: office.name,
  //           snippet: office.address,
  //         ),
  //       );
  //       _markers[office.name] = marker;
  //     }
  //   });
  // }

  // List<Marker> _markers = [];

  ///=== build adta ===
  buildGetData() async {
    await FirebaseFirestore.instance.collection("LEDs").doc(uuid.v4()).set({
      "lat": "35.862051",
      "long": '104.196709',
      "isFaulty": true,
    });
    //     .then((value) {
    //   log(value.data().toString());
    //   setState(() {
    //     nameController.text = value.data()!["name"] ?? "";
    //     emailController.text = value.data()!["emailId"] ?? "";
    //     doorNumberController.text = value.data()!["doorNumber"] ?? "";
    //     streetController.text = value.data()!["street"] ?? "";
    //     cityController.text = value.data()!["city"] ?? "";
    //     countryController.text = value.data()!["country"] ?? "";
    //     userProfile = value.data()!["profile"] ?? "";
    //     //addressController.text = value.data()!["address"] ?? "";
    //     mobileController.text = value.data()!["mobileNumber"] ?? "";
    //     ageController.text = value.data()!["age"] ?? "";
    //     genderController.text = value.data()!["gender"] ?? "";
    //     pinController.text = value.data()!["pinCode"] ?? "";
    //     stateController.text = value.data()!["state"] ?? "";
    //     brandController.text = value.data()!["brand"] ?? "";
    //     modelController.text = value.data()!["model"] ?? "";
    //   });
    // });
  }

  ///=== User current location for Dangerous (Pending)===
  getLocation() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    log(position.toString() + "/*-/*-*-/");
  }

  @override
  void initState() {
    getLatlong();
    //buildGetData();
    // setState(() {
    //   markers = _markers;
    // });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
          title: Text(
            "LED Light Map",
            style: fontUtils.robotoRegular.copyWith(
                fontSize: height * 0.020, color: colorUtils.whiteColor),
          ),
          backgroundColor: colorUtils.appBarBgColor,
          centerTitle: true),
      body: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/images/jpg/bg.jpg"),
                fit: BoxFit.fill)),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Container(
              //   height: height * 0.1,
              //   decoration: BoxDecoration(
              //     color: Colors.white30,
              //
              //     border: Border(
              //       bottom: BorderSide(width: 1.9, color: Colors.red),
              //     ),
              //   ),
              //   child: Row(
              //     children: [
              //       GestureDetector(
              //         onTap: () {
              //           Navigator.push(
              //               context,
              //               MaterialPageRoute(
              //                 builder: (context) => CustomDrawerScreen(),
              //               ));
              //         },
              //         child: Container(
              //           margin: EdgeInsets.only(
              //             left: width * 0.05,
              //             top: height * 0.05,
              //           ),
              //           height: height * 0.025,
              //           width: height * 0.025,
              //           child: Image.asset("assets/images/png/menu.png",
              //               fit: BoxFit.fill, color: Colors.white),
              //         ),
              //       ),
              //       Container(
              //           margin: EdgeInsets.only(
              //                top: height * 0.06,
              //               bottom: height * 0.015,
              //               left: width * 0.30),
              //           child: Text(
              //             "Networks Maps",
              //             style: fontUtils.robotoRegular.copyWith(
              //                 fontSize: height * 0.020,
              //                 color: colorUtils.whiteColor),
              //           )),
              //     ],
              //   ),
              // ),
              Container(
                margin: EdgeInsets.only(
                    // left: width * 0.05,
                    // top: height * 0.05,
                    ),
                height: height * 0.72,
                width: width,
                child: GoogleMap(
                  onMapCreated: _onMapCreated,
                  markers: Set.from(markers),
                  initialCameraPosition: CameraPosition(
                    target: _center,
                    zoom: 16.5,
                  ),
                  onTap: _handleTap,
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        margin: EdgeInsets.only(
                            left: width * 0.04, top: height * 0.005),
                        child: Text(
                          "Report Malfunction",
                          style: fontUtils.robotoMedium.copyWith(
                              fontSize: height * 0.020,
                              color: colorUtils.blackColor),
                        ),
                      )
                    ],
                  ),
                  Container(
                    margin: EdgeInsets.only(
                        bottom: height * 0.03, top: height * 0.012),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        // Text(
                        //   "DONATE",
                        //   style: fontUtils.robotoBold.copyWith(
                        //       fontSize: height * 0.026,
                        //       color: colorUtils.blackColor),
                        // ),
                        GestureDetector(
                          onTap: () {
                            /* Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => BoostScreen(),
                                ));*/
                            Fluttertoast.showToast(
                              msg: "please select Your street on map for boost",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM,
                              timeInSecForIosWeb: 1,
                            );
                          },
                          child: Container(
                            height: height * 0.04,
                            width: width * 0.4,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.circular(width * 0.015),
                              color: colorUtils.appBarBgColor.withOpacity(0.6),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.whatshot_sharp),
                                Container(
                                  margin: EdgeInsets.only(left: width * 0.02),
                                  child: Text(
                                    "BOOST",
                                    style: fontUtils.robotoBold.copyWith(
                                        fontSize: height * 0.022,
                                        color: colorUtils.blackColor),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        // Text(
                        //   "INVEST",
                        //   style: fontUtils.robotoBold.copyWith(
                        //       fontSize: height * 0.026,
                        //       color: colorUtils.blackColor),
                        // ),
                        GestureDetector(
                          onTap: () {
                            share();
                          },
                          child: Container(
                            height: height * 0.04,
                            width: width * 0.4,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.circular(width * 0.015),
                              color: colorUtils.appBarBgColor.withOpacity(0.6),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.share_location),
                                Container(
                                  margin: EdgeInsets.only(left: width * 0.02),
                                  child: Text(
                                    "SHARE",
                                    style: fontUtils.robotoBold.copyWith(
                                        fontSize: height * 0.022,
                                        color: colorUtils.blackColor),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  popupCustom(String isFaulty, String id) {
    return showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
          elevation: 16,
          child: Container(
            child: Container(
              height: height * 0.26,
              width: height * 0.05,
              padding: EdgeInsets.all(width * 0.02),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(width * 0.05)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text("Is Faulty",
                      style: TextStyle(
                          fontSize: height * 0.020,
                          fontWeight: FontWeight.w600)),
                  /* Text(isFaulty.toString(),
                      style: TextStyle(
                          fontSize: height * 0.020,
                          fontWeight: FontWeight.w600)),*/
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text("is there any fault in LED?"),
                    ],
                  ),
                  TextFormField(
                    controller: _faultController,
                    style: TextStyle(fontSize: height * 0.022),
                    decoration: InputDecoration(
                      // icon: Icon(Icons.person),
                      hintText: "What is the problem",
                      // labelText: lable,
                      /* labelStyle: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: height * 0.022,
                        )*/
                    ),
                    //onSaved: (String? value) {
                    // This optional block of code can be used to run
                    // code when the user saves the form.
                    //},
                    // validator: (String? value) {
                    //   return (value != null && value.contains('@'))
                    //       ? 'Do not use the @ char.'
                    //       : null;
                    // },
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Container(
                          child: Text("No",
                              style: TextStyle(
                                  fontSize: height * 0.020,
                                  fontWeight: FontWeight.w600)),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          reportLed(id);
                          // FirebaseFirestore.instance
                          //     .collection("LEDs")
                          //     .doc()
                          //     .set({"isFaulty": false}, SetOptions(merge: true));
                        },
                        child: Container(
                          child: Text("Yes",
                              style: TextStyle(
                                  fontSize: height * 0.020,
                                  fontWeight: FontWeight.w600)),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  _handleTap(LatLng point) {
    setState(() {
      markers.add(Marker(
        markerId: MarkerId(point.toString()),
        position: point,
        infoWindow: InfoWindow(
          title: 'New Street',
        ),
        icon:
            BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueMagenta),
      ));
    });
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => BoostScreen(point),
        ));
  }
}

// class AppConstant {
//   static List<Map<String, dynamic>> list = [
//       {"title": "one", "id": "1", "lat": 35.861590, "lon": 104.195689},
//     {"title": "two", "id": "2",   "lat": 35.861268, "lon": 104.195411},
//     {"title": "three", "id": "3", "lat": 35.862051, "lon": 104.196709},
//   ];
// }

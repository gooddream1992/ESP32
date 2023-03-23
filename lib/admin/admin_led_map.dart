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
import 'faulty_led_map.dart';

class AdminLedMap extends StatefulWidget {


  @override
  _AdminLedMapState createState() => _AdminLedMapState();
}

class _AdminLedMapState extends State<AdminLedMap> {
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

    for (var i = 0; i < latLongList.length; i++) {
      var now = new DateTime.now().millisecondsSinceEpoch;
      markers.add(
        Marker(
            markerId: MarkerId(latLongList[i].toString() + now.toString()),
            position: LatLng(double.parse(latLongList[i]["lat"]),
                double.parse(latLongList[i]["long"])),
            infoWindow: InfoWindow(
                title: (latLongList[i]["isFaulty"].toString() == "true")
                    ? latLongList[i]["faultReason"]
                    : "",
                onTap: () async {
                  if (latLongList[i]["isFaulty"].toString() == "true") {
                    var res = await popupCustom(
                        latLongList[i]["isFaulty"].toString(),
                        latLongList[i]["id"]);
                    if (res) {
                      setState(() {});
                    }
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

  ColorUtils colorUtils = ColorUtils();
  FontUtils fontUtils = FontUtils();
  late GoogleMapController mapController;
  List latLongList = [];

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
          isFaultyMap["isFaulty"] = false;
          // isFaultyMap["faultReason"] = _faultController.text.toString();
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
          msg: "Malfunction Solved",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
        );
        setState(() {});
Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => AdminLedMap(),), (route) => false);
        // Navigator.of(context).pop(true);

        getLatlong();
      });
    });
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  ///=== build adta ===
  buildGetData() async {
    await FirebaseFirestore.instance.collection("LEDs").doc(uuid.v4()).set({
      "lat": "35.862051",
      "long": '104.196709',
      "isFaulty": true,
    });
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
          centerTitle: true,
          actions: [
            GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => FaultyLedMap(),
                    ));
              },
              child: Container(
                padding: EdgeInsets.only(right: width * 0.02),
                child: Icon(Icons.document_scanner_rounded),
              ),
            )
          ]),
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
              Container(
                height: height * 0.87,
                width: width,
                child: GoogleMap(
                  onMapCreated: _onMapCreated,
                  markers: Set.from(markers),
                  initialCameraPosition: CameraPosition(
                    target: _center,
                    zoom: 16.5,
                  ),
                ),
              ),
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
              height: height * 0.2,
              width: height * 0.05,
              padding: EdgeInsets.all(width * 0.02),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(width * 0.05)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(
                    "Is Faulty",
                    style: TextStyle(
                        fontSize: height * 0.020, fontWeight: FontWeight.w600),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("is all fault in LED solved?"),
                    ],
                  ),
                  /* TextFormField(
                    controller: _faultController,
                    style: TextStyle(fontSize: height * 0.022),
                    decoration: InputDecoration(
                      // icon: Icon(Icons.person),
                      hintText: "What is the problem",
                    ),
                  ),*/
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).pop(false);
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
}

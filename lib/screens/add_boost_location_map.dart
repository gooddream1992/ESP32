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
import 'led_map_screen.dart';

class AddBoostLocationMap extends StatefulWidget {
  const AddBoostLocationMap({Key? key}) : super(key: key);

  @override
  _AddBoostLocationMapState createState() => _AddBoostLocationMapState();
}

class _AddBoostLocationMapState extends State<AddBoostLocationMap> {
  Completer<GoogleMapController> _controller = Completer();
  var uuid = Uuid();
  var markers = [];
  TextEditingController _faultController = TextEditingController();
  Position? currentPosition;
  List<Map<String, dynamic>> listLatLong = [];

  ColorUtils colorUtils = ColorUtils();
  FontUtils fontUtils = FontUtils();
  late GoogleMapController mapController;
  List latLongList = [];

  //Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  final LatLng _center = LatLng(35.8617, 104.1954);

  getLatlong() async {
    await FirebaseFirestore.instance.collection("Boost").get().then((value) {
      value.docs.forEach((element) {
        setState(() {
          latLongList.add(element.data());
        });
        log("2145351354453135--------");
        log(double.parse(latLongList[0]["lat"]).toString());
        log("2145351354453135--------");
      });
      loopLocation();
    });
  }

  loopLocation() async {
    var markerImageGreen = await BitmapDescriptor.fromAssetImage(
      ImageConfiguration(size: Size(1, 1)),
      'assets/images/png/greenLight.png',
    );

    for (var i = 0; i < latLongList.length; i++) {
      var now = new DateTime.now().millisecondsSinceEpoch;
      markers.add(
        Marker(
            markerId: MarkerId(latLongList[i].toString() + now.toString()),
            position: LatLng(double.parse(latLongList[i]["lat"]),
                double.parse(latLongList[i]["long"])),
            infoWindow: InfoWindow(
                title: latLongList[i]["street"] + " - " + latLongList[i]["noOfMeter"] + "Meter",
                onTap: () {
                  /*   if (latLongList[i]["isFaulty"].toString() == "false") {
                    popupCustom(latLongList[i]["isFaulty"].toString(),
                        latLongList[i]["id"]);
                  }*/
                }),
            icon: markerImageGreen

            // infoWindow: InfoWindow(title: address, snippet: "go here"),
            ),
      );
      setState(() {});
    }
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
    currentPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    log(currentPosition.toString() + "/*-/*-*-/");
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
            "Boosted Routes",
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
        child: GoogleMap(
          onMapCreated: _onMapCreated,
          markers: Set.from(markers),
          initialCameraPosition: CameraPosition(
            target: _center,
            zoom: 16.5,
          ),
          // onTap: _handleTap,
        ),
      ),
    );
  }
}

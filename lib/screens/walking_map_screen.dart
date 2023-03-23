import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../utils/app_const.dart';
import '../utils/color_utils.dart';
import '../utils/textStyles.dart';

class WalkingMapScreen extends StatefulWidget {
  const WalkingMapScreen({Key? key}) : super(key: key);

  @override
  _WalkingMapScreenState createState() => _WalkingMapScreenState();
}

class _WalkingMapScreenState extends State<WalkingMapScreen> {
  late GoogleMapController mapController;
  ColorUtils colorUtils = ColorUtils();
  FontUtils fontUtils = FontUtils();
  final LatLng _center =  LatLng(35.8617, 104.1954);
  // late GoogleMapController mapController;
  List latLongList = [];

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }


  var markers = [];
  List<Map<String, dynamic>> listLatLong = [];

  getLatLong() async {
    await FirebaseFirestore.instance.collection("Users").get().then((value) {
      value.docs.forEach((element) {
        setState(() {
          latLongList.add(element.data());
        });
        //latLongList = element.data().toString();
        log(element.data().toString()+"/*/**//*/");
      });
      loopLocation();
    });
  }

  loopLocation() async {
    var markerImageGreen = await BitmapDescriptor.fromAssetImage(
      ImageConfiguration(size: Size(1, 1)),
      'assets/images/png/online.png');

    var markerImageGrey = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(size: Size(0.5, 0.5)),
        'assets/images/png/offline.png');

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
      var now = DateTime.now().millisecondsSinceEpoch;
      markers.add(
        Marker(
          markerId: MarkerId(latLongList[i].toString() + now.toString()),
          position: LatLng(double.parse(latLongList[i]["lat"]),
              double.parse(latLongList[i]["long"])),
          icon:latLongList[i]["isActive"].toString()=="true"?markerImageGreen:markerImageGrey
              ),
      );
      log(latLongList[i]["isActive"].toString());

    }
  }

  @override
  void initState() {
    getLatLong();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
          title: Text(
            "Walking Map",
            style: fontUtils.robotoRegular.copyWith(
                fontSize: height * 0.020, color: colorUtils.whiteColor),
          ),
          backgroundColor: colorUtils.appBarBgColor,
          centerTitle: true),
      body: GoogleMap(
        onMapCreated: _onMapCreated,
        markers: Set.from(markers),

        initialCameraPosition: CameraPosition(
          target: _center,
          zoom: 16.5,
        ),
      ),
    );
  }
}

import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:esp_32/admin/all_user_list.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../auth/login_screen.dart';
import '../screens/bosted_streets.dart';

import '../screens/walking_map_screen.dart';
import '../utils/app_const.dart';
import '../utils/color_utils.dart';
import '../utils/textStyles.dart';
import 'admin_led_map.dart';

class adminDashboard extends StatefulWidget {
  const adminDashboard({Key? key}) : super(key: key);

  @override
  State<adminDashboard> createState() => _adminDashboardState();
}

class _adminDashboardState extends State<adminDashboard> {
  ColorUtils colorUtils = ColorUtils();
  FontUtils fontUtils = FontUtils();
  List transports = [];
  File? transportImage;
  String transportImageLink = "";
  TextEditingController _transportNameController = TextEditingController();

  @override
  void initState() {
    getAllTransports();
    // setTransportIcon("truck");
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
          title: Text(
            "Transport Type",
            style: fontUtils.robotoRegular.copyWith(
                fontSize: height * 0.020, color: colorUtils.whiteColor),
          ),
          backgroundColor: colorUtils.appBarBgColor,
          centerTitle: true),
      body: DashboardBody(),
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
                        image: NetworkImage(
                          "https://i.pinimg.com/originals/0c/3b/3a/0c3b3adb1a7530892e55ef36d3be6cb8.png",
                        ),
                        fit: BoxFit.fill,
                      ),
                      shape: BoxShape.circle,
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: Icon(Icons.map_outlined),
              title: Text('Users Map'),
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
                      builder: (context) => AdminLedMap(),
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
              title: Text('All Users'),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => allUserList(),
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
          ],
        ),
      ),
    );
  }

  Widget DashboardBody() {
    return Container(
      child: GridView.builder(
        itemCount: transports.length + 1,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: (2),
        ),
        itemBuilder: (BuildContext context, int index) {
          return GestureDetector(
            onTap: () {
              if (index == transports.length) {
                showDialog(
                  context: context,
                  builder: (BuildContext context) =>
                      _buildPopupDialog(context, (index + 1)),
                );
              } else {
                setTransportIcon("", "", transports[index]["id"]);
              }
            },
            child: Stack(children: [
              Card(
                child: new GridTile(
                  footer: Center(
                      child: new Text(
                    index == transports.length
                        ? "Add New"
                        : transports[index]["type"],
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 23),
                  )),
                  child: Container(
                    padding: EdgeInsets.all(50),
                    child: index == transports.length
                        ? Icon(Icons.add)
                        : Image.network(transports[index]["image"]),
                  ), //just for testing, will fill with image later
                ),
              ),
              (index != transports.length)
                  ? Positioned(
                      right: 0,
                      top: 10,
                      child: GestureDetector(
                          onTap: () {
                            removeTransportIcon(transports[index]["id"]);
                          },
                          child: Icon(Icons.cancel)))
                  : Container(),
            ]),
          );
        },
      ),
    );
  }

  Widget _buildPopupDialog(BuildContext context, id) {
    return new AlertDialog(
      // title: const Text('Popup example'),
      content: new Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text("Transport Name"),
          TextFormField(
            controller: _transportNameController,
          ),
        ],
      ),
      actions: <Widget>[
        new FlatButton(
          onPressed: () {
            if (_transportNameController.text.isNotEmpty) {
              setTransportIcon(id, _transportNameController.text, "");
            }
          },
          textColor: Theme.of(context).primaryColor,
          child: const Text('Save'),
        ),
        FlatButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          textColor: Theme.of(context).primaryColor,
          child: const Text('Close'),
        ),
      ],
    );
  }

  getAllTransports() async {
    transports.clear();
    await FirebaseFirestore.instance
        .collection("Transports")
        .get()
        .then((value) {
      value.docs.forEach((element) {
        transports.add(element.data());
        log("transports ======>>>>>>>> " + transports.toString());
        setState(() {});
      });
      setState(() {});
    });
  }

  setTransportIcon(id, type, chnageId) async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      transportImage = File(image!.path);
    });
    final storageRef = FirebaseStorage.instance.ref();
    await storageRef
        .child(transportImage!.path.split("/").last.toString())
        .putFile(transportImage!)
        .then((storedImage) async {
      transportImageLink = await storedImage.ref.getDownloadURL();
      setState(() {});
    });
    if (chnageId == "") {
      setNewTransport(id, type);
    } else {
      updateImage(chnageId);
    }
  }

  void setNewTransport(id, type) async {
    await FirebaseFirestore.instance
        .collection("Transports")
        .add({"id": id, "type": type, "image": transportImageLink});
    getAllTransports();
  }

  void updateImage(id) async {
    await FirebaseFirestore.instance
        .collection("Transports")
        .where("id", isEqualTo: id)
        .get()
        .then((value) {
      value.docs.forEach((element) async {
        await FirebaseFirestore.instance
            .collection("Transports")
            .doc(element.id)
            .set({
          "id": element.data()["id"],
          "type": element.data()["type"],
          "image": transportImageLink
        });
        getAllTransports();
      });
    });
  }

  void logout() async {
    await FirebaseAuth.instance.signOut();

    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => LoginScreen(),
        ));
  }

  removeTransportIcon(transport) async {
    await FirebaseFirestore.instance
        .collection("Transports")
        .where("id", isEqualTo: transport)
        .get()
        .then((value) {
      value.docs.forEach((element) async {
        await FirebaseFirestore.instance
            .collection("Transports")
            .doc(element.id)
            .delete();
        /*.set({
          "id": element.data()["id"],
          "type": element.data()["type"],
          "image": transportImageLink
        });*/
        getAllTransports();
      });
    });
  }
}

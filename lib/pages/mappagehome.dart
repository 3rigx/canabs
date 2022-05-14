import 'dart:async';
import 'package:canabs/models/loginusermodel.dart';
import 'package:canabs/services/loginservice.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';

const double CAMERA_ZOOM = 16;
const double CAMERA_TILT = 80;
const double CAMERA_BEARING = 30;
const double PIN_VISIBLE_POSITION = 20;
const double PIN_INVISIBLE_POSITION = -220;

class MapPageHome extends StatefulWidget {
  const MapPageHome({
    Key? key,
  }) : super(key: key);

  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPageHome> {
  final Completer<GoogleMapController> _controller = Completer();

  LocationData? _currentPosition;
  LatLng? currentLocation;
  Location location = Location();
  Marker? marker;
  Circle? circle;
  bool check = false;
  DocumentSnapshot<Map<String, dynamic>>? query;
  List? requestList;
  bool userBadgeSelected = false;
  final Set<Marker> _markers = <Marker>{};

  static const CameraPosition initialLocation = CameraPosition(
    target: LatLng(6.737135, 6.081324),
    zoom: 16,
  );

  @override
  void initState() {
    super.initState();
    LoginService? loginService =
        Provider.of<LoginService>(context, listen: false);
    LoginUserModel? userModel = loginService.loggedInUserModel;
    if (userModel!.userId!.isNotEmpty) {
      _getList(userModel.userId);
    }
    getLoc();
  }

  getLoc() async {
    bool _serviceEnabled;
    PermissionStatus _permissionGranted;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    _currentPosition = await location.getLocation();

    currentLocation =
        LatLng(_currentPosition!.latitude!, _currentPosition!.longitude!);

    location.onLocationChanged.listen((LocationData currentLocationn) {
      setState(() {
        _currentPosition = currentLocationn;
        currentLocation =
            LatLng(_currentPosition!.latitude!, _currentPosition!.longitude!);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    LoginService loginService =
        Provider.of<LoginService>(context, listen: false);

    LoginUserModel userModel = loginService.loggedInUserModel!;
    return Scaffold(
      body: currentLocation == null
          ? const Center(child: CircularProgressIndicator())
          : Stack(
              children: [
                Positioned.fill(
                  child: GoogleMap(
                    mapType: MapType.normal,
                    myLocationButtonEnabled: true,
                    initialCameraPosition: initialLocation,
                    myLocationEnabled: true,
                    mapToolbarEnabled: false,
                    zoomControlsEnabled: false,
                    buildingsEnabled: false,
                    compassEnabled: false,
                    indoorViewEnabled: true,
                    markers: _markers,
                    tiltGesturesEnabled: true,
                    onMapCreated: (GoogleMapController controller) {
                      _controller.complete(controller);

                      location.onLocationChanged.listen((event) {
                        currentLocation =
                            LatLng(event.latitude!, event.longitude!);
                        if (userModel.userId!.isNotEmpty) {
                          addUserLoc(
                            userModel.userId,
                            LatLng(event.latitude!, event.longitude!),
                          );
                        }
                      });
                      controller.animateCamera(
                        CameraUpdate.newCameraPosition(
                          CameraPosition(target: currentLocation!, zoom: 15),
                        ),
                      );
                    },
                  ),
                ),
                (requestList!.isNotEmpty)
                    ? StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection("users")
                            .where('Id', whereIn: requestList!)
                            .snapshots(),
                        builder: (BuildContext context,
                            AsyncSnapshot<QuerySnapshot> snap) {
                          if (snap.connectionState == ConnectionState.waiting &&
                              snap.hasData != true) {
                            return const Center(
                                child: CircularProgressIndicator());
                          }
                          for (var element in snap.data!.docs) {
                            if (element['UserLocation_lat'] != null) {
                              _markers.add(Marker(
                                  markerId: MarkerId(element['UserName']),
                                  infoWindow: InfoWindow(
                                      title: element['UserName'],
                                      snippet: 'Friend'),
                                  position: LatLng(element['UserLocation_lat'],
                                      element['UserLocation_long']),
                                  icon: BitmapDescriptor.defaultMarkerWithHue(
                                      BitmapDescriptor.hueViolet),
                                  onTap: () {
                                    setState(() {
                                      userBadgeSelected = true;
                                    });
                                  }));
                            }
                          }

                          return Container();
                        },
                      )
                    : Container(),
              ],
            ),
    );
  }

  _getList(userid) async {
    query =
        await FirebaseFirestore.instance.collection('users').doc(userid).get();
    if (mounted) {
      setState(() {
        requestList = query!.get('freinds');
        check = true;
      });
    }
  }

  Future<void> addUserLoc(
    String? uesrid,
    LatLng dataa,
  ) {
// Call the user's CollectionReference to add a new user
    CollectionReference users = FirebaseFirestore.instance.collection('users');
    return users.doc(uesrid).update(
      {
        'UserLocation_lat': (dataa.latitude),
        'UserLocation_long': (dataa.longitude)
      },
    );
  }
}

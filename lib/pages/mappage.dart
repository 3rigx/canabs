import 'dart:async';
import 'package:canabs/helpers/appcolors.dart';
import 'package:canabs/models/loginusermodel.dart';
import 'package:canabs/models/subcategory.dart';
import 'package:canabs/services/categoryselectionservice.dart';
import 'package:canabs/services/loginservice.dart';
import 'package:canabs/wudgets/mainappbar.dart';
import 'package:canabs/wudgets/mapbottompill.dart';
import 'package:canabs/wudgets/mapuserbadge.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';

const LatLng SOURCE_LOCATION = LatLng(6.737135, 6.081324);
const double CAMERA_ZOOM = 16;
const double CAMERA_TILT = 80;
const double CAMERA_BEARING = 30;
const double PIN_VISIBLE_POSITION = 20;
const double PIN_INVISIBLE_POSITION = -220;

class MapPage extends StatefulWidget {
  SubCategory? subCategory;

  MapPage({Key? key}) : super(key: key);

  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  final Completer<GoogleMapController> _controller = Completer();

  late BitmapDescriptor? sourceIcon;
  late BitmapDescriptor? destinationIcon;
  final Set<Marker> _markers = <Marker>{};
  double pinPillPosition = PIN_VISIBLE_POSITION;
  LatLng? currentLocation;
  LatLng? destinationLocation;
  bool userBadgeSelected = false;
  DocumentSnapshot<Map<String, dynamic>>? query;
  List? requestList;
  bool check = false;
  List<LatLng> polylineCoordinates = [];

  final Set<Polyline> _polylines = <Polyline>{};
  PolylinePoints polylinePoints = PolylinePoints();

  LocationData? _currentPosition;

  Location location = Location();
  @override
  void initState() {
    super.initState();

    CategorySelectionService catSelection =
        Provider.of<CategorySelectionService>(context, listen: false);
    widget.subCategory = catSelection.selectedSubCategory;
    LoginService? loginService =
        Provider.of<LoginService>(context, listen: false);
    LoginUserModel? userModel = loginService.loggedInUserModel;

    _getList(userModel!.userId);
    getLoc();
    seticon();
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
    destinationLocation = widget.subCategory!.destination;
    location.onLocationChanged.listen((LocationData currentLocationn) {
      setState(() {
        _currentPosition = currentLocationn;
        currentLocation =
            LatLng(_currentPosition!.latitude!, _currentPosition!.longitude!);
      });
    });
  }

  seticon() {
    if (widget.subCategory!.color == AppColors.FACULTYS_color) {
      destinationIcon =
          BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed);
    } else if (widget.subCategory!.color == AppColors.HOSTELS_color) {
      destinationIcon =
          BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueCyan);
    } else if (widget.subCategory!.color == AppColors.EATRY_color) {
      destinationIcon =
          BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue);
    } else if (widget.subCategory!.color == AppColors.ADMIN_color) {
      destinationIcon =
          BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueViolet);
    } else if (widget.subCategory!.color == AppColors.LIBRARY_color) {
      destinationIcon =
          BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueYellow);
    } else if (widget.subCategory!.color == AppColors.CHURCH_color) {
      destinationIcon =
          BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange);
    }

    // widget.subCategory!.,
  }

  void setSourceAndDestinationMarkerIcons(BuildContext context) async {
    sourceIcon = await BitmapDescriptor.fromAssetImage(
        const ImageConfiguration(
          devicePixelRatio: 2.0,
        ),
        'assets/images/source_pin.png');

    destinationIcon = await BitmapDescriptor.fromAssetImage(
        const ImageConfiguration(devicePixelRatio: 2.0),
        'assets/images/destination_pin_.png');
  }

  @override
  Widget build(BuildContext context) {
    CategorySelectionService catSelection =
        Provider.of<CategorySelectionService>(context, listen: false);
    widget.subCategory = catSelection.selectedSubCategory;

    LoginService loginService =
        Provider.of<LoginService>(context, listen: false);

    LoginUserModel userModel = loginService.loggedInUserModel!;

    setSourceAndDestinationMarkerIcons(context);

    CameraPosition initialCameraPosition = const CameraPosition(
        zoom: CAMERA_ZOOM,
        tilt: CAMERA_TILT,
        bearing: CAMERA_BEARING,
        target: SOURCE_LOCATION);

    return !check
        ? const Center(child: CircularProgressIndicator())
        : Scaffold(
            body: currentLocation == null
                ? const Center(child: CircularProgressIndicator())
                : Stack(
                    children: [
                      Positioned.fill(
                        child: GoogleMap(
                          myLocationButtonEnabled: false,
                          myLocationEnabled: false,
                          zoomControlsEnabled: false,
                          compassEnabled: false,
                          tiltGesturesEnabled: false,
                          mapToolbarEnabled: false,
                          markers: _markers,
                          polylines: _polylines,
                          mapType: MapType.normal,
                          initialCameraPosition: initialCameraPosition,
                          onTap: (LatLng loc) {
                            setState(() {
                              pinPillPosition = PIN_INVISIBLE_POSITION;
                              userBadgeSelected = false;
                            });
                          },
                          onMapCreated: (GoogleMapController controller) {
                            _controller.complete(controller);

                            showPinsOnMap();
                            if (mounted) {
                              location.onLocationChanged.listen((event) {
                                currentLocation =
                                    LatLng(event.latitude!, event.longitude!);
                                controller.animateCamera(
                                  CameraUpdate.newCameraPosition(
                                    CameraPosition(
                                        target: currentLocation!, zoom: 15),
                                  ),
                                );
                                showPinsOnMap();
                                setPolylines();
                                addUserLoc(
                                  userModel.userId,
                                  LatLng(event.latitude!, event.longitude!),
                                );
                              });
                            }

                            controller.animateCamera(
                              CameraUpdate.newCameraPosition(
                                CameraPosition(
                                    target: currentLocation!, zoom: 15),
                              ),
                            );
                          },
                        ),
                      ),
                      Positioned(
                        top: 100,
                        left: 0,
                        right: 0,
                        child: MapUserBadge(
                          isSelected: userBadgeSelected,
                        ),
                      ),
                      AnimatedPositioned(
                          duration: const Duration(milliseconds: 500),
                          curve: Curves.easeInOut,
                          left: 0,
                          right: 0,
                          bottom: pinPillPosition,
                          child: MapBttomPill()),
                      Positioned(
                          top: 0,
                          left: 0,
                          right: 0,
                          child: MainAppBar(
                            showProfilePic: false,
                          )),
                      (requestList!.isNotEmpty)
                          ? StreamBuilder<QuerySnapshot>(
                              stream: FirebaseFirestore.instance
                                  .collection("users")
                                  .where('Id', whereIn: requestList!)
                                  .snapshots(),
                              builder: (BuildContext context,
                                  AsyncSnapshot<QuerySnapshot> snap) {
                                if (snap.connectionState ==
                                        ConnectionState.waiting &&
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
                                        position: LatLng(
                                            element['UserLocation_lat'],
                                            element['UserLocation_long']),
                                        icon: BitmapDescriptor
                                            .defaultMarkerWithHue(
                                                BitmapDescriptor.hueViolet),
                                        onTap: () {
                                          if (mounted) {
                                            setState(() {
                                              userBadgeSelected = true;
                                            });
                                          }
                                        }));
                                  }
                                }

                                return Container();
                              },
                            )
                          : Container(),
                    ],
                  ));
  }

  void showPinsOnMap() async {
    setState(() {
      _markers.add(Marker(
          markerId: const MarkerId('sourcePin'),
          position:
              LatLng(currentLocation!.latitude, currentLocation!.longitude),
          icon:
              BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
          onTap: () {
            setState(() {
              userBadgeSelected = true;
            });
          }));
      _markers.add(Marker(
          markerId: const MarkerId('destinationPin'),
          infoWindow: const InfoWindow(title: 'Destination'),
          position: destinationLocation!,
          icon: BitmapDescriptor.defaultMarkerWithHue(
              BitmapDescriptor.hueBlue), // widget.subCategory!.,
          onTap: () {
            setState(() {
              pinPillPosition = PIN_VISIBLE_POSITION;
            });
          }));
    });
  }

  _getList(userid) async {
    query =
        await FirebaseFirestore.instance.collection('users').doc(userid).get();

    setState(() {
      requestList = query!.get('freinds');
      check = true;
    });
  }

  void setPolylines() async {
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
        "AIzaSyDFdUJyVe0y3-iqw6Ht32PaIa0MHvlAmtY",
        PointLatLng(
          currentLocation!.latitude,
          currentLocation!.longitude,
        ),
        PointLatLng(
          destinationLocation!.latitude,
          destinationLocation!.longitude,
        ),
        travelMode: TravelMode.driving);

    if (result.status == 'OK') {
      for (var point in result.points) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      }

      if (mounted) {
        setState(() {
          _polylines.add(Polyline(
              width: 10,
              polylineId: const PolylineId('polyLine'),
              color: const Color(0xFF08A5CB),
              points: polylineCoordinates));
        });
      }
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

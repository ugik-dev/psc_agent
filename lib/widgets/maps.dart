// maps.dart

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Maps extends StatefulWidget {
  final LatLng initialPosition;

  Maps({required this.initialPosition, required LatLng livePosition});
  @override
  _MapsState createState() => _MapsState();
}

class _MapsState extends State<Maps> {
  late GoogleMapController _controller;
  late LatLng _initialCameraPosition;
  late LatLng _livePosition;
  @override
  void initState() {
    super.initState();
    _initialCameraPosition = widget.initialPosition;
  }

  // _MapsState(this._initialCameraPosition);
  @override
  Widget build(BuildContext context) {
    return Container(
      // width: ScreenUtil().setWidth(200.0),
      child: GoogleMap(
        onMapCreated: (controller) {
          _controller = controller;
        },
        initialCameraPosition: CameraPosition(
          target: _initialCameraPosition,
          zoom: 5.0, // Sesuaikan level zoom sesuai kebutuhan Anda
        ),
        markers: <Marker>{
          Marker(
            markerId: MarkerId("liveLocation"),
            position: _initialCameraPosition,
            icon: BitmapDescriptor.defaultMarker,
            infoWindow: InfoWindow(title: "Live Location"),
          ),
        },
      ),
    );
  }
}

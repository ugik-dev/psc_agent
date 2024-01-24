import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';
import 'package:psc_119_agent/pages/main_user.dart';

class LoadMaps extends StatefulWidget {
  @override
  _LoadMapsState createState() => _LoadMapsState();
}

class _LoadMapsState extends State<LoadMaps> {
  @override
  Widget build(BuildContext context) {
    return Consumer<LiveLocationProvider>(
      builder: (context, liveLocationProvider, _) {
        LatLng livePosition = (liveLocationProvider.liveLocation != null)
            ? LatLng(
                liveLocationProvider.liveLocation!.latitude!,
                liveLocationProvider.liveLocation!.longitude!,
              )
            : LatLng(37.43296265331129, -122.08832357078792);

        return GoogleMap(
          initialCameraPosition: CameraPosition(
            target: livePosition,
            zoom: 17.0,
          ),
          markers: <Marker>{
            Marker(
              markerId: MarkerId("liveLocation"),
              position: livePosition,
              icon: BitmapDescriptor.defaultMarker,
              infoWindow: InfoWindow(title: "Live Location"),
            ),
          },
        );
      },
    );
  }
}

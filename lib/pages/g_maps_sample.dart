import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart';
import 'package:location/location.dart';
import 'package:psc_119_agent/config.dart';
import 'package:psc_119_agent/main.dart';
import 'package:psc_119_agent/utils/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert' as convert;

class MapSample extends StatefulWidget {
  const MapSample({Key? key}) : super(key: key);

  @override
  State<MapSample> createState() => MapSampleState();
}

class MapSampleState extends State<MapSample> {
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();
  String nama = 'GUEST';
  String police_number = 'GUEST';
  var token = null;

  @override
  void initState() {
    super.initState();
    _getLocation();
  }

  Future<void> _getLocation() async {
    await cekToken(); // Call cekToken to fetch user data
    try {
      var location = await Location().getLocation();
      setState(() {
        _currentLocation = location;
      });
      _startLocationSubscription();
    } catch (e) {
      print("Error getting location: $e");
    }
  }

  Future<void> cekToken() async {
    final prefs = await SharedPreferences.getInstance();
    final String? namas = prefs.getString('nama');
    final String? police_numbers = prefs.getString('police_number');
    final String? tokens = prefs.getString('token');
    debugPrint(namas);
    setState(() {
      nama = namas ?? 'GUEST';
      police_number = police_numbers ?? 'GUEST';
      token = tokens ?? null;
    });
  }

  LocationData? _currentLocation;
  late StreamSubscription<LocationData> _locationSubscription;

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(106.126210, -1.860675),
    zoom: 14.4746,
  );

  @override
  void dispose() {
    _locationSubscription.cancel();
    super.dispose();
  }

  void _startLocationSubscription() {
    _locationSubscription =
        Location().onLocationChanged.listen((LocationData location) {
      setState(() {
        _currentLocation = location;
      });
      _updateCameraPosition();
      _sendLiveLocationToApi();
    });
  }

  void _sendLiveLocationToApi() async {
    if (_currentLocation != null) {
      if (token != null) {
        final GoogleMapController controller = await _controller.future;
        final response = await post(
          Uri.parse(
            AppConfig.base_url_api + '/api/send-live-location',
          ),
          headers: <String, String>{
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
          body: convert.jsonEncode({
            'latitude': _currentLocation!.latitude!,
            'longitude': _currentLocation!.longitude!,
          }),
        );

        if (response.statusCode == 200) {
          // Tanggapi sesuai kebutuhan Anda
          var jsonResponse =
              convert.jsonDecode(response.body) as Map<String, dynamic>;
          var message = jsonResponse['message'];
          print('Response from API: $jsonResponse');
        } else {
          // Tanggapi kesalahan dari API
          print(
              'update api latitude ${_currentLocation!.latitude!}, longitude : ${_currentLocation!.longitude!},');
          print(
              'Error sending live location to API. Status code: ${response.statusCode}');
        }
      }
    }
  }

  void _updateCameraPosition() async {
    if (_currentLocation != null) {
      final GoogleMapController controller = await _controller.future;
      controller.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: LatLng(
              _currentLocation!.latitude!,
              _currentLocation!.longitude!,
            ),
            tilt: 59.440717697143555,
            zoom: 17.0,
          ),
        ),
      );
    }
  }

  void logout() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.clear();
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => const MainPage()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Constants.primaryColor,
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.only(
              left: 6.0,
              right: 6.0,
              top: 65.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    GestureDetector(
                      onTap: logout,
                      child: const Icon(
                        Icons.keyboard_backspace_rounded,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(
                      width: 20.0,
                    ),
                    Text(
                      "Live Location",
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                    )
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 10.0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 20.0),
                child: RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: "$nama,\n",
                        style: Theme.of(context).textTheme.headline6?.copyWith(
                              color: Colors.white,
                            ),
                      ),
                      TextSpan(
                        text: police_number,
                        style: Theme.of(context).textTheme.headline6?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                      )
                    ],
                  ),
                ),
              ),
              Image.asset(
                "assets/images/dp.png",
              )
            ],
          ),
          Expanded(
            child: GoogleMap(
              mapType: MapType.hybrid,
              initialCameraPosition: _kGooglePlex,
              onMapCreated: (GoogleMapController controller) {
                _controller.complete(controller);
              },
              markers: <Marker>{
                Marker(
                  markerId: MarkerId("liveLocation"),
                  position: _currentLocation != null
                      ? LatLng(
                          _currentLocation!.latitude!,
                          _currentLocation!.longitude!,
                        )
                      : _kGooglePlex.target,
                  icon: BitmapDescriptor.defaultMarker,
                  infoWindow: InfoWindow(title: police_number),
                ),
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _goToCurrentLocation,
        label: const Text('Focus'),
        icon: const Icon(Icons.center_focus_strong),
      ),
    );
  }

  Future<void> _goToCurrentLocation() async {
    _updateCameraPosition();
  }
}

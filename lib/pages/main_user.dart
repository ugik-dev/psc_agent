import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';
import 'package:psc_119_agent/user/profile.dart';
import 'package:psc_119_agent/pages/load_maps.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/constants.dart';
import 'dart:async';

class MainUser extends StatefulWidget {
  @override
  _MainUserState createState() => _MainUserState();
}

class _MainUserState extends State<MainUser> {
  int currentPage = 0;
  List<Widget> pages = [
    LoadMaps(),
    LoadMaps(),
    LoadMaps(),
    const Profile(),
  ];

  @override
  Widget build(BuildContext context) {
    return Provider(
      create: (_) => LiveLocationProvider(),
      child: Scaffold(
        bottomNavigationBar: CurvedNavigationBar(
          backgroundColor: Constants.scaffoldBackgroundColor,
          buttonBackgroundColor: Constants.primaryColor,
          items: [
            Icon(
              Icons.home,
              size: 30.0,
              color: currentPage == 0 ? Colors.white : Color(0xFFC8C9CB),
            ),
            Icon(
              Icons.location_on_rounded,
              size: 30.0,
              color: currentPage == 1 ? Colors.white : Color(0xFFC8C9CB),
            ),
            Icon(
              Icons.phone,
              size: 30.0,
              color: currentPage == 2 ? Colors.white : Color(0xFFC8C9CB),
            ),
            Icon(
              Icons.chat_outlined,
              size: 30.0,
              color: currentPage == 3 ? Colors.white : Color(0xFFC8C9CB),
            ),
            Icon(
              Icons.person,
              size: 30.0,
              color: currentPage == 4 ? Colors.white : Color(0xFFC8C9CB),
            ),
          ],
          onTap: (index) {
            setState(() {
              currentPage = index;
            });
          },
        ),
        backgroundColor: Constants.primaryColor,
        body: pages[currentPage],
      ),
    );
  }

  Future<void> cekToken() async {
    final prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('token');
  }
}

class LiveLocationProvider extends ChangeNotifier {
  LocationData? _liveLocation;

  LocationData? get liveLocation => _liveLocation;

  void updateLiveLocation(LocationData location) {
    _liveLocation = location;
    notifyListeners();
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:psc_119_agent/pages/g_maps_sample.dart';
import 'package:psc_119_agent/pages/home.dart';
// import 'home_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: Size(375, 812),
      builder: (context, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(primarySwatch: Colors.blue),
          home: const MainPage(),
        );
      },
    );
  }
  // return MaterialApp(
  //   debugShowCheckedModeBanner: false,
  //   theme: ThemeData(primarySwatch: Colors.blue),
  //   home: const MainPage(),
  // );
}

// Route<dynamic> _onGenerateRoute(RouteSettings settings) {
//   switch (settings.name) {
//     case "/":
//       return MaterialPageRoute(builder: (BuildContext context) {
//         return Home();
//       });
//     case "/login":
//       return MaterialPageRoute(builder: (BuildContext context) {
//         return Login();
//       });
//     case "/dashboard":
//       return MaterialPageRoute(builder: (BuildContext context) {
//         return Dashboard();
//       });
//     case "/single-order":
//       return MaterialPageRoute(builder: (BuildContext context) {
//         return SingleOrder();
//       });
//     default:
//       return MaterialPageRoute(builder: (BuildContext context) {
//         return Home();
//       });
//   }
// }

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  bool visibilityPass = false;
  Future<void> cekToken() async {
    // super._cekToken();

    // final SharedPreferences prefs = await _prefs;
    final prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('token');

    debugPrint('token running cek token');
    if (token != null) {
      debugPrint('ada tokne $token');
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            // builder: (context) => OriginCam(),
            builder: (context) => MapSample(),
          ));
    } else {
      debugPrint('tidak ada token');
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: cekToken(),
        builder: (context, _) {
          return Home();
        });
    // return  Home();
  }
}

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:psc_119_agent/utils/config.dart';
import 'package:psc_119_agent/pages/g_maps_sample.dart';
import 'package:psc_119_agent/pages/home.dart';
import 'package:psc_119_agent/utils/constants.dart';
import 'package:psc_119_agent/widgets/app_button.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert' as convert;

import 'package:http/http.dart' as http;

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  // const LoginPage({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  var idLoginController = TextEditingController();
  var keyLoginController = TextEditingController();
  bool isLoading = false;

  bool visibilityPass = false;

  @override
  Widget build(BuildContext context) {
    debugPrint('login page');
    return Scaffold(
      backgroundColor: Constants.primaryColor,
      body: SafeArea(
        bottom: false,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Positioned(
              right: 0.0,
              top: -20.0,
              child: Opacity(
                opacity: 0.3,
                child: Image.asset(
                  "assets/images/washing_machine_illustration.png",
                ),
              ),
            ),
            SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 15.0,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.pushReplacement(context,
                                MaterialPageRoute(
                                    builder: (BuildContext context) {
                              return Home();
                            }));
                          },
                          child: const Icon(
                            Icons.keyboard_backspace_rounded,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(
                          height: 20.0,
                        ),
                        Text(
                          "Masukkan Data Login",
                          style:
                              Theme.of(context).textTheme.headline6?.copyWith(
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 40.0,
                  ),
                  Flexible(
                    child: Container(
                      width: double.infinity,
                      constraints: BoxConstraints(
                        minHeight: MediaQuery.of(context).size.height - 180.0,
                      ),
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(30.0),
                          topRight: Radius.circular(30.0),
                        ),
                        color: Colors.white,
                      ),
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // Lets make a generic input widget
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text("ID"),
                              const SizedBox(height: 5.0),
                              Container(
                                height: ScreenUtil().setHeight(48.0),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                child: TextFormField(
                                  controller: idLoginController,
                                  obscureText: false,
                                  decoration: InputDecoration(
                                    prefixIcon: const Icon(
                                        Icons.account_circle_outlined),
                                    enabledBorder: const OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Color.fromRGBO(74, 77, 84, 0.2),
                                      ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Constants.primaryColor,
                                      ),
                                    ),
                                    hintText: "ID",
                                    hintStyle: const TextStyle(
                                      fontSize: 14.0,
                                      color: Color.fromRGBO(105, 108, 121, 0.7),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),

                          const SizedBox(
                            height: 25.0,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text("KEY"),
                              const SizedBox(height: 5.0),
                              Container(
                                height: ScreenUtil().setHeight(48.0),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                child: TextFormField(
                                  controller: keyLoginController,
                                  decoration: InputDecoration(
                                    prefixIcon: const Icon(Icons.contact_phone),
                                    enabledBorder: const OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Color.fromRGBO(74, 77, 84, 0.2),
                                      ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Constants.primaryColor,
                                      ),
                                    ),
                                    hintText: "KEY",
                                    hintStyle: const TextStyle(
                                      fontSize: 14.0,
                                      color: Color.fromRGBO(105, 108, 121, 0.7),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),

                          const SizedBox(
                            height: 20.0,
                          ),

                          (!isLoading)
                              ? AppButton(
                                  type: ButtonType.PRIMARY,
                                  text: "Masuk",
                                  onPressed: _login,
                                )
                              : const SizedBox(
                                  height: 32,
                                  width: 32,
                                  child: CircularProgressIndicator(
                                    color: Colors.blue,
                                    strokeWidth: 3,
                                  ),
                                ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _login() async {
    setState(() {
      isLoading = true;
    });
    debugPrint('login func');
    // debugPrint(_controller.nameController.text);
    var key_login = keyLoginController.text;
    var id_login = idLoginController.text;
    print('id sekarang: ${id_login}.');
    print('key sekarang: ${key_login}.');
    // var url = Uri.http(AppConfig.base_url_api, '/api/login-live-location');
    var response = await http.post(
      Uri.parse(
        AppConfig.base_url_api + '/api/login-live-location',
      ),
      body: {'id_login': id_login, 'key_login': key_login},
      headers: <String, String>{
        'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8',
      },
    );
    // var url = Uri.parse('http://192.168.18.83:8000');
    // // Await the http get response, then decode the json-formatted response.
    // var response = await http
    //     .post(url, body: {'id_login': id_login, 'key_login': key_login});
    setState(() {
      isLoading = false;
    });
    print('Request  with status: ${response.statusCode}.');
    if (response.statusCode == 200) {
      var jsonResponse =
          convert.jsonDecode(response.body) as Map<String, dynamic>;
      var message = jsonResponse['message'];
      String resToken = jsonResponse['data']['token'];
      String resName = jsonResponse['data']['name'];
      String nameJenis = jsonResponse['data']['name_jenis'];
      int resId = int.tryParse(jsonResponse['data']['id'].toString()) ?? 0;
      int refLiveLocationId = int.tryParse(
              jsonResponse['data']['ref_live_location_id'].toString()) ??
          0;
      String policeNumber = jsonResponse['data']['police_number'];
      String description = jsonResponse['data']['description'];
      int idLogin =
          int.tryParse(jsonResponse['data']['id_login'].toString()) ?? 0;
      print('res token sekarang: $resToken.');
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('nama', resName);
      await prefs.setString('name_jenis', nameJenis);
      await prefs.setInt('location_id', resId); // Perubahan di sini
      await prefs.setString('token', resToken);
      await prefs.setInt('id_login', idLogin); // Perubahan di sini
      await prefs.setInt(
          'ref_live_location_id', refLiveLocationId); // Perubahan di sini
      await prefs.setString('police_number', policeNumber);
      await prefs.setString('description', description);

      print(prefs.getString('token'));
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => const MapSample()));
      print('Number of books about http: $message.');
    } else {
      try {
        var errorMessage = json.decode(response.body)['message'];
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("$errorMessage")));
        print('Error message: $errorMessage');
      } catch (e) {
        // Handle JSON decoding error, if any
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text("Terjadi kesalahan ")));
        print('Unable to parse error message.');
      }
    }
  }
}

import 'package:flutter/material.dart';
import 'package:psc_119_agent/pages/login.dart';
import 'package:psc_119_agent/utils/constants.dart';
import 'package:psc_119_agent/widgets/app_button.dart';

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Constants.primaryColor,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            flex: 3,
            child: Stack(
              alignment: Alignment.bottomCenter,
              children: [
                Positioned(
                  top: 100.0,
                  left: 0.0,
                  right: 0.0,
                  child: Container(
                    height: 250.0,
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image:
                            AssetImage("assets/images/onboarding_image_3.png"),
                      ),
                    ),
                  ),
                ),
                // Container(
                //   child: Padding(
                //     padding: EdgeInsets.all(40.0),
                //     child: Image.asset(
                //       "assets/images/ima.png",
                //       scale: 1.1,
                //     ),
                //   ),
                // ),
              ],
            ),
          ),
          Expanded(
            flex: 2,
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 20.0,
                vertical: 25.0,
              ),
              decoration: BoxDecoration(
                color: Constants.scaffoldBackgroundColor,
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(30.0),
                  topLeft: Radius.circular(30.0),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20.0),
                  Text(
                    "Selamat datang di\nPSC 119 SS Bangka!\naplikasi ini merupakan aplikasi livelocation",
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: const Color.fromRGBO(19, 22, 33, 1),
                        ),
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                  const SizedBox(
                    height: 40.0,
                  ),
                  // Let's create a generic button widget
                  AppButton(
                    text: "Masuk",
                    type: ButtonType.PLAIN,
                    onPressed: () {
                      Navigator.pushReplacement(context,
                          MaterialPageRoute(builder: (BuildContext context) {
                        return const Login();
                      }));
                    },
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

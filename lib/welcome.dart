
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:schools/config/routing.dart';
import 'package:schools/home.dart';
import 'package:schools/login.dart';
import 'package:schools/shared_components/colors.dart';

class WelcomePage extends StatefulWidget {
  static String tag = 'login-page';

  @override
  State<StatefulWidget> createState() {
    return _WelcomePageState();
  }
}

class _WelcomePageState extends State<WelcomePage> {

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: WillPopScope(
        onWillPop: () async {
          if (kDebugMode) {
            print("asd");
          }
          return false;
        },
        child: Scaffold(
          backgroundColor: Colors.white,
          body: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.4,
                  width: MediaQuery.of(context).size.width,
                  child:  const Image(image: AssetImage('assets/logo.png')),
                ),
                const SizedBox(
                  height: 30,
                ),
                Form(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[

                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              height: 70,
                              margin: const EdgeInsets.symmetric(
                                  vertical: 16.0, horizontal: 30),
                              decoration: BoxDecoration(
                                color: Colors_().primary,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              width: MediaQuery.of(context).size.width - 80,
                              child: ButtonTheme(
                                height: 50,
                                child: TextButton(
                                  onPressed: () async {
                                    Navigator.of(context).push(Routing().createRoute(LoginPage()));

                                  },
                                  child:const Text('Login',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20,
                                        color: Colors.white
                                      ))
                                ),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              height: 70,
                              margin: const EdgeInsets.symmetric(
                                  vertical: 16.0, horizontal: 30),
                              decoration: BoxDecoration(
                                color: Colors_().primary,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              width: MediaQuery.of(context).size.width - 80,
                              child: ButtonTheme(
                                height: 50,
                                child: TextButton(
                                  onPressed: () async {
                                      Navigator.of(context).push(MaterialPageRoute(builder: (c)=>const MyHomePage(title: '')));

                                  },
                                  child:const Text('Continue as a guest',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20,
                                        color: Colors.white
                                      ))
                                ),
                              ),
                            ),
                          ],
                        ),

                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:schools/config/routing.dart';
import 'package:schools/home.dart';
import 'package:schools/shared_components/colors.dart';
import 'package:schools/shared_components/style.dart';
import 'package:sweet_snackbar/sweet_snackbar.dart';
import 'package:sweet_snackbar/top_snackbar.dart';

class RegisterPage extends StatefulWidget {
  static String tag = 'login-page';

  @override
  State<StatefulWidget> createState() {
    return _RegisterPageState();
  }
}

class _RegisterPageState extends State<RegisterPage> {
  final GlobalKey<FormState> _key = GlobalKey();
  bool _obscureText = true;
  int textLength = 0;
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    confirmPasswordController.dispose();
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: WillPopScope(
        onWillPop: () async {
          if (kDebugMode) {
            print("asd");
          }
          return true;
        },
        child: Scaffold(
          appBar: AppBar(
            foregroundColor: Colors_().primary,
            backgroundColor: Colors.white,
            elevation: 0,
          ),
          backgroundColor: Colors.white,
          body: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.3,
                  width: MediaQuery.of(context).size.width,
                  child: const Image(
                    image: AssetImage('assets/logo.png'),
                    width: 120,
                  ),
                ),
                Form(
                  key: _key,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          children: [
                            const SizedBox(width: 18),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Hello there!",
                                    style:
                                        Theme.of(context).textTheme.bodyLarge),
                                const SizedBox(height: 16),
                                Text("Join us!",
                                    style:
                                        Theme.of(context).textTheme.bodyLarge),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 20.0),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: MediaQuery.of(context).size.width - 40,
                              child: TextFormField(
                                textInputAction: TextInputAction.next,
                                controller: usernameController,
                                onChanged: (value) {
                                  setState(() {
                                    textLength = value.length;
                                  });
                                },
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter Email';
                                  }
                                  return null;
                                },
                                keyboardType: TextInputType.emailAddress,
                                autofocus: false,
                                decoration: InputDecoration(
                                  suffixIcon: textLength > 0
                                      ? Icon(
                                          Icons.check_circle,
                                          color: Colors_().primary,
                                        )
                                      : const Icon(
                                          Icons.info_outline,
                                          color: Colors.grey,
                                        ),
                                  hintText: 'Email',
                                  hintStyle: MyStyles().hintText,
                                  contentPadding: const EdgeInsets.fromLTRB(
                                      20.0, 15.0, 20.0, 15.0),
                                  border: OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.circular(12.0)),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12.0),
                                    borderSide: const BorderSide(
                                        color: Colors.grey, width: 1.0),
                                  ),
                                ),
                                onSaved: (String? value) {},
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20.0),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: MediaQuery.of(context).size.width - 40,
                              child: TextFormField(
                                  textInputAction: TextInputAction.next,
                                  controller: passwordController,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter Password';
                                    }
                                    return null;
                                  },
                                  autofocus: false,
                                  obscureText: _obscureText,
                                  keyboardType: TextInputType.text,
                                  decoration: InputDecoration(
                                    hintStyle: MyStyles().hintText,
                                    hintText: 'Password',
                                    contentPadding: const EdgeInsets.fromLTRB(
                                        20.0, 10.0, 20.0, 10.0),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12.0),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12.0),
                                      borderSide: const BorderSide(
                                          color: Colors.grey, width: 1.0),
                                    ),
                                    suffixIcon: GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          _obscureText = !_obscureText;
                                        });
                                      },
                                      child: Icon(
                                        _obscureText
                                            ? Icons.visibility
                                            : Icons.visibility_off,
                                        semanticLabel: _obscureText
                                            ? 'show password'
                                            : 'hide password',
                                      ),
                                    ),
                                  ),
                                  onSaved: (String? value) {}),
                            ),
                          ],
                        ),
                        const SizedBox(height: 15.0),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: MediaQuery.of(context).size.width - 40,
                              child: TextFormField(
                                  textInputAction: TextInputAction.done,
                                  controller: confirmPasswordController,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter Password';
                                    } else if (value.toString() !=
                                        passwordController.text) {
                                      return 'Please confirm password correctly';
                                    }
                                    return null;
                                  },
                                  autofocus: false,
                                  obscureText: _obscureText,
                                  keyboardType: TextInputType.text,
                                  decoration: InputDecoration(
                                    hintStyle: MyStyles().hintText,
                                    hintText: 'Confirm Password',
                                    contentPadding: const EdgeInsets.fromLTRB(
                                        20.0, 10.0, 20.0, 10.0),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12.0),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12.0),
                                      borderSide: const BorderSide(
                                          color: Colors.grey, width: 1.0),
                                    ),
                                    suffixIcon: GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          _obscureText = !_obscureText;
                                        });
                                      },
                                      child: Icon(
                                        _obscureText
                                            ? Icons.visibility
                                            : Icons.visibility_off,
                                        semanticLabel: _obscureText
                                            ? 'show password'
                                            : 'hide password',
                                      ),
                                    ),
                                  ),
                                  onSaved: (String? value) {}),
                            ),
                          ],
                        ),
                        const SizedBox(height: 15.0),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            !loading
                                ? Container(
                                    margin: const EdgeInsets.symmetric(
                                        vertical: 16.0, horizontal: 30),
                                    decoration: BoxDecoration(
                                      color: Colors_().primary,
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    width:
                                        MediaQuery.of(context).size.width - 80,
                                    child: ButtonTheme(
                                      height: 50,
                                      child: TextButton(
                                          onPressed: () async {
                                            if (_key.currentState!.validate()) {
                                              setState(() {
                                                loading = true;
                                              });
                                              String email =
                                                  usernameController.text;
                                              String password =
                                                  confirmPasswordController
                                                      .text;
                                              FirebaseAuth.instance
                                                  .createUserWithEmailAndPassword(
                                                      email: email,
                                                      password: password)
                                                  .then((value) {
                                                showTopSnackBar(
                                                    context,
                                                    const CustomSnackBar
                                                            .success(
                                                        message:
                                                            'Account created successfully'));
                                                Navigator.of(context).push(Routing().createRoute(const MyHomePage(title: '')));
                                                setState(() {
                                                  loading = false;
                                                });
                                              }).onError((error, stackTrace) {
                                                setState(() {
                                                  loading = false;
                                                });
                                                showTopSnackBar(
                                                    context,
                                                    const CustomSnackBar.error(
                                                        message:
                                                            'This email is already used by another account,\ntry another one'));
                                              });
                                            }
                                          },
                                          child: const Text('Create account',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white))),
                                    ),
                                  )
                                : CircularProgressIndicator(
                                    color: Colors.pink[900],
                                  ),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text("Already have an account? "),
                            InkWell(
                              child: Text(
                                "Login instead",
                                style: TextStyle(
                                    color: Colors_().primary,
                                    fontWeight: FontWeight.bold),
                              ),
                              onTap: () {
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 30,
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

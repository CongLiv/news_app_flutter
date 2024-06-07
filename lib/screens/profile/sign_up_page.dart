import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:news_app_flutter_demo/helpers/firebase_account.dart';
import 'package:news_app_flutter_demo/screens/article/homepage.dart';

import '../../helpers/check_connection.dart';
import '../../helpers/const_data.dart';
import '../../widgets/title_name.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  _SignUpPage createState() => _SignUpPage();
}

class _SignUpPage extends State<SignUpPage> {
  String email = '';
  String password = '';
  String confirmPassword = '';
  bool isValid = true;

  String _emailError = 'Email is invalid! e.x: abc@example.com';
  String _passwordLengthError = 'Password must be at least 6 characters';
  String _passwordMatchError = 'Password does not match';
  String _emailExistError = 'Email already exists';

  String _noti0 = '';
  String _noti1 = '';
  String _noti2 = '';

  bool _hiddenPassword1 = true;
  bool _hiddenPassword2 = true;

  void _togglePasswordVisibility1() {
    setState(() {
      _hiddenPassword1 = !_hiddenPassword1;
    });
  }

  void _togglePasswordVisibility2() {
    setState(() {
      _hiddenPassword2 = !_hiddenPassword2;
    });
  }

  void _handleSignUp() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(redViettel),
          ),
        );
      },
    );

    await FirebaseAccount.signUp(
      email: email,
      password: password,
      onSuccess: () {
        Navigator.pop(context);
        Fluttertoast.showToast(
          msg: 'Sign up successfully',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: redViettel,
          textColor: Colors.white,
          fontSize: 16.0,
        );
        Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation1, animation2) => Homepage(),
          ),
        );
      },
      onError: (e) async {
        Navigator.pop(context);
        if (!await CheckConnection.isInternet()) {
          Fluttertoast.showToast(
            msg: 'No internet connection',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
          );
        } else if (e.toString().contains('email-already-in-use')) {
          setState(() {
            _noti0 = _emailExistError;
            isValid = false;
          });
        } else {
          Fluttertoast.showToast(
            msg: 'Sign up failed',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
          );
        }
      },
    );
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
            image: Theme.of(context).brightness == Brightness.dark
                ? AssetImage('assets/images/background_dark.png')
                : AssetImage('assets/images/background.jpg'),
            fit: BoxFit.cover),
      ),
      child: Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(color: redViettel),
          backgroundColor: Theme.of(context).colorScheme.secondary,
          elevation: 0,
          centerTitle: true,
          title: TitleName(text: appNameLogo),
        ),
        backgroundColor: Colors.transparent,
        body: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.only(top: 70),
                    child: Text(
                      'Sign Up Account',
                      style: TextStyle(
                          color: redViettel,
                          fontSize: 33,
                          fontFamily: 'FS PFBeauSansPro',
                          fontWeight: FontWeight.w500,
                          letterSpacing: 2),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(top: 50),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          margin: EdgeInsets.only(left: 35, right: 35),
                          child: Column(
                            children: [
                              TextField(
                                onChanged: (value) {
                                  email = value;
                                },
                                keyboardType: TextInputType.emailAddress,
                                cursorColor:
                                    Theme.of(context).colorScheme.onSurface,
                                style: TextStyle(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSurface),
                                decoration: InputDecoration(
                                  fillColor:
                                      Theme.of(context).colorScheme.primary,
                                  filled: true,
                                  hintText: "Email",
                                  hintStyle: TextStyle(
                                    fontFamily: 'FS PFBeauSansPro',
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSurface,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 20,
                                child: Text(
                                  _noti0,
                                  style: TextStyle(
                                    color: Theme.of(context).colorScheme.error,
                                    fontFamily: 'FS PFBeauSansPro',
                                  ),
                                ),
                              ),
                              TextField(
                                onChanged: (value) {
                                  password = value;
                                },
                                cursorColor:
                                    Theme.of(context).colorScheme.onSurface,
                                style: TextStyle(),
                                obscureText: _hiddenPassword1,
                                decoration: InputDecoration(
                                  fillColor:
                                      Theme.of(context).colorScheme.primary,
                                  filled: true,
                                  hintText: "Password",
                                  hintStyle: TextStyle(
                                    fontFamily: 'FS PFBeauSansPro',
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSurface,
                                    ),
                                  ),
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      _hiddenPassword1
                                          ? Icons.visibility_off
                                          : Icons.visibility,
                                    ),
                                    onPressed: _togglePasswordVisibility1,
                                  ),
                                ),
                              ),
                              SizedBox(
                                  height: 20,
                                  child: Text(
                                    _noti1,
                                    style: TextStyle(
                                      color:
                                          Theme.of(context).colorScheme.error,
                                      fontFamily: 'FS PFBeauSansPro',
                                    ),
                                  )),
                              TextField(
                                onChanged: (value) {
                                  confirmPassword = value;
                                },
                                cursorColor:
                                    Theme.of(context).colorScheme.onSurface,
                                style: TextStyle(),
                                obscureText: _hiddenPassword2,
                                decoration: InputDecoration(
                                  fillColor:
                                      Theme.of(context).colorScheme.primary,
                                  filled: true,
                                  hintText: "Confirm Password",
                                  hintStyle: TextStyle(
                                    fontFamily: 'FS PFBeauSansPro',
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSurface,
                                    ),
                                  ),
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      _hiddenPassword2
                                          ? Icons.visibility_off
                                          : Icons.visibility,
                                    ),
                                    onPressed: _togglePasswordVisibility2,
                                  ),
                                ),
                              ),
                              SizedBox(
                                  height: 25,
                                  child: Text(
                                    _noti2,
                                    style: TextStyle(
                                      color:
                                          Theme.of(context).colorScheme.error,
                                      fontFamily: 'FS PFBeauSansPro',
                                    ),
                                  )),
                              Column(
                                children: [
                                  CircleAvatar(
                                    radius: 30,
                                    backgroundColor: redViettel,
                                    child: IconButton(
                                        color: Colors.white,
                                        onPressed: () async {
                                          ValidateEmail();
                                          ValidatePassword();
                                          if (isValid) {
                                            _handleSignUp();
                                            // FirebaseAccount.signUp(
                                            //   email: email,
                                            //   password: password,
                                            //   onSuccess: () {
                                            //     Fluttertoast.showToast(
                                            //       msg: 'Sign up successfully',
                                            //       toastLength:
                                            //           Toast.LENGTH_SHORT,
                                            //       gravity: ToastGravity.BOTTOM,
                                            //       timeInSecForIosWeb: 1,
                                            //       backgroundColor: redViettel,
                                            //       textColor: Colors.white,
                                            //       fontSize: 16.0,
                                            //     );
                                            //     Navigator.pushReplacement(
                                            //       context,
                                            //       PageRouteBuilder(
                                            //         pageBuilder: (context,
                                            //                 animation1,
                                            //                 animation2) =>
                                            //             Homepage(),
                                            //       ),
                                            //     );
                                            //   },
                                            //   onError: (e) async {
                                            //     if (!await CheckConnection
                                            //         .isInternet()) {
                                            //       Fluttertoast.showToast(
                                            //         msg:
                                            //             'No internet connection',
                                            //         toastLength:
                                            //             Toast.LENGTH_SHORT,
                                            //         gravity:
                                            //             ToastGravity.BOTTOM,
                                            //         timeInSecForIosWeb: 1,
                                            //         backgroundColor: Colors.red,
                                            //       );
                                            //     } else if (e.toString().contains(
                                            //         'email-already-in-use')) {
                                            //       setState(() {
                                            //         _noti0 = _emailExistError;
                                            //         isValid = false;
                                            //       });
                                            //     } else {
                                            //       Fluttertoast.showToast(
                                            //         msg: 'Sign up failed',
                                            //         toastLength:
                                            //             Toast.LENGTH_SHORT,
                                            //         gravity:
                                            //             ToastGravity.BOTTOM,
                                            //         timeInSecForIosWeb: 1,
                                            //         backgroundColor: Colors.red,
                                            //       );
                                            //     }
                                            //   },
                                            // );
                                          }
                                        },
                                        icon: Icon(
                                          Icons.arrow_forward,
                                        )),
                                  )
                                ],
                              ),
                              SizedBox(
                                height: 25,
                              ),
                              TextButton(
                                onPressed: () {
                                  // TODO: implement sign up
                                },
                                child: RichText(
                                  text: TextSpan(
                                    text: 'Already have an account? ',
                                    style: TextStyle(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onSurface,
                                        fontFamily: 'FS PFBeauSansPro',
                                        fontSize: 20),
                                    children: <TextSpan>[
                                      TextSpan(
                                          text: 'Sign In',
                                          style: TextStyle(
                                            color: redViettel,
                                            fontFamily: 'FS PFBeauSansPro',
                                            decoration:
                                                TextDecoration.underline,
                                          ),
                                          recognizer: TapGestureRecognizer()
                                            ..onTap = () {
                                              Navigator.pop(context);
                                            }),
                                    ],
                                  ),
                                ),
                                style: ButtonStyle(),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void ValidateEmail() {
    String pattern = r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$';
    RegExp regExp = new RegExp(pattern);
    if (!regExp.hasMatch(email)) {
      setState(() {
        _noti0 = _emailError;
        isValid = false;
      });
    } else {
      setState(() {
        _noti0 = '';
        isValid = true;
      });
    }
  }

  void ValidatePassword() {
    if (password.length < 6) {
      setState(() {
        _noti1 = _passwordLengthError;
        isValid = false;
      });
    } else {
      setState(() {
        _noti1 = '';
        isValid = true;
      });
    }
    // check password match
    if (password != confirmPassword) {
      setState(() {
        _noti2 = _passwordMatchError;
        isValid = false;
      });
    } else {
      setState(() {
        _noti2 = '';
        isValid = true;
      });
    }
  }
}

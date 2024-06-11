import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:news_app_flutter_demo/firebase_tools/firebase_account.dart';
import 'package:news_app_flutter_demo/helpers/toast_log.dart';
import 'package:news_app_flutter_demo/screens/profile/sign_up_page.dart';

import '../../helpers/check_connection.dart';
import '../../helpers/const_data.dart';
import '../../widgets/title_name.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({Key? key}) : super(key: key);

  @override
  _SignInPage createState() => _SignInPage();
}

class _SignInPage extends State<SignInPage> {
  String email = '';
  String password = '';
  bool isValid = true;

  String _noti = '';

  bool _isHiddenPassword = true;

  void _togglePasswordVisibility() {
    setState(() {
      _isHiddenPassword = !_isHiddenPassword;
    });
  }

  void _handleSignIn() async {
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

    await FirebaseAccount.signIn(
      email: email,
      password: password,
      onSuccess: () {
        Navigator.pop(context);
        ToastLog.show('Sign in successfully');
        Navigator.pop(context);
      },
      onError: (error) async {
        Navigator.pop(context);
        if (!await CheckConnection.isInternet()) {
          ToastLog.show('No internet connection');
        } else {
          ToastLog.show('Email or password is incorrect');
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
                    // child: Text(
                    //   'Let Sign In!',
                    //   style: TextStyle(
                    //       color: redViettel,
                    //       fontSize: 33,
                    //       fontFamily: 'FS PFBeauSansPro',
                    //       fontWeight: FontWeight.w500,
                    //       letterSpacing: 2),
                      child: AnimatedTextKit(
                        animatedTexts: [
                          TypewriterAnimatedText(
                            '  Let Sign In!',
                            textStyle: TextStyle(
                              color: redViettel,
                              fontSize: 33,
                              fontFamily: 'FS PFBeauSansPro',
                              fontWeight: FontWeight.w500,
                              letterSpacing: 2,
                            ),
                            speed: Duration(milliseconds: 150),
                          ),
                        ],
                        totalRepeatCount: 3,
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
                                height: 30,
                              ),
                              TextField(
                                onChanged: (value) {
                                  password = value;
                                },
                                obscureText: _isHiddenPassword,
                                cursorColor:
                                    Theme.of(context).colorScheme.onSurface,
                                style: TextStyle(),
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
                                    onPressed: _togglePasswordVisibility,
                                    icon: _isHiddenPassword
                                        ? Icon(Icons.visibility_off)
                                        : Icon(Icons.visibility),
                                  ),
                                ),
                              ),
                              SizedBox(
                                  height: 30,
                                  child: Text(
                                    _noti,
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
                                        onPressed: () {
                                          _handleSignIn();
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
                                onPressed: () {},
                                child: RichText(
                                  text: TextSpan(
                                    text: 'Don\'t have an account? ',
                                    style: TextStyle(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onSurface,
                                        fontFamily: 'FS PFBeauSansPro',
                                        fontSize: 20),
                                    children: <TextSpan>[
                                      TextSpan(
                                          text: 'Sign Up',
                                          style: TextStyle(
                                            color: redViettel,
                                            fontFamily: 'FS PFBeauSansPro',
                                            decoration:
                                                TextDecoration.underline,
                                          ),
                                          recognizer: TapGestureRecognizer()
                                            ..onTap = () {
                                              // transition to sign up page
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (ctx) =>
                                                        SignUpPage()),
                                              );
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
}

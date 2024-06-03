import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../../helpers/const_data.dart';
import '../../widgets/title_name.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPage createState() => _LoginPage();
}

class _LoginPage extends State<LoginPage> {
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
                      'Let Sign In!',
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
                                style: TextStyle(
                                    color:
                                        Theme.of(context).colorScheme.primary),
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
                                    )),
                              ),
                              SizedBox(
                                height: 30,
                              ),
                              TextField(
                                style: TextStyle(),
                                obscureText: true,
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
                                    )),
                              ),
                              SizedBox(
                                height: 25,
                              ),
                              Column(
                                children: [
                                  CircleAvatar(
                                    radius: 30,
                                    backgroundColor: redViettel,
                                    child: IconButton(
                                        color: Colors.white,
                                        onPressed: () {
                                          // TODO: implement sign in
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
                                              print('Sign Up');
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

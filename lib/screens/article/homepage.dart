import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:news_app_flutter_demo/screens/profile/personal_page.dart';
import 'package:news_app_flutter_demo/screens/profile/sign_in_page.dart';
import 'package:news_app_flutter_demo/widgets/title_name.dart';
import '../../providers/themeProvider.dart';
import '../../widgets/categories.dart';
import '../../widgets/home.dart';
import '../../widgets/search.dart';
import '../../helpers/const_data.dart';

class Homepage extends ConsumerStatefulWidget {
  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends ConsumerState<Homepage> {
  final _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
  }

  int _selectedIndex = 0;
  static List<Widget> _widgetOptions = <Widget>[
    Home(),
    Categories(),
    Search(),
    PersonalPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final themePro = ref.watch(themeProvider.notifier);
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: TitleName(text: appNameLogo),
          // This is a custom widget that displays the app name
          iconTheme: IconThemeData(
            color: redViettel,
          ),

          leading: Padding(
            padding: const EdgeInsets.only(left: 5.0),
            child: IconButton(
              icon: Icon(
                Icons.person,
                size: 30,
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => _auth.currentUser == null
                        ? SignInPage()
                        : PersonalPage(),
                  ),
                );
              },
            ),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 5.0),
              child: IconButton(
                icon: Icon(
                  themePro.isDarkMode()
                      ? Icons.nightlight_round_sharp
                      : Icons.wb_sunny,
                  size: 30,
                ),
                onPressed: () {
                  themePro.toggleTheme();
                  // toast message
                  Fluttertoast.showToast(
                    msg: themePro.isDarkMode() ? 'Dark mode' : 'Light mode',
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    timeInSecForIosWeb: 1,
                    backgroundColor: themePro.isDarkMode() ? Colors.black : Color(0xFFE5E5E5),
                    textColor: themePro.isDarkMode() ? Colors.white70 : Colors.black,
                    fontSize: 16.0,
                  );
                },
              ),
            ),
          ],
          elevation: 0,
          backgroundColor: Theme.of(context).colorScheme.secondary,
        ),
        body: _widgetOptions.elementAt(_selectedIndex),
        bottomNavigationBar: BottomNavigationBar(
          elevation: .5,
          showSelectedLabels: false,
          showUnselectedLabels: false,
          backgroundColor: Theme.of(context).colorScheme.secondary,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(
                Icons.home,
                size: 30,
                color: redViettel,
              ),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.segment,
                size: 30,
                color: redViettel,
              ),
              label: 'Articles',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.search,
                size: 30,
                color: redViettel,
              ),
              label: 'Search',
            ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: redViettel,
          onTap: _onItemTapped,
        ),
      ),
    );
  }
}

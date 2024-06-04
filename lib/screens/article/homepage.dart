import 'package:flutter/material.dart';
import 'package:news_app_flutter_demo/screens/profile/personal_page.dart';
import 'package:news_app_flutter_demo/screens/profile/sign_in_page.dart';
import 'package:news_app_flutter_demo/screens/profile/sign_up_page.dart';
import 'package:news_app_flutter_demo/widgets/title_name.dart';
import 'package:provider/provider.dart';
import '../../providers/themeProvider.dart';
import '../../widgets/categories.dart';
import '../../widgets/home.dart';
import '../../widgets/search.dart';
import '../../helpers/const_data.dart';

class Homepage extends StatefulWidget {
  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  @override
  void initState() {
    super.initState();
    isDarkMode =
        Provider.of<ThemeProvider>(context, listen: false).isDarkMode();
  }

  int _selectedIndex = 0;
  static List<Widget> _widgetOptions = <Widget>[
    Home(),
    Categories(),
    Search(),
    PersonalPage(),
  ];

  late bool isDarkMode;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
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
                    builder: (context) => SignInPage(),
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
                  isDarkMode ? Icons.nightlight_round_sharp : Icons.wb_sunny,
                  size: 30,
                ),
                onPressed: () {
                  Provider.of<ThemeProvider>(context, listen: false)
                      .toggleTheme();
                  isDarkMode = !isDarkMode;
                  // reload homepage
                  Navigator.pushReplacement(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (context, animation1, animation2) =>
                          Homepage(),
                    ),
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

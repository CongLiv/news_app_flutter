import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import './top_world_news.dart';
import '../widgets/categories.dart';
import '../widgets/home.dart';
import '../widgets/search.dart';
import '../helpers/const_data.dart';

class Homepage extends StatefulWidget {
  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  @override
  void initState() {
    super.initState();
  }

  int _selectedIndex = 0;
  static List<Widget> _widgetOptions = <Widget>[
    Home(),
    Categories(),
    Search(),
  ];

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
          title: Text(
            appNameLogo,
            style: GoogleFonts.bioRhyme(
              fontSize: 23,
              fontWeight: FontWeight.w900,
              letterSpacing: 5,
              color: iconColor,
            ),
          ),
          iconTheme: IconThemeData(
            color: iconColor,
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 5.0),
              child: IconButton(
                icon: Icon(
                  Icons.language,
                  size: 30,
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (ctx) => TopWorldNews(),
                    ),
                  );
                },
              ),
            ),
          ],
          elevation: 0,
          backgroundColor: Colors.white,
        ),
        body: _widgetOptions.elementAt(_selectedIndex),
        bottomNavigationBar: BottomNavigationBar(
          elevation: .5,
          showSelectedLabels: false,
          showUnselectedLabels: false,
          backgroundColor: Colors.white,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(
                Icons.home,
                size: 30,
                color: iconColor,
              ),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.article_outlined,
                size: 30,
                color: iconColor,
              ),
              label: 'Articles',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.search,
                size: 30,
                color: iconColor,
              ),
              label: 'Search',
            ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.amber[800],
          onTap: _onItemTapped,
        ),
      ),
    );
  }
}

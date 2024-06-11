import 'package:flutter/material.dart';
import 'package:news_app_flutter_demo/helpers/const_data.dart';

import '../firebase_tools/firebase_analyst.dart';
import '../screens/article/searched_article_page.dart';

class Search extends StatefulWidget {

  final FocusNode focusNode;

  Search({required this.focusNode});

  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  final myController = TextEditingController();
  String _searchWord = "";

  @override
  void dispose() {
    myController.dispose();
    widget.focusNode.dispose();
    super.dispose();

  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        widget.focusNode.unfocus();
      },
      child: Container(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              height: 200,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(
                    'assets/images/searchScreen.jpg',
                  ),
                  fit: BoxFit.cover,
                  colorFilter: ColorFilter.mode(Colors.black54, BlendMode.darken),
                ),
              ),
              child: Center(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Text('SEARCH YOUR NEWS',
                      softWrap: true,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'FS Magistral',
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 3,
                      )),
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              margin: EdgeInsets.only(top: 20, bottom: 10),
              child: TextField(
                  focusNode: widget.focusNode,
                  autocorrect: true,
                  style: TextStyle(fontSize: 18),
                  decoration: InputDecoration(
                    suffixIcon: Icon(Icons.search),
                    suffixIconConstraints: BoxConstraints(
                      minHeight: 32,
                      minWidth: 60,
                    ),
                    hintText: 'e.g: vietnam, gpt,...',
                    hintStyle:
                        TextStyle(fontFamily: 'FS PFBeauSansPro', fontSize: 18),
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 7, horizontal: 18),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(50),
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(50),
                      ),
                      borderSide: BorderSide(
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                  ),
                  controller: myController,
                  onSubmitted: (value) async {
                    setState(() {
                      _searchWord = myController.text;
                    });
                    await FirebaseAnalyst.logSearchNewsEvent(_searchWord);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (ctx) => SearchedArticleScreen(
                              searchField:
                                  _searchWord.isEmpty ? 'world' : _searchWord)),
                    ).then((_) {
                      widget.focusNode.unfocus();
                    });
                  }),
            ),
            GestureDetector(
              onTap: () async {
                setState(() {
                  _searchWord = myController.text;
                });
                await FirebaseAnalyst.logSearchNewsEvent(_searchWord);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (ctx) => SearchedArticleScreen(
                          searchField:
                              _searchWord.isEmpty ? 'world' : _searchWord)),
                ).then((_) {
                  widget.focusNode.unfocus();
                });
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 25, vertical: 12),
                decoration: BoxDecoration(
                  color: redViettel,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text('SEARCH',
                    style: TextStyle(
                      fontFamily: 'FS PFBeauSansPro',
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.75,
                    )),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

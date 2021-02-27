
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:auto_animated/auto_animated.dart';
import 'package:peton/KeywordsDetailsPage.dart';
import 'package:peton/Server.dart';
import 'package:peton/enums/CategoryId.dart';
import 'package:peton/model/VideosTagsPopularityResponse.dart';
import 'package:search_choices/search_choices.dart';

class KeywordsSearchPage extends StatefulWidget {
  @override
  _KeywordsSearchPageState createState() => _KeywordsSearchPageState();
}

class _KeywordsSearchPageState extends State<KeywordsSearchPage> {

  Future<List<VideosTagsPopularityResponse>> listResponse;
  List<String> listTags = List<String>();
  List<DropdownMenuItem> tagItems = List<DropdownMenuItem>();
  String selectedValueSingleDialog;

  String category = CategoryId.id;

  void _getTags() {
    listResponse = server.getPopularTags(category);
    listResponse.then((value) {setState(() {
      value.forEach((e) => listTags.add(e.tags));
      listTags.shuffle();
      for(String tag in listTags) {
        tagItems.add(new DropdownMenuItem(
          value: tag,
          child: Text(tag),
        ));
      }
    });});
  }

  @override
  void initState() {
    super.initState();
    _getTags();
  }

  @override
  Widget build(BuildContext context) {
    double itemWidth = MediaQuery.of(context).size.width;
    double itemHeight = MediaQuery.of(context).size.height / 4;

    return Scaffold(
      appBar: AppBar(
        title: Text("키워드로 검색"),
        centerTitle: false,
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
            alignment: Alignment.center,
            child: SearchChoices.single(
              items: tagItems,
              value: selectedValueSingleDialog,
              hint: "키워드 검색하기",
              isExpanded: true,
              displayClearIcon: false,
              onChanged: (value) {
                if (listTags.indexOf(value) == 0) {
                  setState(() {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => KeywordsDetailsPage(keyword: value,)),
                    );
                  });
                }
              },
              closeButton: Align(
                alignment: Alignment.bottomRight,
                child: RaisedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  color: Theme.of(context).scaffoldBackgroundColor,
                  elevation: 0,
                  child: Text('Close'),
                ),
              ),
            ),
          ),
          Expanded(
            child: NotificationListener<OverscrollIndicatorNotification>(
              onNotification: (overScroll) {
                overScroll.disallowGlow();
                return;
              },
              child: LiveGrid(
                padding: EdgeInsets.all(16),
                showItemInterval: Duration(milliseconds: 2),
                showItemDuration: Duration(milliseconds: 100),
                visibleFraction: 0.001,
                itemCount: listTags.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  childAspectRatio: (itemWidth / itemHeight),
                  crossAxisCount: 3,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                ),
                itemBuilder: animationItemBuilder((index) =>
                    GestureDetector(
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => KeywordsDetailsPage(keyword: listTags[index],)),
                      ),
                      child: HorizontalItem(title: listTags[index]),
                    ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class HorizontalItem extends StatelessWidget {
  const HorizontalItem({
    @required this.title,
    Key key,
  }) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) => Container(
    width: 140,
    child: ClipRRect(
      borderRadius: BorderRadius.circular(4),
      child: Material(
        color: Colors.transparent,
        child: Center(
          child: AutoSizeText(
            title,
            style: TextStyle(fontSize: MediaQuery.of(context).size.width / 18),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
    ),
  );
}

Widget Function(
    BuildContext context,
    int index,
    Animation<double> animation,
    ) animationItemBuilder(
    Widget Function(int index) child, {
      EdgeInsets padding = EdgeInsets.zero,
    }) =>
        (
        BuildContext context,
        int index,
        Animation<double> animation,
        ) =>
        FadeTransition(
          opacity: Tween<double>(
            begin: 0,
            end: 1,
          ).animate(animation),
          child: SlideTransition(
            position: Tween<Offset>(
              begin: Offset(0, -0.1),
              end: Offset.zero,
            ).animate(animation),
            child: Padding(
              padding: padding,
              child: child(index),
            ),
          ),
        );



import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:auto_animated/auto_animated.dart';
import 'package:peton/KeywordsDetailsPage.dart';
import 'package:peton/Server.dart';
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

  int category = 1;

  void _getTags() {
    listResponse = server.getPopularTags(category);
    listResponse.then((value) {setState(() {
      value.forEach((e) => listTags.add(e.tags));
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
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              children: [
                Expanded(
                  child: SearchChoices.single(
                    items: tagItems,
                    value: selectedValueSingleDialog,
                    hint: "키워드 검색하기",
                    isExpanded: true,
                    onChanged: (value) {
                      setState(() {
                        selectedValueSingleDialog = value;
                      });
                    },
                  ),
                ),
                RaisedButton(
                  child: Text(
                    "검색",
                    style: TextStyle(fontSize: 16),
                  ),
                  color: Colors.green,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => KeywordsDetailsPage(keyword: selectedValueSingleDialog,)),
                    );
                  },
                )
              ],
            ),
          ),
          Expanded(
            child: LiveGrid(
              padding: EdgeInsets.all(16),
              showItemInterval: Duration(milliseconds: 25),
              showItemDuration: Duration(milliseconds: 100),
              visibleFraction: 0.001,
              itemCount: listTags.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                childAspectRatio: (itemWidth / itemHeight),
                crossAxisCount: 3,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              itemBuilder: animationItemBuilder((index) => HorizontalItem(title: listTags[index])),
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
            '#$title',
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


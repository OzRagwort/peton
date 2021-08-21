
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:peton/ChannelInfoPage.dart';
import 'package:peton/Server.dart';
import 'package:peton/enums/CategoryId.dart';
import 'package:peton/model/Channels.dart';
import 'package:peton/widgets/Cards.dart';
import 'package:peton/widgets/CheckNetwork.dart';

class KeywordsPopularChannelsPage extends StatefulWidget {
  @override
  _KeywordsPopularChannelsPageState createState() => _KeywordsPopularChannelsPageState();
}

class _KeywordsPopularChannelsPageState extends State<KeywordsPopularChannelsPage> {

  ScrollController _scrollController = new ScrollController();

  Future<List<Channels>> popularChannelsResponse;
  List<Channels> popularChannelsList = new List<Channels>();
  List<DropdownMenuItem> channelItems = List<DropdownMenuItem>();

  String category = CategoryId.id;

  void _getPopularChannels() async {
    int responseListLength = 0;
    int page = 0;

    Map<String, String> paramMap = {
      'categoryId' : category,
      'subscriberover' : '100000',
      'sort' : 'subscribers,desc',
      'size' : '200',
      'page' : page.toString()
    };

    do {
      List<Channels> buffer = await server.getChannelsByParam(paramMap);
      popularChannelsList.addAll(buffer);
      responseListLength = buffer.length;
      page++;
      paramMap['page'] = page.toString();
    } while (responseListLength != 0);

    setState(() {
      for(Channels channel in popularChannelsList) {
        channelItems.add(new DropdownMenuItem(
          value: channel,
          child: channelCardSmall(channel, MediaQuery.of(context).size.width),
        ));
      }
    });

  }

  Widget _channelsCard(int index, double width) {
    if (popularChannelsList[index] != null) {
      return GestureDetector(
        onTap: () => {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ChannelInfoPage(channel: popularChannelsList[index],)),
          )
        },
        child: channelCardSmall(popularChannelsList[index], width),
      );
    } else {
      return null;
    }
  }

  @override
  void initState() {
    super.initState();
    _getPopularChannels();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: Text("인기 채널"),
        centerTitle: false,
      ),
      body: CheckNetwork(
        body: popularChannelsList.length == 0
            ? Center(child: CupertinoActivityIndicator(),)
            : ListView.builder(
                controller: _scrollController,
                itemCount: popularChannelsList.length,
                itemBuilder: (context, index) {
                  return _channelsCard(index, width);
                },
              ),
      ),

      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButton(
            heroTag: null,
            child: Icon(Icons.keyboard_arrow_up),
            onPressed: () => _scrollController.animateTo(0.0, duration: const Duration(seconds: 2), curve: Curves.fastOutSlowIn),
          ),
        ],
      ),
    );
  }
}


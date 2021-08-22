
import 'package:flutter/material.dart';
import 'package:peton/Server.dart';

class UserRequestChannelPage extends StatefulWidget {
  @override
  _UserRequestChannelPageState createState() => _UserRequestChannelPageState();
}

class _UserRequestChannelPageState extends State<UserRequestChannelPage> {
  final myControllerContent = TextEditingController();

  String content = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('채널 추가하기'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.only(top: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(right: 8, left: 8, bottom: 8),
              child: TextField(
                controller: myControllerContent,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: '애니멀봄에 없는 채널을 알려주세요\n'
                      '  (채널명이 애니멀봄이에요)\n'
                      '  (고양이 채널인데 이름이 나비에요) 등\n'
                      '  검토 후 24시간 내로 추가됩니다',
                  counterText: '',
                ),
                maxLength: 1000,
                maxLines: null,
                keyboardType: TextInputType.multiline,
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                    child: RaisedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      color: Colors.grey[100],
                      child: Text('취소', style: TextStyle(fontSize: 18, color: Colors.black,),),
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                    child: RaisedButton(
                      onPressed: () {
                        server.postRequestChannel(myControllerContent.text);
                        Navigator.pop(context);
                      },
                      color: Colors.orangeAccent,
                      child: Text('전송하기', style: TextStyle(fontSize: 18, color: Colors.black,),),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

}


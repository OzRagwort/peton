
import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:package_info/package_info.dart';
import 'package:peton/enums/OpenSourceLicense.dart';
import 'package:peton/model/OpenSourceLicenseModel.dart';
import 'package:peton/widgets/Line.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingPage extends StatefulWidget {
  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  // List<String> _themeList = ['Light', 'Dark', 'System'];
  List<String> _themeList = ['밝은 테마', '어두운 테마', '시스템 테마'];
  List<DropdownMenuItem<String>> _themeDropDownMenuItems;

  List<String> _startPageList = ['Video', 'Favorite', 'Keyword', 'Library'];
  List<DropdownMenuItem<String>> _startPageDropDownMenuItems;

  @override
  void initState() {
    super.initState();
    _themeDropDownMenuItems = getDropDownMenuItems(_themeList);
    _startPageDropDownMenuItems = getDropDownMenuItems(_startPageList);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("설정"),
        centerTitle: false,
      ),
      body: NotificationListener<OverscrollIndicatorNotification>(
        onNotification: (overScroll) {
          overScroll.disallowGlow();
          return;
        },
        child: ListView(
          children: [
            /// 편의 설정
            _settingApp(),
            /// 테마
            appTheme(),
            Divider(color: Color(Theme.of(context).scaffoldBackgroundColor.value ^ 0xffffff).withOpacity(0.1), height: 0, thickness: 1,),
            /// 시작페이지
            startPage(),

            // /// 앱에 대하여
            // _aboutApp(),
            // /// 앱공유
            // appShare(),
            // Divider(color: Color(Theme.of(context).scaffoldBackgroundColor.value ^ 0xffffff).withOpacity(0.1), height: 0, thickness: 1,),
            // /// 평점
            // appRating(),

            /// 정보
            settingInfo(),
            /// 버전
            versionInfo(),
            Divider(color: Color(Theme.of(context).scaffoldBackgroundColor.value ^ 0xffffff).withOpacity(0.1), height: 0, thickness: 1,),
            /// 문의하기
            sendComment(),
            Divider(color: Color(Theme.of(context).scaffoldBackgroundColor.value ^ 0xffffff).withOpacity(0.1), height: 0, thickness: 1,),
            // /// 서비스 약관
            // serviceTermInfo(),
            // Divider(color: Color(Theme.of(context).scaffoldBackgroundColor.value ^ 0xffffff).withOpacity(0.1), height: 0, thickness: 1,),
            // /// 개인정보처리방침
            // privacyInfo(),
            // Divider(color: Color(Theme.of(context).scaffoldBackgroundColor.value ^ 0xffffff).withOpacity(0.1), height: 0, thickness: 1,),
            /// 오픈소스 라이선스
            openSourceInfo(),
            Divider(color: Color(Theme.of(context).scaffoldBackgroundColor.value ^ 0xffffff).withOpacity(0.1), height: 0, thickness: 1,),

          ],
        ),
      ),
    );
  }

  /// 공통 변수
  int parentFontSize = 18;
  int childFontSize = 16;
  int parentHeight = 40;
  int childHeight = 30;

  /// DropDown 메뉴 세팅
  List<DropdownMenuItem<String>> getDropDownMenuItems(List<String> lists) {
    List<DropdownMenuItem<String>> items = new List();
    for(String list in lists) {
      items.add(new DropdownMenuItem(
        value: list,
        child: Text(list),
      ));
    }
    return items;
  }

  /// 테마 설정 관련
  void _themeRefresh(String index) async {
    if (index == _themeList[0]) {
      AdaptiveTheme.of(context).setLight();
    } else if (index == _themeList[1]) {
      AdaptiveTheme.of(context).setDark();
    } else {
      AdaptiveTheme.of(context).setSystem();
    }
    setState(() {});
  }
  int _appThemeDropValue(String value) {
    if (value.compareTo('Light') == 0) {
      return 0;
    } else if (value.compareTo('Dark') == 0) {
      return 1;
    } else {
      return 2;
    }
  }

  /// 시작 페이지 설정 관련
  Future<String> _startPageSetting() async {
    final SharedPreferences prefs = await _prefs;
    int startPage = (prefs.getInt('start_page') ?? 0);
    if (startPage == 0)
      return 'Video';
    else if (startPage == 1)
      return 'Favorite';
    else if (startPage == 2)
      return 'Keyword';
    else
      return 'Library';
  }
  void _startPageRefresh(String index) async {
    final SharedPreferences prefs = await _prefs;
    if (index == _startPageList[0]) {
      prefs.setInt('start_page', 0);
    } else if (index == _startPageList[1]) {
      prefs.setInt('start_page', 1);
    } else if (index == _startPageList[2]) {
      prefs.setInt('start_page', 2);
    } else {
      prefs.setInt('start_page', 3);
    }
    setState(() {});
  }

  /// 편의 설정
  Widget _settingApp() {
    return Container(
      height: 45,
      color: Color(Theme.of(context).scaffoldBackgroundColor.value ^ 0x222222),
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      alignment: Alignment.bottomLeft,
      child: Text(
        '편의 설정',
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Color(Theme.of(context).textTheme.bodyText1.color.value ^ 0x333333),
        ),
      ),
    );
  }

  /// 테마
  Widget appTheme() {
    return Container(
      padding: EdgeInsets.only(left: 20, right: 10),
      height: 40,
      alignment: Alignment.center,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Text(
              '테마 설정',
              style: TextStyle(fontSize: 16),
            ),
          ),
          FutureBuilder<AdaptiveThemeMode>(
            future: AdaptiveTheme.getThemeMode(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return DropdownButton<String>(
                  icon: Icon(Icons.keyboard_arrow_down),
                  value: _themeList[_appThemeDropValue(snapshot.data.name)],
                  iconSize: 24,
                  elevation: 16,
                  underline: Container(height: 0),
                  items: _themeDropDownMenuItems,
                  onChanged: (String newValue) {
                    _themeRefresh(newValue);
                  },
                );
              } else if (snapshot.hasError) {
                return Text("${snapshot.error}");
              }
              return Text('');
            },
          ),
        ],
      ),
    );
  }

  /// 시작페이지
  Widget startPage() {
    return Container(
      padding: EdgeInsets.only(left: 20, right: 10),
      height: 40,
      alignment: Alignment.center,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Text(
              '시작 페이지',
              style: TextStyle(fontSize: 16),
            ),
          ),
          FutureBuilder<String>(
              future: _startPageSetting(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return DropdownButton<String>(
                    icon: Icon(Icons.keyboard_arrow_down),
                    value: snapshot.data,
                    iconSize: 24,
                    elevation: 16,
                    underline: Container(height: 0),
                    items: _startPageDropDownMenuItems,
                    onChanged: (String newValue) {
                      _startPageRefresh(newValue);
                    },
                  );
                } else if (snapshot.hasError) {
                  return Text("${snapshot.error}");
                }
                return Text('');
              }
          ),
        ],
      ),
    );
  }

  /// 앱에 대하여
  Widget _aboutApp() {
    return Container(
      height: 45,
      color: Color(Theme.of(context).scaffoldBackgroundColor.value ^ 0x222222),
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      alignment: Alignment.bottomLeft,
      child: Text(
        '앱 홍보하기',
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Color(Theme.of(context).textTheme.bodyText1.color.value ^ 0x333333),
        ),
      ),
    );
  }

  /// 앱공유
  Widget appShare() {
    return Container(
      padding: EdgeInsets.only(left: 20, right: 10),
      height: 40,
      alignment: Alignment.center,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Text(
              '앱 공유하기',
              style: TextStyle(fontSize: 16),
            ),
          ),
          Icon(Icons.keyboard_arrow_right),
        ],
      ),
    );
  }

  /// 평점
  Widget appRating() {
    return Container(
      padding: EdgeInsets.only(left: 20, right: 10),
      height: 40,
      alignment: Alignment.center,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Text(
              '앱 평가하기',
              style: TextStyle(fontSize: 16),
            ),
          ),
          Icon(Icons.keyboard_arrow_right),
        ],
      ),
    );
  }

  /// 정보
  Widget settingInfo() {
    return Container(
      height: 45,
      color: Color(Theme.of(context).scaffoldBackgroundColor.value ^ 0x222222),
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      alignment: Alignment.bottomLeft,
      child: Text(
        '정보',
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Color(Theme.of(context).textTheme.bodyText1.color.value ^ 0x333333),
        ),
      ),
    );
  }

  /// 버전
  Widget versionInfo() {
    return Container(
      padding: EdgeInsets.only(left: 20, right: 10),
      height: 40,
      alignment: Alignment.center,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Text(
              '앱 버전',
              style: TextStyle(fontSize: 16),
            ),
          ),
          FutureBuilder<PackageInfo>(
              future: PackageInfo.fromPlatform(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Container(
                    padding: EdgeInsets.only(right: 10),
                    child: Text(snapshot.data.version, style: TextStyle(fontSize: 16),),
                  );
                } else if (snapshot.hasError) {
                  return Text("${snapshot.error}");
                }
                return Text('');
              }
          ),
        ],
      ),
    );
  }

  /// 문의하기
  Widget sendComment() {
    return Container(
      padding: EdgeInsets.only(left: 20, right: 10),
      height: 40,
      alignment: Alignment.center,
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => QuestionPage()),
          );
        },
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Text(
                '문의하기',
                style: TextStyle(fontSize: 16),
              ),
            ),
            Icon(Icons.keyboard_arrow_right),
          ],
        ),
      ),
    );
  }

  /// 서비스 약관
  Widget serviceTermInfo() {
    return Container(
      padding: EdgeInsets.only(left: 20, right: 10),
      height: 40,
      alignment: Alignment.center,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Text(
              '서비스 약관',
              style: TextStyle(fontSize: 16),
            ),
          ),
          Icon(Icons.keyboard_arrow_right),
        ],
      ),
    );
  }

  /// 개인정보처리방침
  Widget privacyInfo() {
    return Container(
      padding: EdgeInsets.only(left: 20, right: 10),
      height: 40,
      alignment: Alignment.center,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Text(
              '개인정보처리방침',
              style: TextStyle(fontSize: 16),
            ),
          ),
          Icon(Icons.keyboard_arrow_right),
        ],
      ),
    );
  }

  /// 오픈소스 라이선스
  Widget openSourceInfo() {
    return Container(
      padding: EdgeInsets.only(left: 20, right: 10),
      height: 40,
      alignment: Alignment.center,
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => OpenSourceLicensePage()),
          );
        },
        child: Row(
          children: [
            Expanded(
              child: Text(
                '오픈소스 라인선스',
                style: TextStyle(fontSize: 16),
              ),
            ),
            Icon(Icons.keyboard_arrow_right),
          ],
        ),
      ),
    );
  }

}

/// 문의
class QuestionPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('문의하기'),
      ),
      body: Container(
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              height: MediaQuery.of(context).size.height / 3,
              child: Container(
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.symmetric(horizontal: 30),
                child: Text(
                  '안녕하세요. \n'
                      '개발자에게 자유롭게 문의주세요.',
                  style: TextStyle(fontSize: 24),
                ),
              ),
            ),
            Container(
              height: MediaQuery.of(context).size.height / 3,
              child: Column(
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => SendEmailPage()),
                      );
                    },
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width - 60,
                      height: 50,
                      child: Container(
                        alignment: Alignment.center,
                        color: Colors.grey[300],
                        child: Row(
                          children: [
                            Container(
                              padding: EdgeInsets.only(left: 15, right: 15),
                              child: Icon(Icons.email, color: Colors.black,),
                            ),
                            Expanded(
                              child: Text('이메일로 문의하기', style: TextStyle(color: Colors.black,),),
                            ),
                            Container(
                              padding: EdgeInsets.only(left: 15, right: 15),
                              child: Icon(Icons.keyboard_arrow_right, color: Colors.black,),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 30),
                    child: divline,
                  ),

                  GestureDetector(
                    onTap: () {
                      Uri _openChatUri = Uri(
                        scheme: 'https',
                        path: 'open.kakao.com/o/s5JglCYc',
                      );
                      launch(_openChatUri.toString());
                    },
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width - 60,
                      height: 50,
                      child: Container(
                        alignment: Alignment.center,
                        color: Colors.grey[300],
                        child: Row(
                          children: [
                            Container(
                              padding: EdgeInsets.only(left: 15, right: 15),
                              child: Icon(FontAwesomeIcons.kickstarterK, color: Colors.black,),
                            ),
                            Expanded(
                              child: Text('오픈 채팅으로 문의하기', style: TextStyle(color: Colors.black,),),
                            ),
                            Container(
                              padding: EdgeInsets.only(left: 15, right: 15),
                              child: Icon(Icons.keyboard_arrow_right, color: Colors.black,),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(
                child: Text(''),
              ),
            ),

          ],
        ),
      ),
    );
  }
}

/// 이메일 보내기
class SendEmailPage extends StatelessWidget {
  final myControllerTitle = TextEditingController();
  final myControllerEmail = TextEditingController();
  final myControllerContent = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Text('메일로 문의하기'),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(right: 8, left: 8, top: 8, bottom: 8),
              child: TextField(
                controller: myControllerTitle,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: '제목을 입력해 주세요. (20자 이내)',
                  counterText: '',
                ),
                maxLength: 20,
                maxLines: null,
              ),
            ),
            Container(
              margin: EdgeInsets.only(right: 8, left: 8, bottom: 8),
              child: Expanded(
                child: TextField(
                  controller: myControllerContent,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: '문의를 입력해주세요\n'
                        '    버그 제보\n'
                        '    기능 추가 요청\n'
                        '    의견/건의사항 등',
                    counterText: '',
                  ),
                  maxLength: 1000,
                  maxLines: null,
                  keyboardType: TextInputType.multiline,
                ),
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
                        Uri _emailLaunchUri = Uri(
                            scheme: 'mailto',
                            path: 'ozragwort@gmail.com',
                            queryParameters: {
                              'subject': myControllerTitle.text,
                              'body': myControllerContent.text,
                            }
                        );
                        launch(_emailLaunchUri.toString());
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

/// 오픈소스 라이선스 페이지
class OpenSourceLicensePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    List<OpenSourceLicenseModel> models = openSourceLicense.openSourceLicenseModels();
    return Scaffold(
      appBar: AppBar(
        title: Text('오픈소스 라이선스'),
        centerTitle: false,
      ),
      body: Container(
        padding: const EdgeInsets.all(15),
        child: SafeArea(
          child: NotificationListener<OverscrollIndicatorNotification>(
            onNotification: (overScroll) {
              overScroll.disallowGlow();
              return;
            },
            child: ListView.separated(
              itemCount: models.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => LicenseDetails(licenseDetails: models[index],)),
                    );
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        models[index].name,
                        style: TextStyle(
                          fontSize: 26,
                        ),
                      ),
                      const SizedBox(height: 15),
                      InkWell(
                        onTap: () => launch(models[index].gitLink),
                        child: Text(
                          models[index].gitLink,
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.blueAccent,
                          ),
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        models[index].copyright,
                        style: TextStyle(
                          fontSize: 15,
                        ),
                      ),
                      Text(
                        models[index].license,
                        style: TextStyle(
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
                );
              },
              separatorBuilder: (context, index) => const Divider(height: 25, color: Colors.blueGrey,),
            ),
          ),
        ),
      ),
    );
  }
}

/// 라이센스 전문
class LicenseDetails extends StatelessWidget {
  LicenseDetails({this.licenseDetails});

  final OpenSourceLicenseModel licenseDetails;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(licenseDetails.name, style: TextStyle(fontSize: 30),),),
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(10),
          child: ListView(
            children: [
              const SizedBox(height: 10),
              InkWell(
                onTap: () => launch(licenseDetails.gitLink),
                child: Text(
                  licenseDetails.gitLink,
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.blueAccent,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Text(licenseDetails.copyright, style: TextStyle(fontSize: 18),),
              Text(licenseDetails.license, style: TextStyle(fontSize: 18), ),
              const Divider(color: Colors.blueAccent),
              Text(licenseDetails.licenseDetails, style: TextStyle(fontSize: 15),),
            ],
          ),
        ),
      ),
    );
  }
}





import 'dart:async';
import 'dart:developer';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:peton/widgets/Line.dart';

class CheckNetwork extends StatefulWidget {
  CheckNetwork({
    Key key,
    @required this.body,
    this.slidingUp: false,
  }) : super(key: key);

  final Widget body;
  final bool slidingUp;

  @override
  _CheckNetworkState createState() => _CheckNetworkState();
}

class _CheckNetworkState extends State<CheckNetwork> {

  final Connectivity _connectivity = Connectivity();
  StreamSubscription<ConnectivityResult> _connectivitySubscription;
  bool _connbool = true;

  bool _slidingUp;

  Future<void> initConnectivity() async {
    ConnectivityResult result;

    try {
      result = await _connectivity.checkConnectivity();
    } on PlatformException catch (e) {
      print(e.toString());
    }

    _connbool = result == ConnectivityResult.wifi || result == ConnectivityResult.mobile ? true : false;

    if (!mounted) {
      return Future.value(null);
    }

    return _updateConnectionStatus(result);
  }

  Future<void> _updateConnectionStatus(ConnectivityResult result) async {
    switch (result) {
      case ConnectivityResult.wifi:
      case ConnectivityResult.mobile:
      setState(() {
        _connbool = true;
      });
        break;
      case ConnectivityResult.none:
      default:
        setState(() {
          _connbool = false;
        });
        break;
    }
  }

  Widget _refreshButton() {
    return FlatButton(
      minWidth: MediaQuery.of(context).size.width,
      onPressed: () {
        setState(() {});
      },
      child: Text(
        'Refresh',
        style: TextStyle(fontSize: 14),
      )
    );
  }

  Widget _message() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(child: CircularProgressIndicator(),),
        space,
        space,
        Text('인터넷 연결을 확인해주세요.', style: TextStyle(fontSize: 18),),
        _refreshButton(),
      ],
    );
  }

  Widget _messageRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      // crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(child: CircularProgressIndicator(),),
        spaceLeft,
        Text('인터넷 연결을 확인해주세요.', style: TextStyle(fontSize: 14),),
      ],
    );
  }

  @override
  void initState() {
    super.initState();

    _slidingUp = widget.slidingUp ?? false;

    initConnectivity();
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
  }

  @override
  void dispose() {
    log('dispose');
    _connectivitySubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_slidingUp) {
      return Scaffold(
        body: Column(
          children: [
            AnimatedContainer(
              height: _connbool ? 0.0 : 64.0,
              duration: Duration(milliseconds: 100),
              curve: Curves.easeOutExpo,
              child: _messageRow(),
            ),
            Expanded(
              child: widget.body,
            ),
          ],
        ),
      );
    } else {
      return Column(
        children: [
          Expanded(
            child: _connbool ? widget.body : _message(),
          ),
        ],
      );
    }

  }
}

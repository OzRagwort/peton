import 'dart:io';

import 'package:firebase_admob/firebase_admob.dart';

class AdMobManager {
  AdMobManager({
    this.height = 0
  });

  double height;

  BannerAd _bannerAd;
  InterstitialAd _interstitialAd;


  String appID = Platform.isIOS
      ? 'ca-app-pub-0737873676591453~3969794701'
      : 'ca-app-pub-0737873676591453~3969794701';
  String appIDInterstitial = Platform.isIOS
      ? 'ca-app-pub-0737873676591453~3969794701'
      : 'ca-app-pub-0737873676591453~3969794701';

  String bannerID = 'ca-app-pub-0737873676591453/4338294510';
  String interstitialID = 'ca-app-pub-0737873676591453/1846673170';
  // String bannerID = BannerAd.testAdUnitId;
  // String interstitialID = InterstitialAd.testAdUnitId;

  static MobileAdTargetingInfo targetingInfo = MobileAdTargetingInfo(
    keywords: <String>['애완동물', '반려동물', '동물', '강아지', '고양이', 'dog', 'cat'],
    childDirected: false,
    testDevices: <String>[],
  );

  initBanner() async {
    FirebaseAdMob.instance.initialize(appId: appID);
    _bannerAd = createBannerAd();
    _bannerAd..load()..show(
      anchorType: AnchorType.bottom,
      anchorOffset: height,
    );
  }

  dispose() async {
    _bannerAd?.dispose();
    _bannerAd = null;
    _interstitialAd?.dispose();
    _interstitialAd = null;
  }

  initInterstitial() async {
    FirebaseAdMob.instance.initialize(appId: appIDInterstitial);
    _interstitialAd = createInterstitialAd();
  }

  showInterstitialAd() {
    _interstitialAd..load()..show();
  }

  interstitialAd() async {
    await initInterstitial();
    showInterstitialAd();
  }

  BannerAd createBannerAd() {
    return BannerAd(
      adUnitId: bannerID,
      size: AdSize.banner,
      targetingInfo: targetingInfo,
      listener: (MobileAdEvent event) {
        print("BannerAd event is $event");
      },
    );
  }

  InterstitialAd createInterstitialAd() {
    return InterstitialAd(
      adUnitId: interstitialID,
      targetingInfo: targetingInfo,
      listener: (MobileAdEvent event) {
        print("InterstitialAd event is $event");
      },
    );
  }

}

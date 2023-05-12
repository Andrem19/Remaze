import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'ad_helper.dart';

class AppOpenAdManager {
  AppOpenAd? _appOpenAd;
  bool _isShowingAd = false;
  static bool isLoaded = false;

  // Load an AppOpenAd

  void loadAd(){
    AppOpenAd.load(
      adUnitId: AdHelper.appOpenAdUnitId, 
      request: const AdRequest(),
       adLoadCallback: AppOpenAdLoadCallback(
         onAdLoaded: (ad){
           print("App Open Ad Loaded");
           _appOpenAd = ad;
           isLoaded = true;
         },
          onAdFailedToLoad: (error){
            print("Failed to load app open ad : ${error.message}");
          }),
        orientation: AppOpenAd.orientationPortrait);
  }

  bool get isAdAvailable {
    return _appOpenAd != null;
  }

  void showAdIfAvailable (){
    if(_appOpenAd == null){
      print("Tried to show ad before available");
      loadAd();
      return;
    }

    if(_isShowingAd){
      print("Tried to show ad while another ad is showing");
      return;
    }

    _appOpenAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (ad){
        _isShowingAd = true;
      },
      onAdFailedToShowFullScreenContent: (ad,error){
        _isShowingAd = false;
        ad.dispose();
        _appOpenAd = null;
      },
      onAdDismissedFullScreenContent: (ad){
        _isShowingAd = false;
        ad.dispose();
        _appOpenAd = null;
        loadAd();
      }
    );

    _appOpenAd!.show();
  }
}
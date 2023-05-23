import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:remaze/controllers/routing/app_pages.dart';

import '../ad_helper.dart';

class AdController extends GetxController {
  InterstitialAd? interstitialAd;
  InterstitialAd? interstitialVideoAd;

  @override
  void onInit() {
    if (!kIsWeb) {
      _loadInterstitialAd();
      _loadInterstitialVideoAdToRivalSearch();
    }
    super.onInit();
  }

  @override
  void onClose() {
    interstitialAd?.dispose();
    interstitialVideoAd?.dispose();
    super.onClose();
  }

  void _loadInterstitialAd() {
    InterstitialAd.load(
        adUnitId: AdHelper.interstitialAdUnitId,
        request: const AdRequest(),
        adLoadCallback:
            InterstitialAdLoadCallback(onAdLoaded: (InterstitialAd ad) {
          ad.fullScreenContentCallback = FullScreenContentCallback(
            onAdDismissedFullScreenContent: (InterstitialAd ad) {
              Get.back();
              interstitialAd = null;
              _loadInterstitialAd();
            },
          );

          interstitialAd = ad;
          print("Interstitial Ad Loaded");
        }, onAdFailedToLoad: (err) {
          print("Failed to load an interstitial ad: ${err.message}");
          interstitialAd = null;
        }));
  }

  void _loadInterstitialVideoAdToRivalSearch() {
    InterstitialAd.load(
        adUnitId: AdHelper.interstitialVideoAdUnitId,
        request: const AdRequest(),
        adLoadCallback:
            InterstitialAdLoadCallback(onAdLoaded: (InterstitialAd ad) {
          ad.fullScreenContentCallback = FullScreenContentCallback(
            onAdDismissedFullScreenContent: (InterstitialAd ad) {
              Get.toNamed(Routes.RIVAL_SEARCH);
              interstitialVideoAd = null;
              _loadInterstitialVideoAdToRivalSearch();
            },
          );

          interstitialVideoAd = ad;
          print("Interstitial Ad Loaded");
        }, onAdFailedToLoad: (err) {
          print("Failed to load an interstitial ad: ${err.message}");
          interstitialVideoAd = null;
        }));
  }
}

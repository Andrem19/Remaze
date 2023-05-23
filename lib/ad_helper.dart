import 'dart:io';

class AdHelper {
  static String get bannerAdUnitId {
    if (Platform.isAndroid) {
      return "ca-app-pub-3940256099942544/6300978111";
      // return 'ca-app-pub-6723110356621126/9979516853';
    } else if (Platform.isIOS) {
      return "ca-app-pub-3940256099942544/2934735716";
    } else {
      throw UnsupportedError("Unsupported platform");
    }
  }

  static String get interstitialAdUnitId {
    if (Platform.isAndroid) {
      return "ca-app-pub-3940256099942544/1033173712";
      // return "ca-app-pub-2843487380084695/5304766480";
    } else if (Platform.isIOS) {
      return "ca-app-pub-3940256099942544/4411468910";
    } else {
      throw UnsupportedError("Unsupported Platform");
    }
  }

  static String get interstitialVideoAdUnitId {
    if (Platform.isAndroid) {
      return "ca-app-pub-3940256099942544/8691691433";
      // return "ca-app-pub-2843487380084695/1436839519";
    } else if (Platform.isIOS) {
      return "ca-app-pub-3940256099942544/5135589807";
    } else {
      throw UnsupportedError("Unsupported Platform");
    }
  }

  static String get rewardedAdUnitId {
    if (Platform.isAndroid) {
      return "ca-app-pub-3940256099942544/5224354917";
    } else if (Platform.isIOS) {
      return "ca-app-pub-3940256099942544/1712485313";
    } else {
      throw UnsupportedError("Unsupported Platform");
    }
  }

  static String get nativeAdUnitId {
    if (Platform.isAndroid) {
      return "ca-app-pub-3940256099942544/2247696110";
    } else if (Platform.isIOS) {
      return "ca-app-pub-3940256099942544/3986624511";
    } else {
      throw UnsupportedError("Unsupported Platform");
    }
  }

  static String get appOpenAdUnitId {
    if (Platform.isAndroid) {
      return "ca-app-pub-3940256099942544/3419835294";
      // return "ca-app-pub-2843487380084695/1700306239";
    } else if (Platform.isIOS) {
      return "ca-app-pub-3940256099942544/5662855259";
    } else {
      throw UnsupportedError("Unsupported Platform");
    }
  }
}

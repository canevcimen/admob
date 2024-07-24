import 'dart:io';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:flutter/material.dart';

class AdvertService {
  static final AdvertService _instance = AdvertService._internal();
  factory AdvertService() => _instance;

  BannerAd? _bannerAd;
  InterstitialAd? _interstitialAd;
  RewardedAd? _rewardedAd;
  final AdRequest _adRequest;

  AdvertService._internal()
      : _adRequest = AdRequest(
    keywords: <String>['mobile', 'app', 'development'],
    nonPersonalizedAds: true,
  );

  void initialize() {
    MobileAds.instance.initialize();
  }

  void loadBanner() {
    _bannerAd = BannerAd(
      adUnitId: Platform.isAndroid
          ? 'ca-app-pub-3940256099942544/6300978111'  // Android test ad unit ID
          : 'ca-app-pub-3940256099942544/2934735716', // iOS test ad unit ID
      size: AdSize.banner,
      request: _adRequest,
      listener: BannerAdListener(
        onAdLoaded: (Ad ad) => print('BannerAd loaded.'),
        onAdFailedToLoad: (Ad ad, LoadAdError error) {
          print('BannerAd failed to load: $error');
          ad.dispose();
        },
        onAdOpened: (Ad ad) => print('BannerAd opened.'),
        onAdClosed: (Ad ad) => print('BannerAd closed.'),
        onAdImpression: (Ad ad) => print('BannerAd impression.'),
      ),
    );

    _bannerAd!.load();
  }

  Widget getBannerWidget() {
    if (_bannerAd != null) {
      return Container(
        height: _bannerAd!.size.height.toDouble(),
        width: _bannerAd!.size.width.toDouble(),
        child: AdWidget(ad: _bannerAd!),
      );
    } else {
      return SizedBox();
    }
  }

  void loadInterstitial() {
    InterstitialAd.load(
      adUnitId: Platform.isAndroid
          ? 'ca-app-pub-3940256099942544/1033173712'  // Android test ad unit ID
          : 'ca-app-pub-3940256099942544/4411468910', // iOS test ad unit ID
      request: _adRequest,
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (InterstitialAd ad) {
          print('InterstitialAd loaded.');
          _interstitialAd = ad;
          _interstitialAd!.show();
        },
        onAdFailedToLoad: (LoadAdError error) {
          print('InterstitialAd failed to load: $error');
        },
      ),
    );
  }

  void loadRewardedAd(VoidCallback onAdLoaded) {
    RewardedAd.load(
      adUnitId: Platform.isAndroid
          ? 'ca-app-pub-3940256099942544/5224354917'  // Android test ad unit ID
          : 'ca-app-pub-3940256099942544/1712485313', // iOS test ad unit ID
      request: _adRequest,
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (RewardedAd ad) {
          print('RewardedAd loaded.');
          _rewardedAd = ad;
          onAdLoaded();
        },
        onAdFailedToLoad: (LoadAdError error) {
          print('RewardedAd failed to load: $error');
        },
      ),
    );
  }

  void showRewardedAd(VoidCallback onAdClosed) {
    if (_rewardedAd != null) {
      _rewardedAd!.fullScreenContentCallback = FullScreenContentCallback(
        onAdDismissedFullScreenContent: (AdWithoutView ad) {
          print('RewardedAd dismissed.');
          ad.dispose();
          _rewardedAd = null;
          onAdClosed();
        },
        onAdFailedToShowFullScreenContent: (AdWithoutView ad, AdError error) {
          print('RewardedAd failed to show: $error');
          ad.dispose();
          _rewardedAd = null;
        },
      );
      _rewardedAd!.show(
        onUserEarnedReward: (AdWithoutView ad, RewardItem reward) {
          print('User earned reward: $reward');
        },
      );
    }
  }

  void disposeAds() {
    _bannerAd?.dispose();
    _interstitialAd?.dispose();
    _rewardedAd?.dispose();
  }
}

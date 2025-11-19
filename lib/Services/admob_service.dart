import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

/// Singleton service for all Google Mobile Ads.
class GoogleMobileAdsService {
  GoogleMobileAdsService._();
  static final GoogleMobileAdsService instance = GoogleMobileAdsService._();

  bool _initialized = false;

  // Banner
  BannerAd? _bannerAd;
  final ValueNotifier<bool> isBannerLoaded = ValueNotifier(false);
  final testBannerAdId = 'ca-app-pub-3940256099942544/6300978111';  

  // Interstitial
  InterstitialAd? _interstitialAd;
  bool _interstitialLoading = false;
  final testInterstitialAdId = 'ca-app-pub-3940256099942544/1033173712';  

  // Rewarded
  RewardedAd? _rewardedAd;
  bool _rewardedLoading = false;
  final testRewardedAdId = 'ca-app-pub-3940256099942544/5224354917';

  // Rewarded Interstitial
  RewardedInterstitialAd? _rewardedInterstitialAd;
  bool _rewardedInterstitialLoading = false;
  final testRewardedInterstitialAdId = 'ca-app-pub-3940256099942544/5354046379';

  // ------------------------------
  // INITIALIZATION
  // ------------------------------
  Future<void> initialize() async {
    if (_initialized) return;
    await MobileAds.instance.initialize();
    _initialized = true;
  }

  // ------------------------------
  // DISPOSE
  // ------------------------------
  void dispose() {
    _bannerAd?.dispose();
    _interstitialAd?.dispose();
    _rewardedAd?.dispose();
    _rewardedInterstitialAd?.dispose();

    _bannerAd = null;
    _interstitialAd = null;
    _rewardedAd = null;
    _rewardedInterstitialAd = null;
  }

  // -------------------------------------------------------------------
  // BANNER AD
  // -------------------------------------------------------------------
  Future<void> loadBanner({
    required String adUnitId,
    AdSize size = AdSize.banner,
  }) async {
    _bannerAd?.dispose();
    isBannerLoaded.value = false;

    if(kDebugMode){
      adUnitId = testBannerAdId;
    }

    _bannerAd = BannerAd(
      size: size,
      adUnitId: adUnitId,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (_) => isBannerLoaded.value = true,
        onAdFailedToLoad: (ad, err) {
          ad.dispose();
          _bannerAd = null;
          isBannerLoaded.value = false;
        },
      ),
    );

    await _bannerAd!.load();
  }

  Widget bannerWidget() {
    if (_bannerAd == null || !isBannerLoaded.value) {
      return const SizedBox.shrink();
    }
    return Container(
      alignment: Alignment.center,
      width: _bannerAd!.size.width.toDouble(),
      height: _bannerAd!.size.height.toDouble(),
      child: AdWidget(ad: _bannerAd!),
    );
  }

  // -------------------------------------------------------------------
  // INTERSTITIAL AD
  // -------------------------------------------------------------------
  Future<void> loadInterstitial({required String adUnitId}) async {
    if (_interstitialLoading || _interstitialAd != null) return;
    _interstitialLoading = true;

  if(kDebugMode){
      adUnitId = testInterstitialAdId;
    }
    await InterstitialAd.load(
      adUnitId: adUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          _interstitialLoading = false;
          _interstitialAd = ad;

          ad.fullScreenContentCallback = FullScreenContentCallback(
            onAdDismissedFullScreenContent: (ad) {
              ad.dispose();
              _interstitialAd = null;
            },
            onAdFailedToShowFullScreenContent: (ad, error) {
              ad.dispose();
              _interstitialAd = null;
            },
          );
        },
        onAdFailedToLoad: (err) {
          _interstitialLoading = false;
          _interstitialAd = null;
        },
      ),
    );
  }

  bool showInterstitial() {
    if (_interstitialAd == null) return false;
    _interstitialAd!.show();
    return true;
  }

  // -------------------------------------------------------------------
  // REWARDED AD
  // -------------------------------------------------------------------
  Future<void> loadRewarded({required String adUnitId}) async {
    if (_rewardedLoading || _rewardedAd != null) return;
    _rewardedLoading = true;

if(kDebugMode){
      adUnitId = testRewardedAdId;
    }
    await RewardedAd.load(
      adUnitId: adUnitId,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) {
          _rewardedLoading = false;
          _rewardedAd = ad;

          ad.fullScreenContentCallback = FullScreenContentCallback(
            onAdDismissedFullScreenContent: (ad) {
              ad.dispose();
              _rewardedAd = null;
            },
            onAdFailedToShowFullScreenContent: (ad, err) {
              ad.dispose();
              _rewardedAd = null;
            },
          );
        },
        onAdFailedToLoad: (err) {
          _rewardedLoading = false;
          _rewardedAd = null;
        },
      ),
    );
  }

  bool showRewarded({
    required Function(RewardItem) onReward,
  }) {
    if (_rewardedAd == null) return false;

    _rewardedAd!.show(
      onUserEarnedReward: (ad, reward) => onReward(reward),
    );

    return true;
  }

  // -------------------------------------------------------------------
  // REWARDED INTERSTITIAL AD (NEW)
  // -------------------------------------------------------------------
  Future<void> loadRewardedInterstitial({required String adUnitId}) async {
    if (_rewardedInterstitialLoading || _rewardedInterstitialAd != null) return;
    _rewardedInterstitialLoading = true;

    if(kDebugMode){
      adUnitId = testRewardedInterstitialAdId;
    }

    await RewardedInterstitialAd.load(
      adUnitId: adUnitId,
      request: const AdRequest(),
      rewardedInterstitialAdLoadCallback: RewardedInterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          _rewardedInterstitialLoading = false;
          _rewardedInterstitialAd = ad;

          ad.fullScreenContentCallback = FullScreenContentCallback(
            onAdDismissedFullScreenContent: (ad) {
              ad.dispose();
              _rewardedInterstitialAd = null;
            },
            onAdFailedToShowFullScreenContent: (ad, err) {
              ad.dispose();
              _rewardedInterstitialAd = null;
            },
          );
        },
        onAdFailedToLoad: (err) {
          _rewardedInterstitialLoading = false;
          _rewardedInterstitialAd = null;
        },
      ),
    );
  }

  bool showRewardedInterstitial({
    required Function(RewardItem) onReward,
  }) {
    if (_rewardedInterstitialAd == null) return false;

    _rewardedInterstitialAd!.show(
      onUserEarnedReward: (ad, reward) => onReward(reward),
    );

    return true;
  }
}

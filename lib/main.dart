import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:neonacademy4/services/advert_services.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  AdvertService advertService = AdvertService();
  advertService.initialize();

  runApp(MyApp(advertService: advertService));
}

class MyApp extends StatelessWidget {
  final AdvertService advertService;

  MyApp({required this.advertService});

  @override
  Widget build(BuildContext context) {
    advertService.loadBanner();
    advertService.loadInterstitial();

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text('AdMob Challenge')),
        body: Column(
          children: [
            Expanded(
              child: Center(child: Text('Welcome to the AdMob Challenge!')),
            ),
            ElevatedButton(
              onPressed: () {
                advertService.loadRewardedAd(() {
                  advertService.showRewardedAd(() {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => PremiumPage()),
                    );
                  });
                });
              },
              child: Text('Go to Premium Page'),
            ),
            advertService.getBannerWidget(),
          ],
        ),
      ),
    );
  }
}

class PremiumPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Premium Page')),
      body: Center(child: Text('Welcome to the Premium Page!')),
    );
  }
}

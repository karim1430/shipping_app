
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../Login/Login.dart';
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final PageController _controller = PageController();
  bool isLastPage = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView(
            controller: _controller,
            onPageChanged: (index) {
              setState(() {
                isLastPage = index == 2;
              });
            },
            children: [
              buildPage(
                  'assets/package.png',
                  'Track Every Shipment',
                  'Stay informed with real-time updates on the status of your deliveries'
              ),
              buildPage(
                  'assets/cash-on-delivery.png',
                  'Trusted by Many Businesses',
                  'We provide customized shipping solutions for companies of all sizes'
              ),              buildPage(
                  'assets/package.png',
                  'Monitor Your Parcels Effortlessly',
                  'Get instant notifications on every movement of your shipments'
              ),            ],

          ),

          // زر التخطي
          Positioned(
            top: 40,
            right: 20,
            child: TextButton.icon(
              onPressed: () => _controller.jumpToPage(2),
              icon: const Icon(Icons.close, color: Colors.white, size: 22),
              label: const Text('Skip', style: TextStyle(fontSize: 16, color: Colors.white)),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildPage(String imagePath, String title, String subtitle) {
    return Column(
      children: [
        Expanded(
          flex: 5,
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.blue.shade900, Colors.blue.shade600],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                  borderRadius: const BorderRadius.vertical(bottom: Radius.circular(40)),
                ),
                child: Center(
                  child: Image.asset(imagePath, height: 280),
                ),
              ),
              Positioned(
                bottom: 15,
                child: SmoothPageIndicator(
                  controller: _controller,
                  count: 3,
                  effect: const ExpandingDotsEffect(
                    activeDotColor: Colors.white,
                    dotColor: Colors.white54,
                    dotHeight: 10,
                    dotWidth: 10,
                  ),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          flex: 3,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(25),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(40)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 10,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.blue.shade900),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                Text(
                  subtitle,
                  style: const TextStyle(fontSize: 18, color: Colors.black87),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 35),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue.shade900,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  onPressed: () async {
                    if (isLastPage) {
                      final prefs = await SharedPreferences.getInstance();
                      await prefs.setBool('seenSplash', true); // نخزن إنه شافها

                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (_) =>  LoginScreen()),
                      );
                    } else {
                      _controller.nextPage(
                        duration: const Duration(milliseconds: 400),
                        curve: Curves.easeInOut,
                      );
                    }
                  },
                  child: Text(
                    isLastPage ? 'Get Started' : 'Next',
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

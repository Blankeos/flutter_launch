import 'package:barrio_bites/go_router_builder.dart';
import 'package:barrio_bites/providers/has_onboarded.provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final hasOnboardedProvider = useHasOnboardedProvider(context, listen: true);

    final List<Widget> _onboardingPages = [
      _OnboardingPage(
        title:
            'Welcome to Barrio Bites!! ${hasOnboardedProvider.hasOnboarded ? "(onboarded)" : "(not onboarded)"}',
        description:
            'Discover local culinary delights and connect with your community through food.',
        imagePath:
            'assets/images/onboarding1.png', // Placeholder, you might need to add images
      ),
      _OnboardingPage(
        title: 'Explore Diverse Flavors',
        description:
            'Browse a wide range of homemade meals, snacks, and treats from talented local cooks.',
        imagePath: 'assets/images/onboarding2.png', // Placeholder
      ),
      _OnboardingPage(
        title: 'Order with Ease',
        description:
            'Place your orders directly through the app and enjoy convenient pickup or delivery options.',
        imagePath: 'assets/images/onboarding3.png', // Placeholder
      ),
    ];

    return Scaffold(
      body: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            itemCount: _onboardingPages.length,
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });
            },
            itemBuilder: (context, index) {
              return _onboardingPages[index];
            },
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 40.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SmoothPageIndicator(
                    controller: _pageController,
                    count: _onboardingPages.length,
                    effect: const ExpandingDotsEffect(
                      dotHeight: 10,
                      dotWidth: 10,
                      activeDotColor: Colors.deepOrange,
                      dotColor: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 30),
                  if (_currentPage == _onboardingPages.length - 1)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 40.0),
                      child: SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: PlatformElevatedButton(
                          cupertino: (_, __) => CupertinoElevatedButtonData(
                            color: Colors.deepOrange,
                          ),
                          onPressed: () {
                            hasOnboardedProvider.setHasOnboarded();
                            HomeScreenRoute().go(context);
                          },
                          child: const Text(
                            'Get Started',
                            style: TextStyle(fontSize: 18, color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _OnboardingPage extends StatelessWidget {
  final String title;
  final String description;
  final String? imagePath; // Make imagePath optional or provide a default

  const _OnboardingPage({
    required this.title,
    required this.description,
    this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(40.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (imagePath != null) ...[
            Image.asset(imagePath!, height: 250),
            const SizedBox(height: 40),
          ] else ...[
            // Placeholder for when no image is provided, or add a default image
            const Icon(Icons.restaurant_menu, size: 150, color: Colors.grey),
            const SizedBox(height: 40),
          ],
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            description,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 16, color: Colors.black54),
          ),
        ],
      ),
    );
  }
}

// OnboardingData is a class to hold the data for each onboarding screen.
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// OnboardingData is a class to hold the data for each onboarding screen.
class OnboardingData {
  final String image;
  final String title;
  final String subtitle;
  final String description;

  OnboardingData({
    required this.image,
    required this.title,
    required this.subtitle,
    required this.description,
  });
}

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive, overlays: []);
  }

  final PageController _pageController = PageController();
  int _currentPage = 0;

  // Define Colors
  static const Color kPrimaryColor = Color(0xFFA42A25); // A deep red
  static const Color kTextColor = Color(0xFFA42A25);
  static const Color kSubtextColor = Color(0xFF757575);

  // List of data for each onboarding screen, updated to match the new design.
  final List<OnboardingData> _onboardingData = [
    OnboardingData(
      image: 'assets/images/onboarding_1.png', // Use your PNG asset
      title: 'Welcome to AgapAI',
      subtitle: 'Set your goals, see what your future holds.',
      description:
          'Your personal guide to making confident financial choices, AgapAI is your safe space to explore the "what-ifs" of your money without the risk.',
    ),
    OnboardingData(
      image: 'assets/images/onboarding_2.png', // Use your PNG asset
      title: 'Plan Your Future with Interactive Stories',
      subtitle: '',
      description:
          'Engage with our KaagapAI that turns complex financial decisions into a simple, story-based format.',
    ),
    OnboardingData(
      image: 'assets/images/onboarding_3.png', // Use your PNG asset
      title: 'Understand Every Step',
      subtitle: '',
      description:
          'We provide clear, explainable AI-powered insights in simple language. Our goal is to build your trust and empower you to make informed decisions.',
    ),
    OnboardingData(
      image: 'assets/images/onboarding_4.png', // Use your PNG asset
      title: 'Ready to Build Your Future?',
      subtitle: '',
      description:
          'From simulating your first scenario to applying for a product that fits your goals, your journey to financial health starts now.',
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive, overlays: []);
    super.dispose();
  }

  // Function to handle page changes.
  void _onPageChanged(int page) {
    setState(() {
      _currentPage = page;
    });
  }

  // Function to handle skipping to the last page.
  void _skipToEnd() {
    _pageController.animateToPage(
      _onboardingData.length - 1,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
    );
  }

  // Function to handle the final action when onboarding is complete.
  void _getStarted() {
    // Navigate to your app's main screen
    // For demonstration, we'll just print a message.
    // ignore: avoid_print
    Navigator.pushNamed(context, '/login');
    // In a real app, you would navigate to your home screen, e.g.:
    // Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => const HomeScreen()));
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Image PageView (background)
          PageView.builder(
            controller: _pageController,
            onPageChanged: _onPageChanged,
            itemCount: _onboardingData.length,
            itemBuilder: (context, index) {
              return Container(
                color: Colors.grey[200], // Background color for image area
                child: Column(
                  children: [
                    Expanded(
                      // Using Image.asset to display the PNG image.
                      // The Center widget and height property were removed.
                      // BoxFit.cover makes the image fill the available space.
                      child: Image.asset(
                        _onboardingData[index].image,
                        fit: BoxFit.cover,
                        width: double.infinity,
                        // Optional: Add a frameBuilder for a smooth loading experience
                        frameBuilder:
                            (
                              BuildContext context,
                              Widget child,
                              int? frame,
                              bool wasSynchronouslyLoaded,
                            ) {
                              if (wasSynchronouslyLoaded) {
                                return child;
                              }
                              return AnimatedOpacity(
                                opacity: frame == null ? 0 : 1,
                                duration: const Duration(seconds: 1),
                                curve: Curves.easeOut,
                                child: child,
                              );
                            },
                        // Optional: Add an error builder
                        errorBuilder: (context, error, stackTrace) {
                          return const Icon(
                            Icons.error_outline,
                            color: Colors.red,
                            size: 50,
                          );
                        },
                      ),
                    ),
                    SizedBox(
                      height: screenHeight * 0.45,
                    ), // Space for the content sheet
                  ],
                ),
              );
            },
          ),

          // Content Sheet (foreground)
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: screenHeight * 0.5,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
                // Added a boxShadow to create the upper shadow effect
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.15),
                    spreadRadius: 0,
                    blurRadius: 25,
                    offset: const Offset(
                      0,
                      -5,
                    ), // Negative y-offset casts shadow upwards
                  ),
                ],
              ),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Dots
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      _onboardingData.length,
                      (index) => DotIndicator(isActive: index == _currentPage),
                    ),
                  ),

                  // Text Content with Animation
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    transitionBuilder:
                        (Widget child, Animation<double> animation) {
                          return FadeTransition(
                            opacity: animation,
                            child: child,
                          );
                        },
                    child: OnboardingTextContent(
                      key: ValueKey<int>(_currentPage),
                      data: _onboardingData[_currentPage],
                    ),
                  ),

                  // Buttons - Conditionally display buttons based on the current page
                  _currentPage == _onboardingData.length - 1
                      ? // On the last page, show a single "Get Started" button
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: _getStarted,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: kPrimaryColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(40),
                              ),
                              elevation: 5,
                            ),
                            child: const Text(
                              'Start My Journey',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        )
                      : // On other pages, show "Skip" and "Next" buttons
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            TextButton(
                              onPressed:
                                  _skipToEnd, // Call the new skip function
                              child: const Text(
                                'Skip',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: kSubtextColor,
                                ),
                              ),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                _pageController.nextPage(
                                  duration: const Duration(milliseconds: 400),
                                  curve: Curves.easeInOut,
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: kPrimaryColor,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(40),
                                ),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 24,
                                  vertical: 12,
                                ),
                                elevation: 5,
                              ),
                              child: const Row(
                                children: [
                                  Text(
                                    'Next',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                  SizedBox(width: 8),
                                  Icon(
                                    Icons.arrow_forward,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                ],
                              ),
                            ),
                          ],
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

// Widget for the text content on the sheet.
class OnboardingTextContent extends StatelessWidget {
  final OnboardingData data;

  const OnboardingTextContent({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          data.title,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.bold,
            color: _OnboardingScreenState.kTextColor,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          data.subtitle,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 18,
            color: _OnboardingScreenState.kSubtextColor,
          ),
        ),
        const SizedBox(height: 24),
        Text(
          data.description,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 14,
            color: _OnboardingScreenState.kSubtextColor,
            height: 1.5,
          ),
        ),
      ],
    );
  }
}

// Widget for the dot indicators.
class DotIndicator extends StatelessWidget {
  final bool isActive;

  const DotIndicator({super.key, required this.isActive});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      margin: const EdgeInsets.symmetric(horizontal: 4.0),
      height: 8.0,
      width: isActive ? 24.0 : 8.0,
      decoration: BoxDecoration(
        color: isActive
            ? _OnboardingScreenState.kTextColor
            : Colors.grey.withOpacity(0.4),
        borderRadius: const BorderRadius.all(Radius.circular(12)),
      ),
    );
  }
}

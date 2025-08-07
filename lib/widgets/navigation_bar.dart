// This is the main screen widget which contains the swipeable pages and the bottom navigation bar.
import 'package:flutter/material.dart';
import 'package:test_app/screens/history.dart';
import 'package:test_app/screens/initial_chatbot.dart';
import 'package:test_app/screens/profile.dart';

// This is the main screen widget which contains the swipeable pages and the navigation bar.
class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  // Controller to manage which page is currently displayed in the PageView.
  // Set the initial page to 1 (Sandbox/MainPage)
  final PageController _pageController = PageController(initialPage: 1);

  // The index of the currently selected page, initialized to 1.
  int _selectedIndex = 1;

  // List of the pages that will be displayed.
  List<Widget> pages = <Widget>[
    HistoryPage(),
    InitialMainPage(), // Renamed from MainPage for clarity
    ProfilePage(),
  ];

  @override
  void dispose() {
    // It's important to dispose of the controller when the widget is removed from the widget tree.
    // This prevents memory leaks.
    _pageController.dispose();
    super.dispose();
  }

  // This function is called when a user taps on a navigation bar item.
  void _onDestinationSelected(int index) {
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 400),
      curve: Curves.ease,
    );
  }

  @override
  Widget build(BuildContext context) {
    // Calculate the position of the indicator based on the selected index.
    final double screenWidth = MediaQuery.of(context).size.width;
    const int itemCount = 3; // Number of items in the bar
    final double itemWidth = screenWidth / itemCount;
    const double indicatorWidth = 60; // Width of the indicator line
    // Calculate the left offset for the indicator to be centered on the active item.
    final double indicatorPosition = (_selectedIndex * itemWidth) + (itemWidth / 2) - (indicatorWidth / 2);

    return Scaffold(
      // PageView is a scrollable list that works page by page.
      // It's what allows the user to swipe between screens.
      body: PageView(
        controller: _pageController,
        // This callback is called when the user swipes to a new page.
        onPageChanged: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        children: pages,
      ),
      // Using a Stack to place our custom indicator on top of the NavigationBar.
      bottomNavigationBar: Stack(
        children: [
          NavigationBar(
            // The index of the currently selected item.
            selectedIndex: _selectedIndex,
            // The callback that is called when an item is tapped.
            onDestinationSelected: _onDestinationSelected,
            // Set a background color and remove the default surface tint for a cleaner look.
            backgroundColor: const Color(0x00000000),
            surfaceTintColor: Colors.transparent,
            // The list of destinations (items) to display, using your specified icons.
            destinations: const <Widget>[
              NavigationDestination(
                selectedIcon: Icon(Icons.history, color: Color(0xFFA42A25)),
                icon: Icon(Icons.history_outlined),
                label: 'History',
              ),
              NavigationDestination(
                selectedIcon: Icon(Icons.science_rounded, color: Color(0xFFA42A25)),
                icon: Icon(Icons.science_outlined),
                label: 'Sandbox',
              ),
              NavigationDestination(
                selectedIcon: Icon(Icons.person, color: Color(0xFFA42A25)),
                icon: Icon(Icons.person_outline),
                label: 'Profile',
              ),
            ],
          ),
          // This is the custom indicator line.
          AnimatedPositioned(
            duration: const Duration(milliseconds: 375),
            curve: Curves.linear,
            left: indicatorPosition,
            top: 0, // Position it at the very top edge.
            child: Container(
              height: 3, // Height of the indicator line
              width: indicatorWidth,
              decoration: BoxDecoration(
                color: const Color(0xFFA42A25),
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
// lib/features/home/presentation/pages/dashboard.dart
import 'package:flutter/material.dart';
import '../../../discover/presentation/pages/discover_page.dart';
import '../../../articles/presentation/pages/article_list_page.dart';
import '../../../profile/presentation/pages/profile_page.dart';
import 'home_page.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const HomePage(),
    const DiscoverPage(),
    const ArticleListPage(),
    const ProfilePage(),
  ];

  final List<BottomNavigationBarItem> _navItems = [
    const BottomNavigationBarItem(
      icon: Icon(Icons.home_outlined),
      activeIcon: Icon(Icons.home),
      label: 'হোম',
    ),
    const BottomNavigationBarItem(
      icon: Icon(Icons.explore_outlined),
      activeIcon: Icon(Icons.explore),
      label: 'আবিষ্কার',
    ),
    const BottomNavigationBarItem(
      icon: Icon(Icons.article_outlined),
      activeIcon: Icon(Icons.article),
      label: 'প্রবন্ধ',
    ),
    const BottomNavigationBarItem(
      icon: Icon(Icons.person_outline),
      activeIcon: Icon(Icons.person),
      label: 'প্রোফাইল',
    ),
  ];

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
        type: BottomNavigationBarType.fixed,
        items: _navItems,
      ),
    );
  }
}
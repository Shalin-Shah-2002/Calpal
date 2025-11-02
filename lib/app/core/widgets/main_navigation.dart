import 'package:flutter/material.dart';
import 'liquid_glass_nav.dart';
import '../../modules/home/views/home_view.dart';
import '../../modules/history/views/history_view.dart';

class MainNavigationView extends StatefulWidget {
  const MainNavigationView({super.key});

  @override
  State<MainNavigationView> createState() => _MainNavigationViewState();
}

class _MainNavigationViewState extends State<MainNavigationView> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [const HomeView(), const HistoryView()];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true, // Allow body to extend behind navigation bar
      body: IndexedStack(index: _selectedIndex, children: _pages),
      bottomNavigationBar: SafeArea(
        child: LiquidGlassNavBar(
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          selectedColor: Colors.green[700],
          unselectedColor: Colors.grey[600],
          backgroundColor: Colors.white,
          items: const [
            NavBarItem(icon: Icons.search_rounded, label: 'Search'),
            
            NavBarItem(icon: Icons.calendar_today_rounded, label: 'History'),
          ],
        ),
      ),
    );
  }
}

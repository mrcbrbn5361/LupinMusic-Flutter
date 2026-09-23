import 'package:flutter/material.dart';
import 'explore_view.dart';
import 'search_view.dart';
import 'queue_drawer.dart';
import '../widgets/player_bar.dart';
import '../theme/lupin_theme.dart';

class MainLayout extends StatefulWidget {
  const MainLayout({Key? key}) : super(key: key);

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  int _selectedNavIndex = 0;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final List<Widget> _views = const [
    ExploreView(),
    SearchView(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      endDrawer: const QueueDrawer(),
      body: Container(
        decoration: const BoxDecoration(
          color: LupinTheme.background,
        ),
        child: Row(
          children: [
            // Sidebar Navigation for Desktop/Tablet
            NavigationRail(
              backgroundColor: LupinTheme.surface,
              selectedIndex: _selectedNavIndex,
              onDestinationSelected: (idx) {
                setState(() => _selectedNavIndex = idx);
              },
              leading: Padding(
                padding: const EdgeInsets.symmetric(vertical: 24.0),
                child: Container(
                  width: 44,
                  height: 44,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [LupinTheme.neonPink, LupinTheme.neonPurple],
                    ),
                  ),
                  child: const Center(
                    child: Icon(Icons.music_note, color: Colors.white, size: 26),
                  ),
                ),
              ),
              labelType: NavigationRailLabelType.selected,
              selectedIconTheme: const IconThemeData(color: LupinTheme.neonPink, size: 28),
              unselectedIconTheme: const IconThemeData(color: LupinTheme.textSecondary, size: 24),
              selectedLabelTextStyle: const TextStyle(color: LupinTheme.neonPink, fontWeight: FontWeight.bold),
              destinations: const [
                NavigationRailDestination(
                  icon: Icon(Icons.explore_outlined),
                  selectedIcon: Icon(Icons.explore),
                  label: Text('Explore'),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.search_outlined),
                  selectedIcon: Icon(Icons.search),
                  label: Text('Search'),
                ),
              ],
            ),
            const VerticalDivider(thickness: 1, width: 1, color: LupinTheme.glassBorder),
            // Main Active View
            Expanded(
              child: SafeArea(
                child: _views[_selectedNavIndex],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: PlayerBar(
        onOpenQueue: () {
          _scaffoldKey.currentState?.openEndDrawer();
        },
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'explore_view.dart';
import 'search_view.dart';
import 'queue_drawer.dart';
import '../widgets/player_bar.dart';
import '../widgets/settings_dialog.dart';
import '../theme/lupin_theme.dart';

class MainLayout extends StatefulWidget {
  const MainLayout({Key? key}) : super(key: key);

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  int _currentNavIndex = 0;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  void _onNavSelect(int index) {
    if (index == 4) {
      // Open Settings Modal
      showDialog(
        context: context,
        builder: (ctx) => const SettingsDialog(),
      );
      return;
    }
    setState(() {
      _currentNavIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      endDrawer: const QueueDrawer(),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LupinTheme.bgGradient,
        ),
        child: Column(
          children: [
            // Custom Titlebar
            Container(
              height: 38,
              decoration: const BoxDecoration(
                color: Color(0xF2090214),
                border: Border(
                  bottom: BorderSide(color: LupinTheme.borderSubtle, width: 1.0),
                ),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 14),
              child: Row(
                children: [
                  Container(
                    width: 20,
                    height: 20,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: LupinTheme.accentPinkGlow,
                          blurRadius: 8,
                        )
                      ],
                    ),
                    child: ClipOval(
                      child: Image.asset(
                        'assets/logo.png',
                        fit: BoxFit.cover,
                        errorBuilder: (ctx, err, stack) =>
                            const Icon(Icons.music_note, color: LupinTheme.accentPink, size: 14),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'LUPIN MUSIC',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.5,
                      color: Color(0xFFF3E8FF),
                    ),
                  ),
                  const Spacer(),
                  // Window controls
                  Row(
                    children: [
                      _buildWinBtn(Icons.remove, () {}),
                      _buildWinBtn(Icons.crop_square, () {}),
                      _buildWinBtn(Icons.close, () {}, isClose: true),
                    ],
                  ),
                ],
              ),
            ),

            // Main Workspace (Sidebar + Content Area)
            Expanded(
              child: Row(
                children: [
                  // Sidebar (Width: 240px)
                  Container(
                    width: 240,
                    decoration: const BoxDecoration(
                      color: LupinTheme.bgSidebar,
                      border: Border(
                        right: BorderSide(color: LupinTheme.borderSubtle, width: 1.0),
                      ),
                    ),
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Brand Hero
                        Row(
                          children: [
                            Container(
                              width: 44,
                              height: 44,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(color: LupinTheme.accentPink, width: 1.5),
                                boxShadow: const [
                                  BoxShadow(
                                    color: LupinTheme.accentPurpleGlow,
                                    blurRadius: 16,
                                  ),
                                  BoxShadow(
                                    color: LupinTheme.accentPinkGlow,
                                    blurRadius: 8,
                                  ),
                                ],
                              ),
                              child: ClipOval(
                                child: Image.asset(
                                  'assets/logo.png',
                                  fit: BoxFit.cover,
                                  errorBuilder: (ctx, err, stack) => const Icon(
                                    Icons.music_note,
                                    color: LupinTheme.accentPink,
                                    size: 24,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ShaderMask(
                                  shaderCallback: (bounds) => const LinearGradient(
                                    colors: [Colors.white, Color(0xFFE879F9), Color(0xFFC084FC)],
                                  ).createShader(bounds),
                                  child: const Text(
                                    'LUPIN',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w800,
                                      fontSize: 17,
                                      letterSpacing: 2.0,
                                    ),
                                  ),
                                ),
                                const Text(
                                  'PREMIUM MUSIC',
                                  style: TextStyle(
                                    color: LupinTheme.textMuted,
                                    fontSize: 10,
                                    letterSpacing: 0.8,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 28),

                        // Navigation Menu
                        _buildNavItem(0, Icons.play_circle_outline, 'Keşfet'),
                        _buildNavItem(1, Icons.search, 'Arama'),
                        _buildNavItem(2, Icons.favorite_border, 'Beğenilenler'),
                        _buildNavItem(3, Icons.history, 'Geçmiş'),
                        _buildNavItem(4, Icons.settings_outlined, 'Ayarlar'),

                        const Spacer(),

                        // System Status Box
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: const Color(0xB3160728),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: LupinTheme.borderSubtle),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildStatusRow('REST API: ', 'Port 9863'),
                              const SizedBox(height: 8),
                              _buildStatusRow('Discord: ', 'lupin.music'),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Center Active View
                  Expanded(
                    child: _currentNavIndex == 1
                        ? const SearchView()
                        : const ExploreView(),
                  ),
                ],
              ),
            ),

            // Bottom Player Bar
            PlayerBar(
              onOpenQueue: () {
                _scaffoldKey.currentState?.openEndDrawer();
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWinBtn(IconData icon, VoidCallback onTap, {bool isClose = false}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: 36,
        height: 38,
        alignment: Alignment.center,
        child: Icon(
          icon,
          size: 14,
          color: LupinTheme.textSecondary,
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, IconData icon, String label) {
    final isActive = _currentNavIndex == index && index != 4;

    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: InkWell(
        onTap: () => _onNavSelect(index),
        borderRadius: BorderRadius.circular(12),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            gradient: isActive
                ? const LinearGradient(
                    colors: [Color(0x40EC4899), Color(0x33A855F7)],
                  )
                : null,
            border: Border.all(
              color: isActive ? LupinTheme.borderGlow : Colors.transparent,
              width: 1.0,
            ),
            boxShadow: isActive
                ? const [
                    BoxShadow(
                      color: Color(0x33EC4899),
                      blurRadius: 16,
                      spreadRadius: 1,
                    )
                  ]
                : [],
          ),
          child: Row(
            children: [
              Icon(
                icon,
                color: isActive ? Colors.white : LupinTheme.textSecondary,
                size: 19,
              ),
              const SizedBox(width: 12),
              Text(
                label,
                style: TextStyle(
                  color: isActive ? Colors.white : LupinTheme.textSecondary,
                  fontSize: 13.5,
                  fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusRow(String prefix, String boldSuffix) {
    return Row(
      children: [
        Container(
          width: 7,
          height: 7,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: LupinTheme.statusGreen,
            boxShadow: [
              BoxShadow(
                color: LupinTheme.statusGreen,
                blurRadius: 6,
                spreadRadius: 1,
              )
            ],
          ),
        ),
        const SizedBox(width: 8),
        Text(
          prefix,
          style: const TextStyle(
            color: LupinTheme.textSecondary,
            fontSize: 11.5,
          ),
        ),
        Text(
          boldSuffix,
          style: const TextStyle(
            color: LupinTheme.textPrimary,
            fontSize: 11.5,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}

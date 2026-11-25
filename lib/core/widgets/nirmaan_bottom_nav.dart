/// NirmaanBottomNav — 5-tab bottom navigation bar with active pill highlight.
///
/// Tabs: Home · Sales · Inventory · Customers · More
library;

import 'package:flutter/material.dart';
import '../theme/theme.dart';

class NirmaanBottomNav extends StatelessWidget {
  const NirmaanBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  final int currentIndex;
  final ValueChanged<int> onTap;

  static const _tabs = <_NavTab>[
    _NavTab(icon: Icons.home_outlined, activeIcon: Icons.home_rounded, label: 'Home'),
    _NavTab(icon: Icons.point_of_sale_outlined, activeIcon: Icons.point_of_sale, label: 'Sales'),
    _NavTab(icon: Icons.inventory_2_outlined, activeIcon: Icons.inventory_2_rounded, label: 'Inventory'),
    _NavTab(icon: Icons.people_outline, activeIcon: Icons.people_rounded, label: 'Customers'),
    _NavTab(icon: Icons.more_horiz, activeIcon: Icons.more_horiz, label: 'More'),
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      height: NirmaanDimens.bottomNavHeight,
      decoration: BoxDecoration(
        color: isDark ? NirmaanColors.darkCard : NirmaanColors.white,
        border: Border(
          top: BorderSide(
            color: isDark ? NirmaanColors.darkCardBorder : NirmaanColors.cardBorder,
            width: 1,
          ),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: List.generate(_tabs.length, (i) {
            final isActive = i == currentIndex;
            return Expanded(
              child: _NavItem(
                tab: _tabs[i],
                isActive: isActive,
                isDark: isDark,
                onTap: () => onTap(i),
              ),
            );
          }),
        ),
      ),
    );
  }
}

class _NavTab {
  const _NavTab({
    required this.icon,
    required this.activeIcon,
    required this.label,
  });
  final IconData icon;
  final IconData activeIcon;
  final String label;
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.tab,
    required this.isActive,
    required this.isDark,
    required this.onTap,
  });

  final _NavTab tab;
  final bool isActive;
  final bool isDark;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final activeColor = isDark ? NirmaanColors.white : NirmaanColors.brandNavy;
    final inactiveColor = isDark ? NirmaanColors.darkBody : NirmaanColors.bodyGrey;
    final pillColor = isDark
        ? NirmaanColors.darkTintedHighlight
        : NirmaanColors.navActivePill;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            decoration: BoxDecoration(
              color: isActive ? pillColor : Colors.transparent,
              borderRadius: BorderRadius.circular(NirmaanDimens.pillRadius),
            ),
            child: Icon(
              isActive ? tab.activeIcon : tab.icon,
              size: 22,
              color: isActive ? activeColor : inactiveColor,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            tab.label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
              color: isActive ? activeColor : inactiveColor,
            ),
          ),
        ],
      ),
    );
  }
}

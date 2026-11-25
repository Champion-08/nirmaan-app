/// App Shell — Wraps the bottom nav and child screens.
library;

import 'package:flutter/material.dart';
import '../core/widgets/widgets.dart';
import '../features/business_ops/presentation/dashboard_screen.dart';
import '../features/sales/sales_screen.dart';
import '../features/inventory/inventory_screen.dart';
import '../features/customers/customers_screen.dart';
import '../features/more/more_screen.dart';

class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int _currentIndex = 0;

  static const _screens = <Widget>[
    DashboardScreen(),
    SalesScreen(),
    InventoryScreen(),
    CustomersScreen(),
    MoreScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: NirmaanBottomNav(
        currentIndex: _currentIndex,
        onTap: (i) => setState(() => _currentIndex = i),
      ),
    );
  }
}

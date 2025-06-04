import 'package:flutter/material.dart';

class TabBarController extends StatefulWidget {
  final List<Widget> tabScreens;
  final List<Tab> tabs;

  const TabBarController({
    Key? key,
    required this.tabScreens,
    required this.tabs,
  }) : super(key: key);

  @override
  State<TabBarController> createState() => _TabBarControllerState();
}

class _TabBarControllerState extends State<TabBarController>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: widget.tabs.length,
      vsync: this,
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TabBar(
          controller: _tabController,
          tabs: widget.tabs,
        ),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: widget.tabScreens,
          ),
        ),
      ],
    );
  }
}
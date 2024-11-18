import 'package:flutter/material.dart';
import 'package:motion_tab_bar_v2/motion-tab-controller.dart';
import '../custom_tabbar.dart';

class Home2Screen extends StatelessWidget {
  final MotionTabBarController tabController;

  const Home2Screen({super.key, required this.tabController});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const Center(
        child: Text(
          'Home2 Screen',
          style: TextStyle(fontSize: 24, color: Colors.white),
        ),
      ),
      bottomNavigationBar: CustomTabBar(tabController: tabController),
    );
  }
}

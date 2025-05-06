import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:speak_ez/Controllers/global_controller.dart';
import 'package:speak_ez/Screens/HomeScreen/home_screen.dart';

class TabBarScreen extends StatefulWidget {
  const TabBarScreen({super.key});

  @override
  State<TabBarScreen> createState() => _TabBarScreenState();
}

class _TabBarScreenState extends State<TabBarScreen> {
  final c = Get.put(GlobalController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: globalController.cutomTabBarController,
        physics: NeverScrollableScrollPhysics(),
        children: [
          HomeScreen(),
          Container(
            color: Colors.white,
            child: Center(child: Text("Coming soon")),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        onTap: (value) {
          globalController.currentTabIndex.value = value;
          globalController.cutomTabBarController.animateToPage(
            value,
            duration: Duration(milliseconds: 300),
            curve: Curves.easeIn,
          );
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.workspace_premium_outlined),
            label: "Progress",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat_bubble_outline),
            label: "Practice",
          ),
        ],
        currentIndex: 0,
      ),
    );
  }
}

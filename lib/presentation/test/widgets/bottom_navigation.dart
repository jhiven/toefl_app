import 'package:flutter/material.dart';
import 'package:toefl_app/presentation/learn/pages/learn_method_page.dart';
import 'package:toefl_app/presentation/test/screens/history_screen.dart';
import 'package:toefl_app/presentation/test/screens/home_tests.dart';
import 'package:toefl_app/presentation/test/screens/leaderboard.dart';
import 'package:toefl_app/presentation/test/widgets/custom_navigation.dart';

class NavigationBottom extends StatefulWidget {
  const NavigationBottom({super.key});

  @override
  State<NavigationBottom> createState() => _NavigationBottomState();
}

class _NavigationBottomState extends State<NavigationBottom> {
  int currentPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: CustomNavigationBar(
        currentPageIndex: currentPageIndex,
        onDestinationSelected: (int index) {
          setState(() {
            currentPageIndex = index;
          });
        },
      ),
      body: <Widget>[
        const HomeTest(),
        const LearnMainMethod(),
        const Leaderboard(),
        const HistoryPage(),
      ][currentPageIndex],
    );
  }
}

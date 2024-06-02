import 'package:flutter/material.dart';
import 'home_body_widget.dart';
import 'home_bottom_tab_widget.dart';
import '../../shared/components/appbar_widget.dart';

class HomeScreen extends StatelessWidget{
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppbarWidget(),
      body: HomeBodyWidget(),
      bottomNavigationBar: HomeBottomTabWidget(),
    );
  }
}


import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/cart/cart_bloc.dart';
import '../blocs/cart/cart_state.dart';

import '../widgets/custom_bottom_nav.dart';

import 'home_screen.dart';
import 'explore_screen.dart';
import 'cart_screen.dart';
import 'profile_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int currentIndex = 0;

  final pages = const [
    HomeScreen(),
    ExploreScreen(),
    CartScreen(isEmbedded: true),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[currentIndex],

      bottomNavigationBar: BlocBuilder<CartBloc, CartState>(
        builder: (context, state) {
          return CustomBottomNav(
            currentIndex: currentIndex,
            cartCount: state.totalItems,
            onTap: (index) {
              setState(() => currentIndex = index);
            },
          );
        },
      ),
    );
  }
}
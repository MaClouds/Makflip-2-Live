import 'package:flutter/material.dart';
import 'package:markflip/views/screens/bottomNavigationScreens/cart_screen.dart';
import 'package:markflip/views/screens/bottomNavigationScreens/categories_page.dart';
import 'package:markflip/views/screens/bottomNavigationScreens/home_screen.dart';
import 'package:markflip/views/screens/bottomNavigationScreens/profiile_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int pageIndex = 0;

  List<Widget> pages = [
    const HomeScreen(),
    const CategoriesPage(),
    // const GroceryScreen(),
    const CartScreen(),
    const ProfilePage(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        onTap: (value) {
          setState(() {
            pageIndex = value;
          });
        },
        currentIndex: pageIndex,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.purple,
        unselectedItemColor: Colors.grey,
        items: [
          BottomNavigationBarItem(
            backgroundColor: Colors.white.withOpacity(0.95),
            icon: Image.asset(
              'assets/icons/home.png',
              width: 25,
            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              'assets/Palette1.png',
              height: 24,
              width: 24,
            ),
            label: 'categories',
          ),
          //  BottomNavigationBarItem(
          //     icon: Image.asset(
          //       'assets/brand 1.png',
          //       height: 24,
          //       width: 60,
          //     ),
          //     label: 'Grocery',
          //   ),
          BottomNavigationBarItem(
            icon: Image.asset(
              'assets/Cart1.png',
              height: 24,
              width: 24,
            ),
            label: 'Cart',
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              'assets/User1.png',
              height: 24,
              width: 24,
            ),
            label: 'Profile',
          ),
        ],
      ),
      body: pages[pageIndex],
    );
  }
}

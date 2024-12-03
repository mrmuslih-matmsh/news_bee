import 'package:flutter/material.dart';
import 'package:newsbee/Components/color.dart';
import 'home.dart';
import 'search.dart';
import 'category.dart';
import 'bookmark.dart';

class NewsApp extends StatefulWidget {
  @override
  _NewsAppState createState() => _NewsAppState();
}

class _NewsAppState extends State<NewsApp> {
  int _currentIndex = 0;
  final List<Widget> _pages = [
    const HomeScreen(),
    SearchScreen(),
    CategoryScreen(),
    const BookmarkScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,
      body: _pages[_currentIndex],
      bottomNavigationBar: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          backgroundColor: Colors.white,
          selectedItemColor: secondaryColor,
          unselectedItemColor: logoBlackColor,
          selectedLabelStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            fontFamily: 'PoppinsMedium',
          ),
          unselectedLabelStyle: const TextStyle(
            fontSize: 12,
            fontFamily: 'PoppinsRegular',
          ),
          elevation: 8.0, // adds shadow for a floating effect
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.search),
              label: 'Search',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.category),
              label: 'Category',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.bookmark),
              label: 'Bookmark',
            ),
          ],
        ),
      ),
    );
  }
}

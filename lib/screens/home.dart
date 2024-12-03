import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:newsbee/Components/breaking_news_card.dart';
import 'package:newsbee/Components/color.dart';
import 'package:newsbee/Components/news_list_tile.dart';
import 'package:newsbee/Models/news_model.dart';
import 'package:newsbee/screens/notification.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<List<NewsData>> futureNews;
  final PageController _pageController =
      PageController(); // PageController for center item tracking
  int _currentIndex = 1;

  @override
  void initState() {
    super.initState();
    futureNews = NewsData.fetchNews(); // Call fetchNews() to load news data
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,
      // AppBar section
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.transparent,
        title: Row(
          children: [
            Image.asset(
              'assets/Newsbee_single.png', // Path to your logo image
              height: 50, // Adjust the height as needed
            ),
            const SizedBox(
                width: 3), // Add spacing between the logo and the text
            RichText(
              text: const TextSpan(
                children: [
                  TextSpan(
                    text: "News",
                    style: TextStyle(
                        color: logoBlackColor,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                  TextSpan(
                    text: " Bee",
                    style: TextStyle(
                        color: secondaryColor,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: 8.0), // Add padding around the icon
            child: Container(
              decoration: BoxDecoration(
                color:
                    Colors.grey[300], // Background color for the rounded card
                borderRadius: BorderRadius.circular(14), // Rounded corners
              ),
              child: IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const NotificationScreen(),
                    ),
                  );
                },
                icon: const Icon(
                  Icons.notifications_none_outlined,
                  color: logoBlackColor,
                  size: 24,
                ),
              ),
            ),
          ),
        ],
      ),

      // Body section
      body: FutureBuilder<List<NewsData>>(
        future: futureNews,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
                child: CircularProgressIndicator(
              color: secondaryColor,
            ));
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No news available.'));
          } else {
            List<NewsData> newsData = snapshot.data!;

            // Split data into breaking news and recent news
            List<NewsData> breakingNewsData =
                newsData.take(5).toList(); // First 5 for breaking news
            List<NewsData> recentNewsData =
                newsData.skip(5).toList(); // Remaining as recent news

            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Breaking News",
                      style: TextStyle(
                        fontSize: 18.0,
                        fontFamily: 'PoppinsMedium',
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    // Carousel for breaking news with PageController for dynamic center item selection
                    CarouselSlider.builder(
                      itemCount: breakingNewsData.length,
                      itemBuilder: (context, index, id) =>
                          BreakingNewsCard(breakingNewsData[index]),
                      options: CarouselOptions(
                        aspectRatio: 16 / 9,
                        enableInfiniteScroll: false,
                        enlargeCenterPage: true,
                        initialPage: _currentIndex,
                        onPageChanged: (index, reason) {
                          setState(() {
                            _currentIndex = index;
                          });
                        },
                        viewportFraction:
                            0.8, // Adjusting the size of the items around the center
                      ),
                    ),
                    const SizedBox(
                      height: 40.0,
                    ),
                    const Text(
                      "Recent News",
                      style: TextStyle(
                        fontSize: 18.0,
                        fontFamily: 'PoppinsMedium',
                      ),
                    ),
                    const SizedBox(
                      height: 16.0,
                    ),
                    // List of recent news
                    Column(
                      children:
                          recentNewsData.map((e) => NewsListTile(e)).toList(),
                    ),
                  ],
                ),
              ),
            );
          }
        },
      ),
    );
  }
}

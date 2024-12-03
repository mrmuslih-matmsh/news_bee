import 'package:flutter/material.dart';
import 'package:newsbee/Models/news_model.dart';
import '../Components/color.dart';
import '../components/news_list_tile.dart'; // Import the NewsListTile component

class CategoryDetailScreen extends StatefulWidget {
  final String category;

  const CategoryDetailScreen({super.key, required this.category});

  @override
  _CategoryDetailScreenState createState() => _CategoryDetailScreenState();
}

class _CategoryDetailScreenState extends State<CategoryDetailScreen> {
  late Future<List<NewsData>> futureNews;
  List<NewsData> newsList = [];
  String selectedSortOption = 'Time'; // Default sorting option

  @override
  void initState() {
    super.initState();
    futureNews = fetchAndSortNews();
  }

  Future<List<NewsData>> fetchAndSortNews() async {
    List<NewsData> fetchedNews =
        await NewsData.fetchNews(category: widget.category.toLowerCase());
    return sortNews(fetchedNews, selectedSortOption);
  }

  List<NewsData> sortNews(List<NewsData> news, String criteria) {
    switch (criteria) {
      case 'A to Z':
        news.sort(
            (a, b) => a.title!.compareTo(b.title!)); // Sort by title A to Z
        break;
      case 'Z to A':
        news.sort(
            (a, b) => b.title!.compareTo(a.title!)); // Sort by title Z to A
        break;
      case 'Time':
        // Sort by published date (newest first)
        news.sort((a, b) {
          // Assuming the date is in a format like "2024-11-30T12:30:00Z"
          DateTime dateA = DateTime.parse(a.date!);
          DateTime dateB = DateTime.parse(b.date!);
          return dateB.compareTo(dateA); // Newest first
        });
        break;
    }
    return news;
  }

  void onSortOptionChanged(String option) {
    setState(() {
      selectedSortOption = option;
      futureNews = fetchAndSortNews(); // Refetch and apply new sort order
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: Text(
          '${widget.category} News',
          style: const TextStyle(
            fontSize: 20.0,
            color: logoBlackColor,
            fontFamily: 'PoppinsMedium',
          ),
        ),
        actions: [
          PopupMenuButton<String>(
            onSelected: onSortOptionChanged,
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'A to Z',
                child: Text('Sort A to Z'),
              ),
              const PopupMenuItem(
                value: 'Z to A',
                child: Text('Sort Z to A'),
              ),
              const PopupMenuItem(
                value: 'Time',
                child: Text('Sort by Time'),
              ),
            ],
            icon: const Icon(Icons.sort),
          ),
        ],
      ),
      body: FutureBuilder<List<NewsData>>(
        future: futureNews,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(color: secondaryColor,));
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
                child: Text(
              'No news available for this category.',
              style: TextStyle(
                fontSize: 13.0,
                color: Colors.grey,
                fontFamily: 'PoppinsRegular',
              ),
            ));
          } else {
            newsList = snapshot.data!;
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: ListView(
                children: newsList.map((data) => NewsListTile(data)).toList(),
              ),
            );
          }
        },
      ),
    );
  }
}

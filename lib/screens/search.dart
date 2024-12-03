import 'package:flutter/material.dart';
import 'package:newsbee/Models/news_model.dart';
import 'package:newsbee/screens/news_view.dart';

import '../Components/color.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  late Future<List<NewsData>> futureNews;
  TextEditingController searchController = TextEditingController();
  List<NewsData> filteredNews = [];
  List<NewsData> allNews = []; // To store the original list of news data

  @override
  void initState() {
    super.initState();
    futureNews = NewsData.fetchNews(); // Call fetchNews() to load news data
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: const Text(
          'Search',
          style: TextStyle(
            fontSize: 20.0,
            color: logoBlackColor,
            fontFamily: 'PoppinsMedium',
          ),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: searchController,
              onChanged: (query) {
                setState(() {
                  // Update the filtered news list whenever text changes
                  filteredNews = filterNews(query);
                });
              },
              decoration: InputDecoration(
                hintText: 'Search news...',
                hintStyle: const TextStyle(
                  color: Colors.grey,
                  fontSize: 14,
                  fontFamily: 'PoppinsRegular',
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14.0),
                ),
                prefixIcon: const Icon(Icons.search),
              ),
              style: const TextStyle(
                fontSize: 12.0,
                color: logoBlackColor,
                fontFamily: 'PoppinsRegular',
              ),
            ),
          ),
          Expanded(
            child: FutureBuilder<List<NewsData>>(
              future: futureNews,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator(color: secondaryColor,));
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('No news available.'));
                } else {
                  // Store the news data in the allNews list when fetched
                  allNews = snapshot.data!;

                  // Use filtered news if there is a search query, otherwise show all news
                  List<NewsData> newsToShow =
                      searchController.text.isEmpty ? allNews : filteredNews;

                  return ListView.builder(
                    itemCount: newsToShow.length,
                    itemBuilder: (context, index) {
                      NewsData data = newsToShow[index];
                      return InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DetailsScreen(data),
                            ),
                          );
                        },
                        child: Card(
                          color: Colors.white,
                          margin: const EdgeInsets.symmetric(
                              vertical: 8.0, horizontal: 16.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14.0),
                          ),
                          child: ListTile(
                            leading: ClipRRect(
                              borderRadius: BorderRadius.circular(10.0),
                              child: Image.network(
                                data.urlToImage ??
                                    'assets/Newsbee_single_bg.png',
                                width: 60,
                                height: 60,
                                fit: BoxFit.cover,
                              ),
                            ),
                            title: Text(
                              data.title ?? 'No Title',
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 14.0,
                                color: logoBlackColor,
                                fontFamily: 'PoppinsMedium',
                              ),
                            ),
                            subtitle: Text(
                              data.author ?? 'Unknown Author',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 12.0,
                                color: Colors.grey,
                                fontFamily: 'PoppinsMedium',
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  // Filter news based on the query
  List<NewsData> filterNews(String query) {
    // Filter the news list by matching the title or content with the query
    return allNews.where((newsItem) {
      return newsItem.title!.toLowerCase().contains(query.toLowerCase()) ||
          newsItem.content!.toLowerCase().contains(query.toLowerCase());
    }).toList();
  }
}

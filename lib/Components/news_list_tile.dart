import 'package:flutter/material.dart';
import 'package:newsbee/Components/color.dart';
import 'package:newsbee/Models/news_model.dart';
import '../screens/news_view.dart';

class NewsListTile extends StatefulWidget {
  const NewsListTile(this.data, {super.key});
  final NewsData data;

  @override
  State<NewsListTile> createState() => _NewsListTileState();
}

class _NewsListTileState extends State<NewsListTile> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetailsScreen(widget.data),
          ),
        );
      },
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.only(bottom: 20.0),
        padding: const EdgeInsets.all(12.0),
        height: 130,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(26.0),
        ),
        child: Row(
          children: [
            Flexible(
              flex: 3,
              child: Hero(
                tag: "${widget.data.title}",
                child: Container(
                  height: 100.0,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12.0),
                    image: DecorationImage(
                      image: widget.data.urlToImage != null
                          ? NetworkImage(widget.data.urlToImage!)
                          : const AssetImage('assets/Newsbee_single_bg.png'),
                      fit: BoxFit.fitHeight,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(
              width: 10.0,
            ),
            Flexible(
              flex: 5,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title: truncate if it's more than two lines
                  Text(
                    widget.data.title!,
                    style: const TextStyle(
                      color: logoBlackColor,
                      fontFamily: 'PoppinsSemiBold',
                      fontSize: 14.0,
                    ),
                    maxLines: 2, // Limit to 2 lines
                    overflow: TextOverflow.ellipsis, // Truncate if needed
                  ),
                  const SizedBox(
                    height: 8.0,
                  ),
                  // Description: truncate if it's more than two lines
                  Text(
                    widget.data.content!,
                    style: const TextStyle(
                      color: Colors.grey,
                      fontFamily: 'PoppinsMedium',
                      fontSize: 12.0,
                    ),
                    maxLines: 2, // Limit to 2 lines
                    overflow: TextOverflow.ellipsis, // Truncate if needed
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class NewsListScreen extends StatefulWidget {
  const NewsListScreen({super.key});

  @override
  _NewsListScreenState createState() => _NewsListScreenState();
}

class _NewsListScreenState extends State<NewsListScreen> {
  late Future<List<NewsData>> futureNews;

  @override
  void initState() {
    super.initState();
    futureNews = NewsData.fetchNews();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Breaking News'),
      ),
      body: FutureBuilder<List<NewsData>>(
        future: futureNews,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(color: secondaryColor,));
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No news available.'));
          } else {
            List<NewsData> news = snapshot.data!;
            return SingleChildScrollView(  // Add this to make the entire body scrollable
              child: Column(
                children: news.map((data) => NewsListTile(data)).toList(),
              ),
            );
          }
        },
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:newsbee/Components/color.dart';
import 'package:newsbee/Models/news_model.dart';
import 'package:newsbee/Database/bookmark_db.dart';
import 'package:newsbee/Components/news_list_tile.dart';

class BookmarkScreen extends StatefulWidget {
  const BookmarkScreen({super.key});

  @override
  _BookmarkScreenState createState() => _BookmarkScreenState();
}

class _BookmarkScreenState extends State<BookmarkScreen> {
  final BookmarkDatabase db = BookmarkDatabase();
  late Future<List<NewsData>> futureBookmarks;

  @override
  void initState() {
    super.initState();
    futureBookmarks = db.getBookmarks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,
      appBar: AppBar(
        title: const Text(
          'Bookmarks',
          style: TextStyle(
            fontSize: 20.0,
            color: logoBlackColor,
            fontFamily: 'PoppinsMedium',
          ),
        ),
        backgroundColor: primaryColor,
      ),
      body: FutureBuilder<List<NewsData>>(
        future: futureBookmarks,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
                child: CircularProgressIndicator(
              color: secondaryColor,
            ));
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
                child: Text(
              'No bookmarks available.',
              style: TextStyle(
                fontSize: 13.0,
                color: Colors.grey,
                fontFamily: 'PoppinsRegular',
              ),
            ));
          } else {
            List<NewsData> bookmarks = snapshot.data!;
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: ListView.builder(
                itemCount: bookmarks.length,
                itemBuilder: (context, index) {
                  return NewsListTile(bookmarks[index]);
                },
              ),
            );
          }
        },
      ),
    );
  }
}

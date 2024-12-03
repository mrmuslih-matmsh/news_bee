import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:newsbee/Components/color.dart';
import 'package:newsbee/Models/news_model.dart';
import 'package:newsbee/Database/bookmark_db.dart';

class DetailsScreen extends StatefulWidget {
  final NewsData data;

  DetailsScreen(this.data, {Key? key}) : super(key: key);

  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  double fontSize = 14.0; // Default font size
  bool isBookmarked = false; // Track if the article is bookmarked
  late FlutterTts flutterTts;
  final BookmarkDatabase db = BookmarkDatabase(); // Initialize the bookmark database

  @override
  void initState() {
    super.initState();
    flutterTts = FlutterTts();
    _checkBookmark(); // Check the initial bookmark status
  }

  // Function to handle text-to-speech reading
  void _readAloud() async {
    if (widget.data.content != null && widget.data.content!.isNotEmpty) {
      await flutterTts.speak(widget.data.content!);
      _showSpeakAlert(); // Show speak alert
    } else {
      _showContentAlert(); // Show content unavailable alert
    }
  }

  // Function to check if the article is bookmarked
  void _checkBookmark() async {
    bool bookmarked = await db.isBookmarked(widget.data.title!);
    setState(() {
      isBookmarked = bookmarked;
    });
  }

  // Function to toggle the bookmark status
  void _toggleBookmark() async {
    if (isBookmarked) {
      await db.deleteBookmark(widget.data.title!);
      _showBookmarkRemovedAlert(); // Show bookmark removed alert
    } else {
      await db.insertBookmark(widget.data);
      _showBookmarkAddedAlert(); // Show bookmark added alert
    }
    setState(() {
      isBookmarked = !isBookmarked;
    });
  }

  // Function to increase font size
  void _increaseFontSize() {
    setState(() {
      if (fontSize < 28.0) {
        fontSize += 2.0;
      }
    });
  }

  // Function to decrease font size
  void _decreaseFontSize() {
    setState(() {
      if (fontSize > 12.0) {
        fontSize -= 2.0;
      }
    });
  }

  // Show alert for bookmark added
  void _showBookmarkAddedAlert() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Bookmark Added!'),
        backgroundColor: Colors.green,
      ),
    );
  }

  // Show alert for bookmark removed
  void _showBookmarkRemovedAlert() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Bookmark Removed!'),
        backgroundColor: Colors.red,
      ),
    );
  }

  // Show alert when content is unavailable for text-to-speech
  void _showContentAlert() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('No content available for reading aloud'),
        backgroundColor: Colors.orange,
      ),
    );
  }

  // Show alert when text-to-speech starts
  void _showSpeakAlert() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Speaking the article...'),
        backgroundColor: Colors.blue,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,
      appBar: AppBar(
        backgroundColor: primaryColor,
        elevation: 0.0,
        iconTheme: const IconThemeData(color: secondaryColor),
        actions: [
          IconButton(
            icon: Icon(
              isBookmarked ? Icons.bookmark : Icons.bookmark_border,
              color: secondaryColor,
            ),
            onPressed: _toggleBookmark,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.data.title ?? "No Title Available",
              style: const TextStyle(
                fontSize: 18.0,
                color: logoBlackColor,
                fontFamily: 'PoppinsSemiBold',
              ),
            ),
            const SizedBox(height: 8.0),
            Text(
              widget.data.author ?? "Unknown Author",
              style: const TextStyle(
                fontSize: 14.0,
                color: Colors.grey,
                fontFamily: 'PoppinsMedium',
              ),
            ),
            const SizedBox(height: 20.0),
            Hero(
              tag: "${widget.data.title}",
              child: ClipRRect(
                borderRadius: BorderRadius.circular(22.0),
                child: widget.data.urlToImage != null
                    ? Image.network(widget.data.urlToImage!)
                    : const Icon(
                  Icons.image,
                  size: 100,
                  color: Colors.grey,
                ),
              ),
            ),
            const SizedBox(height: 30.0),
            // Font Size Adjustment and Read Aloud on the same row
            Row(
              mainAxisAlignment:
              MainAxisAlignment.spaceBetween, // Space the items evenly
              children: [
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.remove, color: secondaryColor),
                      onPressed: _decreaseFontSize,
                    ),
                    Text(
                      'Font Size: ${fontSize.toInt()}',
                      style: const TextStyle(
                        fontSize: 14.0,
                        fontFamily: 'PoppinsSemiBold',
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.add, color: secondaryColor),
                      onPressed: _increaseFontSize,
                    ),
                  ],
                ),
                IconButton(
                  icon: const Icon(Icons.volume_up, color: secondaryColor),
                  onPressed: _readAloud,
                  iconSize: 30.0,
                ),
              ],
            ),
            const SizedBox(height: 15.0),
            Text(
              widget.data.content ?? "No Content Available",
              style: TextStyle(
                fontSize: fontSize,
                color: logoBlackColor,
                fontFamily: 'PoppinsRegular',
              ),
            ),
          ],
        ),
      ),
    );
  }
}

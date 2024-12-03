import 'package:flutter/material.dart';
import 'package:newsbee/Models/news_model.dart';

import '../Components/color.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  late Future<List<NewsData>> futureNotifications;

  @override
  void initState() {
    super.initState();
    // Fetch the notifications (new news arrivals)
    futureNotifications = fetchNewNewsArrivals();
  }

  Future<List<NewsData>> fetchNewNewsArrivals() async {
    // Simulate fetching notifications for new news arrivals
    return await NewsData.fetchNews(); // Fetch news from the NewsData model
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: const Text(
          'Notifications',
          style: TextStyle(
            fontSize: 20.0,
            color: logoBlackColor,
            fontFamily: 'PoppinsMedium',
          ),
        ),
      ),
      body: FutureBuilder<List<NewsData>>(
        future: futureNotifications,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(color: secondaryColor,));
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
                child: Text(
              'No new notifications.',
              style: TextStyle(
                fontSize: 13.0,
                color: Colors.grey,
                fontFamily: 'PoppinsRegular',
              ),
            ));
          } else {
            List<NewsData> notifications = snapshot.data!;
            return ListView.builder(
              itemCount: notifications.length,
              itemBuilder: (context, index) {
                final news = notifications[index];
                return ListTile(
                  leading: const Icon(
                    Icons.notifications,
                    size: 30,
                    color: secondaryColor,
                  ),
                  title: Text(
                    news.title ?? 'Untitled News',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 14.0,
                      color: logoBlackColor,
                      fontFamily: 'PoppinsMedium',
                    ),
                  ),
                  subtitle: Text(
                    'Published: ${formatDate(news.date)}',
                    style: const TextStyle(
                      fontSize: 14.0,
                      color: Colors.grey,
                      fontFamily: 'PoppinsRegular',
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }

  // Helper to format the date for display
  String formatDate(String? date) {
    if (date == null) return 'Unknown';
    try {
      final parsedDate = DateTime.parse(date);
      return '${parsedDate.year}-${parsedDate.month.toString().padLeft(2, '0')}-${parsedDate.day.toString().padLeft(2, '0')}';
    } catch (e) {
      return 'Invalid date';
    }
  }
}

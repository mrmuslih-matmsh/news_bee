import 'dart:convert';
import 'package:http/http.dart' as http;

class NewsData {
  String? title;
  String? author;
  String? content;
  String? urlToImage;
  String? date;

  NewsData(
    this.title,
    this.author,
    this.content,
    this.date,
    this.urlToImage,
  );

  // Convert NewsData to a Map for SQLite
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'author': author,
      'content': content,
      'urlToImage': urlToImage,
      'date': date,
    };
  }

  // Create a NewsData object from a Map (for SQLite)
  factory NewsData.fromMap(Map<String, dynamic> map) {
    return NewsData(
      map['title'],
      map['author'],
      map['content'],
      map['date'],
      map['urlToImage'],
    );
  }

  // Method to fetch news with an optional category filter
  static Future<List<NewsData>> fetchNews({String? category}) async {
    const String apiKey = '0ce053c63e204d0c89ad47f81b463faf';
    String url =
        'https://newsapi.org/v2/top-headlines?country=us&apiKey=$apiKey';

    // Add category filter if provided
    if (category != null && category.isNotEmpty) {
      url += '&category=$category';
    }

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      List<dynamic> articles = data['articles'];

      return articles.map((article) {
        return NewsData(
          article['title'] ?? '',
          article['author'] ?? '',
          article['content'] ?? '',
          article['publishedAt'] ?? '',
          article['urlToImage'] ?? '',
        );
      }).toList();
    } else {
      throw Exception('Failed to load news');
    }
  }
}

import 'package:flutter/material.dart';
import 'package:newsbee/Components/color.dart';
import 'package:newsbee/Models/news_model.dart';
import 'package:newsbee/screens/news_view.dart';

class BreakingNewsCard extends StatelessWidget {
  final NewsData data;

  const BreakingNewsCard(this.data, {super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        // Navigate to the details screen when tapped
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetailsScreen(data),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(26.0),
          image: DecorationImage(
            fit: BoxFit.fill,
            image: data.urlToImage != null
                ? NetworkImage(data.urlToImage!)
                : const AssetImage('assets/Newsbee_single_bg.png') as ImageProvider,
          ),
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30.0),
            gradient: const LinearGradient(
              colors: [Colors.transparent, secondaryColor],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title with maxLines and overflow handling
              Text(
                data.title ?? 'No Title',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontFamily: 'PoppinsSemiBold',
                ),
                maxLines: 2, // Limit title to 2 lines
                overflow: TextOverflow.ellipsis, // Truncate if it's too long
              ),
              const SizedBox(
                height: 8.0,
              ),
              // Author with maxLines and overflow handling
              Text(
                data.author ?? 'Unknown Author',
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 14,
                  fontFamily: 'PoppinsMedium',
                ),
                maxLines: 2, // Limit author to 2 lines
                overflow: TextOverflow.ellipsis, // Truncate if it's too long
              ),
            ],
          ),
        ),
      ),
    );
  }
}

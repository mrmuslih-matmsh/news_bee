import 'package:flutter/material.dart';
import '../Components/color.dart';
import 'category_view.dart'; // Import the category detail screen

class CategoryScreen extends StatelessWidget {
  // Sample list of categories
  final List<String> categories = [
    'Technology',
    'Business',
    'Health',
    'Science',
    'Sports',
    'Entertainment',
    'Education',
    'Lifestyle',
  ];

// Matching icons for categories
  final List<IconData> categoryIcons = [
    Icons.computer,
    Icons.business,
    Icons.health_and_safety,
    Icons.science,
    Icons.sports_soccer,
    Icons.movie,
    Icons.school,
    Icons.local_activity,
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: const Text(
          'Categories',
          style: TextStyle(
            fontSize: 20.0,
            color: logoBlackColor,
            fontFamily: 'PoppinsMedium',
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 8.0,
            mainAxisSpacing: 8.0,
            childAspectRatio: 1,
          ),
          itemCount: categories.length,
          itemBuilder: (context, index) {
            final category = categories[index];
            final icon = categoryIcons[index];

            return InkWell(
              onTap: () {
                // Navigate to CategoryDetailScreen with the selected category
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        CategoryDetailScreen(category: category),
                  ),
                );
              },
              child: Card(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14.0),
                ),
                elevation: 4,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      icon,
                      size: 40.0,
                      color: secondaryColor,
                    ),
                    const SizedBox(height: 8.0),
                    Text(
                      category,
                      style: const TextStyle(
                        fontSize: 14.0,
                        fontFamily: 'PoppinsMedium',
                        color: logoBlackColor,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

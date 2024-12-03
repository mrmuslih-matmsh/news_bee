import 'package:flutter/material.dart';
import 'package:newsbee/Components/color.dart';
import 'package:newsbee/screens/news_app.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Set a delay before navigating to the home screen
    Future.delayed(const Duration(seconds: 4), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => NewsApp()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: primaryColor,
      body: Padding(
        padding: EdgeInsets.symmetric(vertical: 40.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 50.0),
              // Logo image
              Image(
                image: AssetImage('assets/newsbee_trans.png'),
                width: 185.0, // Adjust the size as needed
                height: 185.0,
              ),
              // Title
              Spacer(), // Adds space between elements
              // Developer info
              Text(
                'Developed by: Mohammed Muslih',
                style: TextStyle(
                  fontSize: 12.0,
                  color: Colors.grey,
                  fontFamily: "PoppinsMedium",
                ),
              ),
              SizedBox(height: 7.0),
              // Version info
              Text(
                'Version: 1.0.0',
                style: TextStyle(
                  fontSize: 12.0,
                  color: Colors.grey,
                  fontFamily: "PoppinsMedium",
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

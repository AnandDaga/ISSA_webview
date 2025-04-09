import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter_windowmanager/flutter_windowmanager.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'dart:async';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  MyHomePageState createState() => MyHomePageState();
}

class MyHomePageState extends State<MyHomePage> with SingleTickerProviderStateMixin {
  late WebViewController controller;
  bool isLoading = true; // Track loading state for the WebView
  bool isError = false; // Track if there's an error loading the WebView
  bool hasMinTimeElapsed = false; // Ensure the spinner shows for at least 3 seconds
  late AnimationController animationController; // Required for vsync with SpinKit

  // Security setup for the screen
  secureScreen() async {
    await FlutterWindowManager.addFlags(FlutterWindowManager.FLAG_SECURE);
    await FlutterWindowManager.addFlags(FlutterWindowManager.FLAG_FULLSCREEN);
  }

  @override
  void initState() {
    super.initState();
    secureScreen();

    // Initialize the animation controller for SpinKit
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(); // Repeat the animation until stopped

    // Ensure the spinner shows for at least 3 seconds
    Future.delayed(const Duration(seconds: 3), () {
      setState(() {
        hasMinTimeElapsed = true;
      });
    });

    // Initialize WebView controller and listen for page loading events
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (String url) {
            setState(() {
              isError = false; // Reset the error state on page load start
              isLoading = true;
            });
          },
          onPageFinished: (String url) {
            setState(() {
              isLoading = false;
              animationController.stop(); // Stop the animation when the WebView is ready
            });
          },
          onWebResourceError: (WebResourceError error) {
            setState(() {
              isError = true; // Show an error if the page fails to load
              isLoading = false;
              animationController.stop(); // Stop animation in case of error
            });
          },
        ),
      )
      ..loadRequest(Uri.parse('https://issaquizquest.web.app'));
  }

  @override
  void dispose() {
    animationController.dispose(); // Dispose of the animation controller
    super.dispose();
  }

  // Retry loading the WebView
  void _retryLoading() {
    setState(() {
      isLoading = true;
      isError = false;
      animationController.repeat(); // Restart the spinner animation
      controller.loadRequest(Uri.parse('https://issaquizquest.web.app'));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          if (!isError && !isLoading) // Show WebView if there's no error and not loading
            WebViewWidget(controller: controller),
          
          if (isLoading || !hasMinTimeElapsed) // Show loading spinner
            Center(
              child: SpinKitSquareCircle(
                color: Colors.blue,
                size: 50.0,
                controller: animationController,
              ),
            ),
          
          if (isError) // Show an error message and refresh button if there's an error
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    '',
                    style: TextStyle(color: Colors.red, fontSize: 18),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _retryLoading, // Retry loading WebView on button press
                    child: const Text('Retry'),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

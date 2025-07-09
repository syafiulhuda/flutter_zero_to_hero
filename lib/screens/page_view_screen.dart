import 'package:flutter/material.dart';
import 'package:flutter_zth/data/constants.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class PageViewScreen extends StatefulWidget {
  const PageViewScreen({super.key});

  @override
  State<PageViewScreen> createState() => _PageViewScreenState();
}

class _PageViewScreenState extends State<PageViewScreen> {
  final _controller = PageController(initialPage: 0, viewportFraction: 0.8);

  final List<Map<String, dynamic>> pages = [
    {"color": Colors.red, "label": "Red"},
    {"color": Colors.blue, "label": "Blue"},
    {"color": Colors.greenAccent, "label": "Green"},
    {"color": Colors.yellow.shade700, "label": "Yellow"},
  ];

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: KTextStyle.generalColor(context),
        title: const Text("Page View"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: screenHeight * 0.45,
            child: PageView.builder(
              controller: _controller,
              itemCount: pages.length,
              itemBuilder: (context, index) {
                final double pageOffset =
                    _controller.hasClients && _controller.page != null
                        ? (_controller.page! - index).abs()
                        : 0.0;

                final double scale = (1 - (pageOffset * 0.3)).clamp(0.0, 1.0);

                return Transform.scale(
                  scale: Curves.easeOut.transform(scale),
                  child: Container(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 20,
                    ),
                    decoration: BoxDecoration(
                      color: pages[index]["color"],
                      borderRadius: BorderRadius.circular(28),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: .15),
                          blurRadius: 15,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Text(
                        pages[index]["label"],
                        style: const TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 10),
          SmoothPageIndicator(
            controller: _controller,
            count: pages.length,
            effect: const ExpandingDotsEffect(
              dotHeight: 10,
              dotWidth: 10,
              activeDotColor: Colors.deepPurple,
              dotColor: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}

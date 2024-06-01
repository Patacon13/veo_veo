import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

class RepositorioCarousel extends StatelessWidget {
  final List<String> urls;
  final Function(String) onImageTap;

  const RepositorioCarousel({
    required this.urls,
    required this.onImageTap,
  });

  @override
  Widget build(BuildContext context) {
    return CarouselSlider(
      options: CarouselOptions(
        height: 200,
        enlargeCenterPage: true,
        autoPlay: true,
      ),
      items: urls.map((url) {
        return Builder(
          builder: (BuildContext context) {
            return GestureDetector(
              onTap: () => onImageTap(url),
              child: Container(
                width: MediaQuery.of(context).size.width,
                margin: const EdgeInsets.symmetric(horizontal: 5.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Image.network(url, fit: BoxFit.cover),
              ),
            );
          },
        );
      }).toList(),
    );
  }
}

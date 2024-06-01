import 'package:flutter/material.dart';

class Cuadricula extends StatelessWidget {
  final List<String> urls;
  final Function(String) onImageTap;

  const Cuadricula({
    required this.urls,
    required this.onImageTap,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 3,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: urls.map((url) {
        return GestureDetector(
          onTap: () => onImageTap(url),
          child: Container(
            margin: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Colors.grey.withOpacity(0.3),
            ),
            child: Image.network(url, fit: BoxFit.cover),
          ),
        );
      }).toList(),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class InnerBannerScreen extends StatelessWidget {
  final String image;

  const InnerBannerScreen({super.key, required this.image});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        height: 170,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: const Color(0xFFF7F7F7),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.network(
            image,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}

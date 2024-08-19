import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:markflip/provider/category_provider.dart';
import 'package:markflip/views/screens/inner_screens/inner_category_screen.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class CategoriesTile extends StatelessWidget {
  final String imageUrl;
  final String title;

  const CategoriesTile({
    Key? key,
    required this.imageUrl,
    required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin:const EdgeInsets.symmetric(horizontal: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50),
              color: Colors.grey[200],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(50),
              child: CachedNetworkImage(
                imageUrl: imageUrl,
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            width: 110,
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: GoogleFonts.roboto(
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

class CategoryItem extends StatefulWidget {
  const CategoryItem({Key? key}) : super(key: key);

  @override
  State<CategoryItem> createState() => _CategoryItemState();
}

class _CategoryItemState extends State<CategoryItem>
    with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  late Future<void> _categoriesFuture;
  final ScrollController _scrollController = ScrollController();
  late Timer _timer;
  double _scrollPosition = 0.0;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(Duration(seconds: 5), (Timer timer) {
      _scrollPosition += 100;
      if (_scrollPosition >= _scrollController.position.maxScrollExtent) {
        _scrollPosition = 0;
      }
      _scrollController.animateTo(_scrollPosition,
          duration: Duration(milliseconds: 500), curve: Curves.easeInOut);
    });

    // Initialize the category loading process
    final categoryProvider =
        Provider.of<CategoryProvider>(context, listen: false);
    _categoriesFuture = categoryProvider.loadCategories();
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final categoryProvider = Provider.of<CategoryProvider>(context);

    return FutureBuilder<void>(
      future: _categoriesFuture,
      builder: (context, snapshot) {
        if (categoryProvider.isLoading) {
          return _buildShimmerCategories();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (categoryProvider.categories.isEmpty) {
          return const Text('No categories found');
        } else {
          return Container(
            margin: const EdgeInsets.only(top: 6),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              controller: _scrollController,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: List.generate(
                  (categoryProvider.categories.length / 7)
                      .ceil(), // Calculate number of sets of 7 categories
                  (setIndex) {
                    final start = setIndex * 7;
                    final end = (setIndex + 1) * 7;
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: categoryProvider.categories
                            .sublist(
                                start,
                                end > categoryProvider.categories.length
                                    ? categoryProvider.categories.length
                                    : end)
                            .map((category) => InkWell(
                                  onTap: () {
                                    Navigator.push(context,
                                        MaterialPageRoute(builder: (context) {
                                      return InnerCategoryScreen(
                                          categoryModel: category);
                                    }));
                                  },
                                  child: CategoriesTile(
                                    imageUrl: category.image,
                                    title: category.name,
                                  ),
                                ))
                            .toList(),
                      ),
                    );
                  },
                ),
              ),
            ),
          );
        }
      },
    );
  }

  Widget _buildShimmerCategories() {
    return GridView.builder(
      shrinkWrap: true,
      itemCount: 6, // Placeholder for shimmer effect
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        mainAxisSpacing: 4,
        crossAxisSpacing: 4,
      ),
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Container(
            width: 83,
            height: 99,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        );
      },
    );
  }

  Widget _buildShimmerImage() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        width: 47,
        height: 47,
        color: Colors.white,
      ),
    );
  }

  @override
  void dispose() {
    _timer.cancel();
    _scrollController.dispose();
    super.dispose();
  }
}

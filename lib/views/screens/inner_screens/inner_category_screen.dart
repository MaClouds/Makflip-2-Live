import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:markflip/models/category_models.dart';
import 'package:markflip/models/product_model.dart';
import 'package:markflip/views/screens/bottomNavigationScreens/cart_screen.dart';
import 'package:markflip/views/screens/bottomNavigationScreens/categories_page.dart';
import 'package:markflip/views/screens/bottomNavigationScreens/profiile_screen.dart';
import 'package:markflip/views/screens/inner_screens/inner_category/inner_product_screen_by_sub_category.dart';
import 'package:markflip/models/sub_category_models.dart';
import 'package:markflip/services/product_service.dart';
import 'package:markflip/services/subcategory_service.dart';
import 'package:markflip/views/screens/bottomNavigationScreens/widgets/product_item.dart';
import 'package:markflip/views/screens/bottomNavigationScreens/widgets/reuseText_widget.dart';
import 'package:markflip/views/screens/bottomNavigationScreens/widgets/reuseable_search.dart';
import 'package:markflip/views/screens/inner_screens/inner_category/inner_banner_screen.dart';
import 'package:shimmer/shimmer.dart';

class InnerCategoryScreen extends StatefulWidget {
  final CategoryModel categoryModel;

  const InnerCategoryScreen({super.key, required this.categoryModel});

  @override
  _InnerCategoryProductsScreenState createState() =>
      _InnerCategoryProductsScreenState();
}

class _InnerCategoryProductsScreenState extends State<InnerCategoryScreen>
    with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  late Future<List<SubCategoryModels>> _subcategoriesFuture;
  late Future<List<ProductModel>> _productsFuture;
  final SubCategoryService _subCategoryService = SubCategoryService();
  final ProductService _productService =
      ProductService(); // Instantiate ProductService
  final ScrollController _scrollController = ScrollController();
  late Timer _timer;
  double _scrollPosition = 0.0;

  @override
  void initState() {
    super.initState();
    _subcategoriesFuture = _subCategoryService
        .getSubCategoriesByCategoryName(widget.categoryModel.name);
    _productsFuture = _productService.loadProductsByCategory(
        widget.categoryModel.name); // Call the method using the instance

    _timer = Timer.periodic(Duration(seconds: 5), (Timer timer) {
      _scrollPosition += 100;
      if (_scrollPosition >= _scrollController.position.maxScrollExtent) {
        _scrollPosition = 0;
      }
      _scrollController.animateTo(_scrollPosition,
          duration: Duration(milliseconds: 500), curve: Curves.easeInOut);
    });

    pages = [
      HomeScreenContent(categoryModel: widget.categoryModel),
      const CategoriesPage(),
      // const GroceryScreen(),
      const CartScreen(),
      const ProfilePage(),
    ];
  }

  @override
  bool get wantKeepAlive => true;

  late List<Widget> pages;

  int pageIndex = 0;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      body: pages[pageIndex],
      bottomNavigationBar: BottomNavigationBar(
        onTap: (value) {
          setState(() {
            pageIndex = value;
          });
        },
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.purple,
        currentIndex: pageIndex,
        unselectedItemColor: Colors.grey,
        items: [
          BottomNavigationBarItem(
            backgroundColor: Colors.white.withOpacity(0.95),
            icon: Image.asset(
              'assets/icons/home.png',
              width: 25,
            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              'assets/Palette1.png',
              height: 24,
              width: 24,
            ),
            label: 'categories',
          ),
          //  BottomNavigationBarItem(
          //     icon: Image.asset(
          //       'assets/brand 1.png',
          //       height: 24,
          //       width: 60,
          //     ),
          //     label: 'Grocery',
          //   ),
          BottomNavigationBarItem(
            icon: Image.asset(
              'assets/Cart1.png',
              height: 24,
              width: 24,
            ),
            label: 'Cart',
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              'assets/User1.png',
              height: 24,
              width: 24,
            ),
            label: 'Profile',
          ),
        ],
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

class HomeScreenContent extends StatefulWidget {
  final CategoryModel categoryModel;

  const HomeScreenContent({super.key, required this.categoryModel});

  @override
  _HomeScreenContentState createState() => _HomeScreenContentState();
}

class _HomeScreenContentState extends State<HomeScreenContent>
    with AutomaticKeepAliveClientMixin {
  late Future<List<SubCategoryModels>> _subcategoriesFuture;
  late Future<List<ProductModel>> _productsFuture;
  final SubCategoryService _subCategoryService = SubCategoryService();
  final ProductService _productService = ProductService();
  final ScrollController _scrollController = ScrollController();
  late Timer _timer;
  double _scrollPosition = 0.0;

  @override
  void initState() {
    super.initState();
    _subcategoriesFuture = _subCategoryService
        .getSubCategoriesByCategoryName(widget.categoryModel.name);
    _productsFuture =
        _productService.loadProductsByCategory(widget.categoryModel.name);

    _timer = Timer.periodic(const Duration(seconds: 5), (Timer timer) {
      _scrollPosition += 100;
      if (_scrollPosition >= _scrollController.position.maxScrollExtent) {
        _scrollPosition = 0;
      }
      _scrollController.animateTo(_scrollPosition,
          duration: const Duration(milliseconds: 500), curve: Curves.easeInOut);
    });
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: PreferredSize(
        preferredSize:
            Size.fromHeight(MediaQuery.of(context).size.height * 0.13),
        child: const ReusableSearchWidget(),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            InnerBannerScreen(image: widget.categoryModel.banner),
            Center(
              child: Text(
                'Shop By Category',
                style: GoogleFonts.raleway(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            FutureBuilder<List<SubCategoryModels>>(
              future: _subcategoriesFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const LinearProgressIndicator(
                    color: Colors.purple,
                  );
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Text('No subcategories found');
                } else {
                  return Container(
                    margin: const EdgeInsets.only(top: 6),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      controller: _scrollController,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: List.generate(
                          (snapshot.data!.length / 7).ceil(),
                          (setIndex) {
                            final start = setIndex * 7;
                            final end = (setIndex + 1) * 7;
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: snapshot.data!
                                    .sublist(
                                        start,
                                        end > snapshot.data!.length
                                            ? snapshot.data!.length
                                            : end)
                                    .map((subcategory) => InkWell(
                                          onTap: () {
                                            Navigator.push(context,
                                                MaterialPageRoute(
                                                    builder: (context) {
                                              return InnerProductScreenBySubCategory(
                                                  subCategory: subcategory
                                                      .subcategoryName);
                                            }));
                                          },
                                          child: CategoriesTile(
                                            imageUrl: subcategory.image,
                                            title: subcategory.subcategoryName,
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
            ),
            const ResuseTextWidget(
                title: 'Recommend for you', subtitle: 'View all'),
            FutureBuilder<List<ProductModel>>(
              future: _productsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return _buildShimmerEffect();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Text('No products found');
                } else {
                  return SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: _buildProductList(snapshot.data!),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductList(List<ProductModel> products) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: products.map((productData) {
          return ProductItemWidget(productModel: productData);
        }).toList(),
      ),
    );
  }

  Widget _buildShimmerEffect() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(5, (index) {
          // Shimmer effect for each product item
          return _buildShimmerItem();
        }),
      ),
    );
  }

  Widget _buildShimmerItem() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8.0),
      width: 150.0,
      height: 245.0,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.0),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.grey[200]!, Colors.grey[300]!, Colors.grey[200]!],
          stops: const [0.1, 0.5, 0.9],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      child: Shimmer.fromColors(
        baseColor: Colors.grey[200]!,
        highlightColor: Colors.grey[100]!,
        period:
            const Duration(milliseconds: 1200), // Duration of shimmer animation
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(12.0),
                    topRight: Radius.circular(12.0),
                  ),
                  color: Colors.grey[200]!,
                ),
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 10.0, vertical: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 120.0,
                    height: 15.0,
                    color: Colors.grey[200]!,
                  ),
                  const SizedBox(height: 8.0),
                  Container(
                    width: 100.0,
                    height: 12.0,
                    color: Colors.grey[200]!,
                  ),
                  const SizedBox(height: 6.0),
                  Container(
                    width: 140.0,
                    height: 12.0,
                    color: Colors.grey[200]!,
                  ),
                ],
              ),
            ),
          ],
        ),
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
      margin: const EdgeInsets.symmetric(horizontal: 4),
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

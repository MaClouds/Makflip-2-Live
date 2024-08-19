import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:markflip/models/product_model.dart';
import 'package:markflip/services/product_service.dart';
import 'package:markflip/views/screens/bottomNavigationScreens/widgets/product_item.dart';

class InnerProductScreenBySubCategory extends StatefulWidget {
  final String subCategory;

  const InnerProductScreenBySubCategory({Key? key, required this.subCategory})
      : super(key: key);

  @override
  State<InnerProductScreenBySubCategory> createState() =>
      _InnerProductScreenBySubCategoryState();
}

class _InnerProductScreenBySubCategoryState
    extends State<InnerProductScreenBySubCategory> {
  final ProductService productService = ProductService();
  late Future<List<ProductModel>> _futureProducts;

  @override
  void initState() {
    super.initState();
    _futureProducts =
        productService.loadProductsBySubCategory(widget.subCategory);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.subCategory,
          style: GoogleFonts.raleway(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            letterSpacing: 2,
          ),
        ),
      ),
      body: FutureBuilder<List<ProductModel>>(
        future: _futureProducts,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No products found.'));
          } else {
            List<ProductModel> products = snapshot.data!;
            return GridView.builder(
              padding: const EdgeInsets.all(8.0),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.75,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
              ),
              itemCount: products.length,
              itemBuilder: (context, index) {
                return ProductItemWidget(productModel: products[index]);
              },
            );
          }
        },
      ),
    );
  }
}

// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:markflip/models/sub_category_models.dart';
// import 'package:markflip/services/subcategory_service.dart';

// class GroceryScreen extends StatefulWidget {
//   const GroceryScreen({Key? key}) : super(key: key);

//   @override
//   _GroceryScreenState createState() => _GroceryScreenState();
// }

// class _GroceryScreenState extends State<GroceryScreen> {
//   late Future<List<SubCategoryModels>> _grocerySubcategoriesFuture;
//   final ScrollController _scrollController = ScrollController();
//   late Timer _timer;
//   double _scrollPosition = 0.0;

//   @override
//   void initState() {
//     super.initState();
//     _timer = Timer.periodic(Duration(seconds: 5), (Timer timer) {
//       _scrollPosition += 100;
//       if (_scrollPosition >= _scrollController.position.maxScrollExtent) {
//         _scrollPosition = 0;
//       }
//       _scrollController.animateTo(
//         _scrollPosition,
//         duration: Duration(milliseconds: 500),
//         curve: Curves.easeInOut,
//       );
//     });

//     final SubCategoryService subCategoryService = SubCategoryService();
//     _grocerySubcategoriesFuture = subCategoryService.getGrocerySubCategories();
//   }

//   @override
//   void dispose() {
//     _timer.cancel();
//     _scrollController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: FutureBuilder<List<SubCategoryModels>>(
//         future: _grocerySubcategoriesFuture,
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return Center(
//               child: CircularProgressIndicator(),
//             );
//           } else if (snapshot.hasError) {
//             return Center(
//               child: Text('Error: ${snapshot.error}'),
//             );
//           } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
//             return Center(
//               child: Text('No Grocery SubCategories found'),
//             );
//           } else {
//             final grocerySubcategories = snapshot.data!;
//             return GridView.builder(
//               controller: _scrollController,
//               itemCount: grocerySubcategories.length,
//               gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                 crossAxisCount: 4,
//                 mainAxisSpacing: 4,
//                 crossAxisSpacing: 4,
//               ),
//               itemBuilder: (context, index) {
//                 final subcategory = grocerySubcategories[index];
//                 return Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: GrocerySubcategoryTile(
//                     imageUrl: subcategory.image,
//                     title: subcategory.subcategoryName,
//                   ),
//                 );
//               },
//             );
//           }
//         },
//       ),
//     );
//   }
// }

// class GrocerySubcategoryTile extends StatelessWidget {
//   final String imageUrl;
//   final String title;

//   const GrocerySubcategoryTile({
//     Key? key,
//     required this.imageUrl,
//     required this.title,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: 120,
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.center,
//         children: [
//           Container(
//             width: 80,
//             height: 80,
//             decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(50),
//               color: Colors.grey[200],
//             ),
//             child: ClipRRect(
//               borderRadius: BorderRadius.circular(50),
//               child: CachedNetworkImage(
//                 imageUrl: imageUrl,
//                 fit: BoxFit.cover,
//               ),
//             ),
//           ),
//           const SizedBox(height: 8),
//           SizedBox(
//             width: 110,
//             child: Text(
//               title,
//               textAlign: TextAlign.center,
//               style: GoogleFonts.roboto(
//                 fontSize: 12,
//                 fontWeight: FontWeight.w600,
//               ),
//               overflow: TextOverflow.ellipsis,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

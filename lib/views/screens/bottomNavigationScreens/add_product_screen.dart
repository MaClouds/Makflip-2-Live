import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:markflip/models/category_models.dart';
import 'package:markflip/models/sub_category_models.dart';

import 'package:markflip/services/product_service.dart';
import 'package:markflip/services/subcategory_service.dart';
import '../../../services/category_service.dart';

class AddProductScreen extends StatefulWidget {
  const AddProductScreen({super.key});

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final CategoryService _categoryService = CategoryService();
  final SubCategoryService _subCategoryService = SubCategoryService();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final ProductService _productService = ProductService();
  late String name;
  String? selectedCategory;
  String? selectedSubCategory;
  late Future<List<CategoryModel>> _categoriesFuture;
  late Future<List<SubCategoryModels>> _subcategoryfuture;
  String? productName;
  int? productPrice;
  int? discount;
  int? quantity;
  String? description;

  @override
  void initState() {
    super.initState();
    _categoriesFuture = _loadCategories();
    _subcategoryfuture = _loadSubcategories();
  }

  Future<List<CategoryModel>> _loadCategories() async {
    return _categoryService.loadCategories();
  }

  Future<List<SubCategoryModels>> _loadSubcategories() async {
    return _subCategoryService.getAllSubCategories();
  }

  final ImagePicker picker = ImagePicker();
  List<File> image = [];
  chooseImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile == null) {
      print('no image picked');
    } else {
      setState(() {
        image.add(File(pickedFile.path));
      });
    }
  }

  uploadProduct() async {
    _productService.sellerProduct(
      context: context,
      productName: productName.toString(),
      productPrice: productPrice!.toInt(),
      discount: discount!.toInt(),
      quantity: quantity!.toInt(),
      description: description.toString(),
      subCategory: selectedSubCategory.toString(),
      pickedImages: image,
      category: selectedCategory.toString(),
    );
    _formKey.currentState!.reset();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Product'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GridView.builder(
                  shrinkWrap: true,
                  itemCount: image.length + 1,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    mainAxisSpacing: 8,
                    childAspectRatio: 3 / 3,
                  ),
                  itemBuilder: ((context, index) {
                    return index == 0
                        ? Center(
                            child: IconButton(
                              onPressed: () {
                                chooseImage();
                              },
                              icon: const Icon(Icons.add),
                            ),
                          )
                        : SizedBox(
                            width: 50,
                            height: 40,
                            child: Image.file(
                              image[index - 1],
                              width: 40,
                              height: 50,
                            ),
                          );
                  }),
                ),
                TextFormField(
                  onChanged: (value) {
                    productName = value;
                  },
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'enter field';
                    } else {
                      return null;
                    }
                  },
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Enter product name',
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: 200,
                  child: TextFormField(
                    onChanged: (value) {
                      productPrice = int.parse(value);
                    },
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'enter field';
                      } else {
                        return null;
                      }
                    },
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Enter product price',
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: 150,
                  child: TextFormField(
                    onChanged: (value) {
                      quantity = int.parse(value);
                    },
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'enter field';
                      } else {
                        return null;
                      }
                    },
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Enter quantity',
                    ),
                  ),
                ),
                SizedBox(
                  width: 150,
                  child: TextFormField(
                    onChanged: (value) {
                      discount = int.parse(value);
                    },
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'enter field';
                      } else {
                        return null;
                      }
                    },
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Enter discount',
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                const SizedBox(height: 20),
                FutureBuilder<List<CategoryModel>>(
                  future: _categoriesFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else if (snapshot.data == null ||
                        snapshot.data!.isEmpty) {
                      return const Text('No categories found');
                    } else {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Categories:'),
                          DropdownButton<String>(
                            hint: const Text('Select category'),
                            value: selectedCategory,
                            onChanged: (value) {
                              setState(() {
                                selectedCategory = value;
                                _subcategoryfuture = _loadSubcategories();
                              });
                            },
                            items: snapshot.data!
                                .map<DropdownMenuItem<String>>((category) {
                              return DropdownMenuItem<String>(
                                value: category.name,
                                child: Text(category.name),
                              );
                            }).toList(),
                          ),
                        ],
                      );
                    }
                  },
                ),
                const SizedBox(height: 10),
                FutureBuilder<List<SubCategoryModels>>(
                  future: _subcategoryfuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else if (snapshot.data == null ||
                        snapshot.data!.isEmpty) {
                      return const Text('No subcategories found');
                    } else {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Subcategories:'),
                          DropdownButton<String>(
                            hint: const Text('Select subcategory'),
                            value: selectedSubCategory,
                            onChanged: (value) {
                              setState(() {
                                selectedSubCategory = value;
                              });
                            },
                            items: snapshot.data!
                                .map<DropdownMenuItem<String>>((subcategory) {
                              return DropdownMenuItem<String>(
                                value: subcategory.subcategoryName,
                                child: Text(subcategory.subcategoryName),
                              );
                            }).toList(),
                          ),
                        ],
                      );
                    }
                  },
                ),
                TextFormField(
                  onChanged: (value) {
                    description = value;
                  },
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'enter field';
                    } else {
                      return null;
                    }
                  },
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Product description',
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomSheet: ElevatedButton(
        onPressed: () {
          if (image.isNotEmpty) {
            if (_formKey.currentState!.validate()) {
              uploadProduct();
            }
          }
        },
        child: const Text('Upload'),
      ),
    );
  }
}

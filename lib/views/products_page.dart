import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../controllers/product_controller.dart';
import '../controllers/cart_controller.dart';
import '../controllers/favorites_controller.dart';
import '../routes/app_routes.dart';
import '../models/product_model.dart';

class ProductsPage extends StatelessWidget {
  final ProductController productController = Get.find();
  final CartController cartController = Get.find();
  final FavoritesController favoritesController = Get.find();
  final TextEditingController searchController = TextEditingController();

  ProductsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Products'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => productController.fetchProducts(),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showProductDialog(context),
        child: const Icon(Icons.add),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                hintText: 'Search',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onChanged: (value) {
                productController.products.refresh();
              },
            ),
          ),
          Expanded(
            child: Obx(() {
              if (productController.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }

              final products = searchController.text.isEmpty
                  ? productController.products
                  : productController.searchProducts(searchController.text);

              if (products.isEmpty) {
                return const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.shopping_bag_outlined, size: 64, color: Colors.grey),
                      SizedBox(height: 16),
                      Text('No products found', style: TextStyle(fontSize: 18, color: Colors.grey)),
                    ],
                  ),
                );
              }

              return GridView.builder(
                padding: const EdgeInsets.all(16),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.7,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                ),
                itemCount: products.length,
                itemBuilder: (context, index) {
                  final product = products[index];
                  return Card(
                    elevation: 10,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Stack(
                      children: [
                        InkWell(
                          onTap: () {
                            productController.selectProduct(product);
                            Get.toNamed(AppRoutes.productDetail);
                          },
                          borderRadius: BorderRadius.circular(12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                flex: 3,
                                child: Stack(
                                  children: [
                                    ClipRRect(
                                      borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                                      child: CachedNetworkImage(
                                        imageUrl: product.thumbnail,
                                        width: double.infinity,
                                        fit: BoxFit.cover,
                                        placeholder: (context, url) => const Center(
                                          child: CircularProgressIndicator(),
                                        ),
                                        errorWidget: (context, url, error) => const Icon(Icons.error),
                                      ),
                                    ),
                                    Positioned(
                                      top: 8,
                                      right: 8,
                                      child: Obx(() => IconButton(
                                        icon: Icon(
                                          favoritesController.isFavorite(product)
                                              ? Icons.favorite
                                              : Icons.favorite_border,
                                          color: favoritesController.isFavorite(product)
                                              ? Colors.red
                                              : Colors.grey,
                                        ),
                                        onPressed: () => favoritesController.toggleFavorite(product),
                                        style: IconButton.styleFrom(
                                          backgroundColor: Colors.white.withOpacity(0.8),
                                        ),
                                      )),
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                flex: 3,
                                child: Padding(
                                  padding: const EdgeInsets.all(8),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        product.title,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14,
                                        ),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        '\$${product.price.toStringAsFixed(2)}',
                                        style: const TextStyle(
                                          color: Colors.green,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12,
                                        ),
                                      ),
                                      const Spacer(),
                                      SizedBox(
                                        width: double.infinity,
                                        child: ElevatedButton(
                                          onPressed: () => cartController.addToCart(product),
                                          style: ElevatedButton.styleFrom(
                                            padding: const EdgeInsets.symmetric(vertical: 8),
                                          ),
                                          child: const Text('Add to Cart', style: TextStyle(fontSize: 10)),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Positioned(
                          top: 8,
                          left: 8,
                          child: Row(
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit, color: Colors.blue),
                                onPressed: () => _showProductDialog(context, product: product),
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete, color: Colors.red),
                                onPressed: () => productController.deleteProduct(product.id),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }

  void _showProductDialog(BuildContext context, {Product? product}) {
    final ProductController productController = Get.find();
    final titleController = TextEditingController(text: product?.title ?? '');
    final descriptionController = TextEditingController(text: product?.description ?? '');
    final priceController = TextEditingController(text: product?.price.toString() ?? '');
    final discountController = TextEditingController(text: product?.discountPercentage.toString() ?? '');
    final ratingController = TextEditingController(text: product?.rating.toString() ?? '');
    final stockController = TextEditingController(text: product?.stock.toString() ?? '');
    final brandController = TextEditingController(text: product?.brand ?? '');
    final categoryController = TextEditingController(text: product?.category ?? '');
    final thumbnailController = TextEditingController(text: product?.thumbnail ?? '');
    final imagesController = TextEditingController(text: product?.images.join(',') ?? '');

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(product == null ? 'Add Product' : 'Edit Product'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(controller: titleController, decoration: const InputDecoration(labelText: 'Title')),
                TextField(controller: descriptionController, decoration: const InputDecoration(labelText: 'Description')),
                TextField(controller: priceController, decoration: const InputDecoration(labelText: 'Price'), keyboardType: TextInputType.number),
                TextField(controller: discountController, decoration: const InputDecoration(labelText: 'Discount %'), keyboardType: TextInputType.number),
                TextField(controller: ratingController, decoration: const InputDecoration(labelText: 'Rating'), keyboardType: TextInputType.number),
                TextField(controller: stockController, decoration: const InputDecoration(labelText: 'Stock'), keyboardType: TextInputType.number),
                TextField(controller: brandController, decoration: const InputDecoration(labelText: 'Brand')),
                TextField(controller: categoryController, decoration: const InputDecoration(labelText: 'Category')),
                TextField(controller: thumbnailController, decoration: const InputDecoration(labelText: 'Thumbnail URL')),
                TextField(controller: imagesController, decoration: const InputDecoration(labelText: 'Images (comma separated URLs)')),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                final newProduct = Product(
                  id: product?.id ?? '',
                  title: titleController.text,
                  description: descriptionController.text,
                  price: double.tryParse(priceController.text) ?? 0,
                  discountPercentage: double.tryParse(discountController.text) ?? 0,
                  rating: double.tryParse(ratingController.text) ?? 0,
                  stock: int.tryParse(stockController.text) ?? 0,
                  brand: brandController.text,
                  category: categoryController.text,
                  thumbnail: thumbnailController.text,
                  images: imagesController.text.split(',').map((e) => e.trim()).toList(),
                );
                if (product == null) {
                  productController.addProduct(newProduct);
                } else {
                  productController.updateProduct(product.id, newProduct);
                }
                Navigator.of(context).pop();
              },
              child: Text(product == null ? 'Add' : 'Update'),
            ),
          ],
        );
      },
    );
  }
}
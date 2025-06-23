import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/product_model.dart';

class ProductController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  var products = <Product>[].obs;
  var isLoading = false.obs;
  var selectedProduct = Rxn<Product>();
  
  @override
  void onInit() {
    super.onInit();
    fetchProducts();
  }

  void fetchProducts() {
    isLoading.value = true;
    _firestore.collection('products').snapshots().listen((snapshot) {
      products.value = snapshot.docs.map((doc) => Product.fromJson(doc.data()..['id'] = doc.id)).toList();
      isLoading.value = false;
    }, onError: (e) {
      Get.snackbar('Error', 'Failed to fetch products: $e');
      isLoading.value = false;
    });
  }

  Future<void> addProduct(Product product) async {
    try {
      await _firestore.collection('products').add(product.toJson());
      Get.snackbar('Success', 'Product added successfully');
    } catch (e) {
      Get.snackbar('Error', 'Failed to add product: $e');
    }
  }

  Future<void> updateProduct(String id, Product product) async {
    try {
      await _firestore.collection('products').doc(id).update(product.toJson());
      Get.snackbar('Success', 'Product updated successfully');
    } catch (e) {
      Get.snackbar('Error', 'Failed to update product: $e');
    }
  }

  Future<void> deleteProduct(String id) async {
    try {
      await _firestore.collection('products').doc(id).delete();
      Get.snackbar('Success', 'Product deleted successfully');
    } catch (e) {
      Get.snackbar('Error', 'Failed to delete product: $e');
    }
  }

  void selectProduct(Product product) {
    selectedProduct.value = product;
  }

  List<Product> searchProducts(String query) {
    if (query.isEmpty) return products;
    return products.where((product) =>
      product.title.toLowerCase().contains(query.toLowerCase()) ||
      product.category.toLowerCase().contains(query.toLowerCase())
    ).toList();
  }
}
import 'package:get/get.dart';
import 'package:dio/dio.dart';
import '../models/product_model.dart';

class ProductController extends GetxController {
  var products = <Product>[].obs;
  var isLoading = false.obs;
  var selectedProduct = Rxn<Product>();
  
  final Dio _dio = Dio();
  final String baseUrl = 'https://dummyjson.com/products';

  @override
  void onInit() {
    super.onInit();
    fetchProducts();
  }

  Future<void> fetchProducts() async {
    try {
      isLoading.value = true;
      
      final response = await _dio.get(baseUrl);
      
      if (response.statusCode == 200) {
        final List<dynamic> productsJson = response.data['products'];
        products.value = productsJson.map((json) => Product.fromJson(json)).toList();
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to fetch products: $e');
    } finally {
      isLoading.value = false;
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
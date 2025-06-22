import 'package:get/get.dart';
import '../models/product_model.dart';

class FavoritesController extends GetxController {
  var favoriteProducts = <Product>[].obs;

  void addToFavorites(Product product) {
    if (!favoriteProducts.any((p) => p.id == product.id)) {
      favoriteProducts.add(product);
      Get.snackbar('Success', '${product.title} added to favorites');
    }
  }

  void removeFromFavorites(Product product) {
    favoriteProducts.removeWhere((p) => p.id == product.id);
    Get.snackbar('Removed', '${product.title} removed from favorites');
  }

  void toggleFavorite(Product product) {
    if (isFavorite(product)) {
      removeFromFavorites(product);
    } else {
      addToFavorites(product);
    }
  }

  bool isFavorite(Product product) {
    return favoriteProducts.any((p) => p.id == product.id);
  }
}
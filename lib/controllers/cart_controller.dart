import 'package:get/get.dart';
import '../models/product_model.dart';

class CartItem {
  final Product product;
  int quantity;

  CartItem({required this.product, this.quantity = 1});
}

class CartController extends GetxController {
  var cartItems = <CartItem>[].obs;

  double get totalPrice {
    return cartItems.fold(0.0, (sum, item) => sum + (item.product.price * item.quantity));
  }

  int get totalItems {
    return cartItems.fold(0, (sum, item) => sum + item.quantity);
  }

  void addToCart(Product product) {
    final existingItemIndex = cartItems.indexWhere((item) => item.product.id == product.id);
    
    if (existingItemIndex >= 0) {
      cartItems[existingItemIndex].quantity++;
      cartItems.refresh();
    } else {
      cartItems.add(CartItem(product: product));
    }
    
    Get.snackbar('Success', '${product.title} added to cart');
  }

  void removeFromCart(Product product) {
    cartItems.removeWhere((item) => item.product.id == product.id);
    Get.snackbar('Removed', '${product.title} removed from cart');
  }

  void updateQuantity(Product product, int quantity) {
    final itemIndex = cartItems.indexWhere((item) => item.product.id == product.id);
    
    if (itemIndex >= 0) {
      if (quantity <= 0) {
        removeFromCart(product);
      } else {
        cartItems[itemIndex].quantity = quantity;
        cartItems.refresh();
      }
    }
  }

  void clearCart() {
    cartItems.clear();
    Get.snackbar('Cart', 'Cart cleared');
  }

  bool isInCart(Product product) {
    return cartItems.any((item) => item.product.id == product.id);
  }
}
import 'package:get/get.dart';
import '../views/login_page.dart';
import '../views/register_page.dart';
import '../views/products_page.dart';
import '../views/favorites_page.dart';
import '../views/cart_page.dart';
import '../views/product_detail_page.dart';
import '../views/main_navigation.dart';

class AppRoutes {
  static const String login = '/login';
  static const String register = '/register';
  static const String main = '/main';
  static const String products = '/products';
  static const String favorites = '/favorites';
  static const String cart = '/cart';
  static const String productDetail = '/product-detail';

  static List<GetPage> routes = [
    GetPage(name: login, page: () => LoginPage()),
    GetPage(name: register, page: () => RegisterPage()),
    GetPage(name: main, page: () => const MainNavigation()),
    GetPage(name: products, page: () => ProductsPage()),
    GetPage(name: favorites, page: () => FavoritesPage()),
    GetPage(name: cart, page: () => CartPage()),
    GetPage(name: productDetail, page: () => ProductDetailPage()),
  ];
}
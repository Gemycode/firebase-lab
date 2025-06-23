import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb_auth;
import '../routes/app_routes.dart';

class AuthController extends GetxController {
  var isLoggedIn = false.obs;
  var currentUser = Rxn<fb_auth.User>();
  var isLoading = false.obs;

  final fb_auth.FirebaseAuth _auth = fb_auth.FirebaseAuth.instance;

  @override
  void onInit() {
    super.onInit();

    _auth.authStateChanges().listen((user) {
      if (user != null) {
        isLoggedIn.value = true;
        currentUser.value = user;
      } else {
        isLoggedIn.value = false;
        currentUser.value = null;
      }
    });
  }

  Future<bool> login(String email, String password) async {
    isLoading.value = true;
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      Get.snackbar('Success', 'Login successful!');
      Get.offAllNamed(AppRoutes.main); // Navigate to main navigation with bottom bar
      return true;
    } on fb_auth.FirebaseAuthException catch (e) {
      String message = 'Login failed';
      if (e.code == 'user-not-found') {
        message = 'No user found for that email.';
      } else if (e.code == 'wrong-password') {
        message = 'Wrong password provided.';
      } else {
        message = e.message ?? message;
      }
      Get.snackbar('Error', message);
      return false;
    } catch (e) {
      Get.snackbar('Error', 'Login failed: $e');
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> register(String name, String email, String password) async {
    isLoading.value = true;
    try {
      await _auth.createUserWithEmailAndPassword(email: email, password: password);
      await _auth.currentUser?.updateDisplayName(name);
      Get.snackbar('Success', 'Registration successful!');
      Get.offAllNamed(AppRoutes.main); // الانتقال للصفحة الرئيسية هنا
      return true;
    } on fb_auth.FirebaseAuthException catch (e) {
      String message = 'Registration failed';
      if (e.code == 'email-already-in-use') {
        message = 'User already exists with this email.';
      } else if (e.code == 'weak-password') {
        message = 'The password provided is too weak.';
      } else {
        message = e.message ?? message;
      }
      Get.snackbar('Error', message);
      return false;
    } catch (e) {
      Get.snackbar('Error', 'Registration failed: $e');
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> logout() async {
    await _auth.signOut();
    Get.snackbar('Success', 'Logged out successfully');
    Get.offAllNamed(AppRoutes.login); // الانتقال لصفحة تسجيل الدخول بعد تسجيل الخروج
  }
}
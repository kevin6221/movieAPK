import 'package:get/get.dart';

class AppRoutes {
  static const String home = '/home';
  static const String movieDetail = '/movieDetail';
}

class NavigationCoordinator extends GetxController {
  void goToHome() {
    Get.toNamed(AppRoutes.home);
  }

  void goToMovieDetail(dynamic movie) {
    Get.toNamed(AppRoutes.movieDetail, arguments: movie);
  }
}

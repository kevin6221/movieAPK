import 'package:budventure/screens/home_screen/home_screen.dart';
import 'package:budventure/screens/movie_details/movie_detail_screen.dart';
import 'package:budventure/util/route_util.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true),
      initialRoute: AppRoutes.home,
      getPages: [
        GetPage(name: AppRoutes.home, page: () => HomeScreen()),
        GetPage(
          name: AppRoutes.movieDetail,
          page: () => MovieDetailScreen(movie: Get.arguments),
        ),
      ],
    );
  }
}

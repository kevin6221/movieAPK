import 'package:budventure/constant/const.dart';
import 'package:budventure/model/now_playing_model.dart';
import 'package:budventure/model/search_model.dart';
import 'package:budventure/model/top_rated_model.dart';
import 'package:budventure/model/upcoming_movies_model.dart';
import 'package:budventure/service/movie_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeScreenController extends GetxController {

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    fetchNowPlaying();
    fetchUpComingMovies();
    fetchTopRatedMovies();
    searchController.addListener(() {
      searchText.value = searchController.text;
    });
  }

  TextEditingController searchController = TextEditingController();
  var nowPlayingData = <NowPlayingDatum>[].obs;
  var upComingData = <UpComingMovieDatum>[].obs;
  var topRatedData = <TopRatedDatum>[].obs;
  var searchResults = <Movie>[].obs;

  RxString searchText = ''.obs;
  RxInt selectedIndex = 0.obs;
  RxBool isSearching = false.obs;

  void onItemTapped(int index) {
    selectedIndex.value = index;
  }

  Future<int> fetchNowPlaying() async {
    final response = await NetworkService().get<NowPlayingModel>(
      endpoint: '/movie/now_playing?language=en-US&page=1',
      fromJson: (json) => NowPlayingModel.fromJson(json),
      headers: {
        'Authorization': 'Bearer $bearerToken',
      },
    );

    if (response.success) {
      var data = response.data;
      if (data != null) {
        nowPlayingData.value = data.results;
        debugPrint("------Return--------");
        return 0;
      } else {
        Get.snackbar(
          'Info',
          'No NowPlaying data returned',
          snackPosition: SnackPosition.BOTTOM,
        );
        return 1;
      }
    } else {
      Get.snackbar(
        'Error',
        response.error ?? 'An unknown error occurred',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xff229e2e),
      );
      return 2;
    }
  }


  Future<void> fetchUpComingMovies() async {
    final response = await NetworkService().get<UpComingModel>(
      endpoint: '/movie/upcoming?language=en-US&page=1',
      fromJson: (json) => UpComingModel.fromJson(json),
      headers: {
        'Authorization':
            'Bearer $bearerToken'
      },
    );

    if (response.success) {
      var data = response.data;
      if (data != null) {
        upComingData.value = data.results;
      } else {
        Get.snackbar(
          'Info',
          'No UpComing data returned',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } else {
      Get.snackbar(
        'Error',
        response.error ?? 'An unknown error occurred',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xff229e2e),
      );
    }
  }

  Future<void> fetchTopRatedMovies() async {
    final response = await NetworkService().get<TopRatedModel>(
      endpoint: '/movie/top_rated?language=en-US&page=1',
      fromJson: (json) => TopRatedModel.fromJson(json),
      headers: {
        'Authorization':
            'Bearer $bearerToken'
      },
    );

    if (response.success) {
      var data = response.data;
      if (data != null) {
        topRatedData.value = data.results;
      } else {
        Get.snackbar(
          'Info',
          'No TopRated data returned',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } else {
      Get.snackbar(
        'Error',
        response.error ?? 'An unknown error occurred',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xff229e2e),
      );
    }
  }

  Future<void> searchMoviesAPI(
      {required String query, required int page}) async {
    isSearching.value = true;
    final response = await NetworkService().get<MovieSearchResponse>(
      endpoint: '/search/movie?api_key=$apiKey&query=$query&page=$page',
      fromJson: (json) => MovieSearchResponse.fromJson(json),
      headers: {
        'Authorization':
            'Bearer $bearerToken'
      },
    );

    if (response.success) {
      searchResults.value = response.data?.results ?? [];
    } else {
      debugPrint("error:::::${response.error}");
      Get.snackbar('Error', response.error ?? 'An unknown error occurred');
    }
    isSearching.value = false;
  }
}

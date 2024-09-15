import 'package:budventure/screens/home_screen/home_screen_controller.dart';
import 'package:budventure/util/connection_util.dart';
import 'package:budventure/util/route_util.dart';
import 'package:budventure/util/shimmer_util.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';

class HomeScreen extends StatelessWidget {
  final HomeScreenController homeScreenController =
      Get.put(HomeScreenController());
  final NavigationCoordinator navigationCoordinator =
      Get.put(NavigationCoordinator());

  HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return InternetConnection(
      appBar: AppBar(title: const Text('The MovieDb')),
      bottomNavigationBar: Obx(() {
        return BottomNavigationBar(
          currentIndex: homeScreenController.selectedIndex.value,
          onTap: (index) {
            homeScreenController.onItemTapped(index);
          },
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.movie),
              label: 'Movies',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.search),
              label: 'Search',
            ),
          ],
        );
      }),
      child: Obx(() {
        return homeScreenController.selectedIndex.value == 0
            ? _buildMovieTab(context)
            : _buildSearchTab(context);
      }),
    );
  }

  Widget _buildMovieTab(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle('Now Playing'),
          _buildMovieSection(homeScreenController.nowPlayingData, context,
              imageWidth: screenWidth * 0.4),
          _buildSectionTitle('Upcoming'),
          _buildMovieSection(homeScreenController.upComingData, context,
              imageWidth: screenWidth * 0.6),
          _buildSectionTitle('Top Rated'),
          _buildMovieSection(homeScreenController.topRatedData, context,
              imageWidth: screenWidth * 0.4),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Text(
        title,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildMovieSection(RxList<dynamic> movieList, BuildContext context,
      {double? imageWidth}) {
    final screenWidth = MediaQuery.of(context).size.width;
    final defaultWidth = imageWidth ?? screenWidth * 0.4;

    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.3,
      child: Obx(() {
        if (movieList.isEmpty) {
          return buildShimmerList(context, defaultWidth);
        } else {
          return ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: movieList.length,
            itemBuilder: (context, index) {
              final movie = movieList[index];
              return GestureDetector(
                onTap: () => navigationCoordinator.goToMovieDetail(movie),
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: CachedNetworkImage(
                            width: defaultWidth,
                            imageUrl:
                                'https://image.tmdb.org/t/p/w500${movie.posterPath}',
                            placeholder: (context, url) => const Center(
                                child: CircularProgressIndicator()),
                            errorWidget: (context, url, error) =>
                                const Icon(Icons.error),
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8.0),
                      Text(
                        movie.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        }
      }),
    );
  }

  Widget _buildSearchTab(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16,right: 16,left: 16),
      child: SingleChildScrollView(
        child: Column(
          children: [
            TextField(
              controller: homeScreenController.searchController,
              onChanged: (value) {
                if (value.isNotEmpty) {
                  homeScreenController.searchMoviesAPI(query: value, page: 1);
                } else {
                  homeScreenController.searchResults.clear();
                }
              },
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: const BorderSide(
                    color: Colors.grey,
                    width: 1.0,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                  borderSide: const BorderSide(
                    color: Colors.grey,
                    width: 1.0,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                  borderSide: const BorderSide(
                    color: Colors.grey,
                    width: 2.0,
                  ),
                ),
                prefixIcon: const Icon(
                  Icons.search,
                  color: Colors.grey,
                ),
                hintText: 'Search for movies...',
                suffixIcon: Obx(() {
                  return homeScreenController.searchText.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () {
                            homeScreenController.searchController.clear();
                            homeScreenController.searchResults.clear();
                          },
                        )
                      : const SizedBox.shrink();
                }),
              ),
            ),
            const SizedBox(height: 16.0),
            Obx(() {
              final screenWidth = MediaQuery.of(context).size.width;
              if (homeScreenController.isSearching.value) {
                return shimmerList(screenWidth);
              } else if (homeScreenController.searchResults.isEmpty) {
                return const Center(child: Text('No results found.'));
              } else {
                return SizedBox(
                  height: MediaQuery.of(context).size.height,
                  child: ListView.builder(
                    itemCount: homeScreenController.searchResults.length,
                    itemBuilder: (context, index) {
                      final movie = homeScreenController.searchResults[index];
                      return Card(
                        child: ListTile(
                          title: Text(movie.title),
                          subtitle: Text(movie.releaseDate),
                          onTap: () =>
                              navigationCoordinator.goToMovieDetail(movie),
                        ),
                      );
                    },
                  ),
                );
              }
            }),
          ],
        ),
      ),
    );
  }
}

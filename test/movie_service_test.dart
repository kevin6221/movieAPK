import 'package:budventure/constant/const.dart';
import 'package:budventure/model/search_model.dart';
import 'package:budventure/model/top_rated_model.dart';
import 'package:budventure/model/upcoming_movies_model.dart';
import 'package:budventure/service/movie_service.dart';
import 'package:budventure/model/now_playing_model.dart';
import 'package:flutter_test/flutter_test.dart';


const nowPlayingModel = 'should return NowPlayingModel when response is successful';
const upComingModel = 'should return UpComingModel when response is successful';
const topRatedModel = 'should return TopRatedModel when response is successful';
const searchModel = 'should return SearchModel when response is successful';
const commonError = 'should handle error responses';

void main() {
  late NetworkService networkService;

  setUp(() {
    networkService = NetworkService();
  });

  test(nowPlayingModel, () async {
    final response = await networkService.get<NowPlayingModel>(
      endpoint: '/movie/now_playing?language=en-US&page=1',
      fromJson: (json) => NowPlayingModel.fromJson(json),
      headers: {
        'Authorization': 'Bearer $bearerToken',
      },
    );

    expect(response.success, true);
  });

  test(commonError, () async {
    networkService = NetworkService();

    final response = await networkService.get<NowPlayingModel>(
      endpoint: '/movie/now_playing?language=en-US&page=1',
      fromJson: (json) => NowPlayingModel.fromJson(json),
    );

    expect(response.success, false);
  });

  test(upComingModel, () async {
    final response = await networkService.get<UpComingModel>(
      endpoint: '/movie/upcoming?language=en-US&page=1',
      fromJson: (json) => UpComingModel.fromJson(json),
      headers: {
        'Authorization': 'Bearer $bearerToken',
      },
    );

    expect(response.success, true);
  });

  test(commonError, () async {
    networkService = NetworkService();

    final response = await networkService.get<UpComingModel>(
      endpoint: '/movie/upcoming?language=en-US&page=1',
      fromJson: (json) => UpComingModel.fromJson(json),
    );

    expect(response.success, false);
  });

  test(topRatedModel, () async {
    final response = await networkService.get<TopRatedModel>(
      endpoint: '/movie/top_rated?language=en-US&page=1',
      fromJson: (json) => TopRatedModel.fromJson(json),
      headers: {
        'Authorization': 'Bearer $bearerToken',
      },
    );

    expect(response.success, true);
  });

  test(commonError, () async {
    networkService = NetworkService();

    final response = await networkService.get<TopRatedModel>(
      endpoint: '/movie/top_rated?language=en-US&page=1',
      fromJson: (json) => TopRatedModel.fromJson(json),
    );

    expect(response.success, false);
  });
}

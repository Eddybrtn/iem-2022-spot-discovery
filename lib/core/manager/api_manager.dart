import 'package:dio/dio.dart';
import 'package:iem_2022_spot_discovery/core/model/comment.dart';

class ApiManager {
  static final ApiManager _instance = ApiManager._internal();

  factory ApiManager() => _instance;

  late Dio dio;

  ApiManager._internal() {
    dio = Dio();
    dio.options.baseUrl =
    "https://spot-discovery-5b840-default-rtdb.firebaseio.com";
  }

  Future<Response<Map<String, dynamic>>> getAllSpots() async =>
      await dio.get<Map<String, dynamic>>("/spots.json");

  Future<Response<Map<String, dynamic>>> getSpot(int idSpot) async =>
      await dio.get<Map<String, dynamic>>("/spot-details/$idSpot.json");

  Future<Response<Map<String, dynamic>>> postComment(
      int spotId, SpotComment comment) async =>
      await dio.post("/spot-details/$spotId/comments.json",
          data: comment.toJson());
}
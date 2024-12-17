import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';


part 'rest_client.g.dart';

@RestApi()
abstract class RestClient {
  factory RestClient(Dio dio, {required String baseUrl}) = _RestClient;

  @POST('/user-registration')
  Future<dynamic> userLogin(@Body() Map<String, dynamic> body);

  @GET('/get-video-list')
  Future<dynamic> getAllVideos();

  @GET('/get-watched-video?')
  Future<dynamic> getAllWatchedVideos(@Body() Map<String, dynamic> body);
}

import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';


part 'rest_client.g.dart';

@RestApi()
abstract class RestClient {
  factory RestClient(Dio dio, {required String baseUrl}) = _RestClient;

  @POST('/update-device-token')
  Future<dynamic> updateDeviceNotificationValue(@Body() Map<String, dynamic> body);

  @POST('/user-registration')
  Future<dynamic> userLogin(@Body() Map<String, dynamic> body);

  @POST('/user_watched_video')
  Future<dynamic> updateUserWatchedVideoDetails(@Body() Map<String, dynamic> body);

  @GET('/get-video-list')
  Future<dynamic> getAllVideos();

  @GET('/get-notification')
  Future<dynamic> getAllNotifications();

  @GET('/get-card-achived-details?')
  Future<dynamic> getAllTickets(@Body() Map<String, dynamic> body);

  @GET('/get-watched-video?')
  Future<dynamic> getAllWatchedVideos(@Body() Map<String, dynamic> body);

  @GET('/get-unwatched-video?')
  Future<dynamic> getUnWatchedVideos(@Body() Map<String, dynamic> body);

  @GET('/get-individual-user?')
  Future<dynamic> getIndividualUser(@Body() Map<String, dynamic> body);

  @GET('/get-season-list')
  Future<dynamic> getSeasonList();

  @GET('/get-districts')
  Future<dynamic> getAllDistricts();

  @GET('/sign_up?')
  Future<dynamic> userSignIn(@Body() Map<String, dynamic> body);
}

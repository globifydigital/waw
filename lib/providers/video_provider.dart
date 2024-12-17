
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:waw/models/user/user_details_model.dart';
import 'package:waw/models/videos/all_watched_videos_model.dart';

import '../../rest/rest_client_provider.dart';
import '../models/videos/all_videos_model.dart';

final videoListProvider = ChangeNotifierProvider<VideoListProvider>(
      (ref) => VideoListProvider(ref),
);

class VideoListProvider extends ChangeNotifier {
  VideoListProvider(this._ref) : _restClient = _ref.read(restClientProvider) {
    // getDepartmentList();
  }
  final Ref _ref;
  final RestClient _restClient;


  List<AllVideosListModel> _allVideosList = [];
  List<AllWatchedVideosList> _allWatchedVideosList = [];

  List<AllVideosListModel> get allVideosListState => _allVideosList;
  List<AllWatchedVideosList> get allWatchedVideosListState => _allWatchedVideosList;

  Future<AllVideos> getAllVideos() async {
    try {
      final response = await _restClient.getAllVideos();

      // Log the response to inspect it
      if (kDebugMode) {
        print("API Response: $response");
      }

      final allVideos = AllVideos.fromJson(response);

      _allVideosList = allVideos.data ?? [];
      notifyListeners();

      return allVideos;
    } catch (e, stackTrace) {
      // Log the error details
      if (kDebugMode) {
        print("Error occurred: $e");
        print("StackTrace: $stackTrace");
      }

      // Return an empty object or handle error gracefully
      return AllVideos(data: []);
    }
  }

  Future<AllWatchedVideos> getAllWatchedVideos(String mobNo) async {
    try {
      final map = {
        "mob_no": mobNo,
      };
      final response = await _restClient.getAllWatchedVideos(map);
      if (kDebugMode) {
        print("API Response: $response");
      }

      final allWatchedVideos = AllWatchedVideos.fromJson(response);

      _allWatchedVideosList = allWatchedVideos.data ?? [];
      notifyListeners();

      return allWatchedVideos;
    } catch (e, stackTrace) {
      // Log the error details
      if (kDebugMode) {
        print("Error occurred: $e");
        print("StackTrace: $stackTrace");
      }
      return AllWatchedVideos(data: []);
    }
  }


}

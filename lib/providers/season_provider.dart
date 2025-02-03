
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:waw/models/season/season_list_model.dart';
import '../../rest/rest_client_provider.dart';

final seasonListProvider = ChangeNotifierProvider<SeasonListProvider>(
      (ref) => SeasonListProvider(ref),
);

class SeasonListProvider extends ChangeNotifier {
  SeasonListProvider(this._ref) : _restClient = _ref.read(restClientProvider) {
     getAllSeason();
  }
  final Ref _ref;
  final RestClient _restClient;


  List<SeasonList> _allSeasonList = [];

  List<SeasonList> get allSeasonListState => _allSeasonList;

  Future<SeasonListModel> getAllSeason() async {
    try {
      final response = await _restClient.getSeasonList();

      if (kDebugMode) {
        print("API Response: $response");
      }

      final allSeasons = SeasonListModel.fromJson(response);

      _allSeasonList = allSeasons.data ?? [];

      notifyListeners();

      return allSeasons;
    } catch (e, stackTrace) {
      if (kDebugMode) {
        print("Error occurred: $e");
        print("StackTrace: $stackTrace");
      }
      return SeasonListModel(data: []);
    }
  }
}

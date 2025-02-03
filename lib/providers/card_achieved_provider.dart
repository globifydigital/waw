
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:waw/models/cards/card_achieved_model.dart';
import 'package:waw/models/user/user_details_model.dart';
import 'package:waw/models/videos/all_unwatched_videos.dart';
import 'package:waw/models/videos/all_watched_videos_model.dart';

import '../../rest/rest_client_provider.dart';
import '../models/videos/all_videos_model.dart';

final cardAchievedProvider = ChangeNotifierProvider<CardAchievedProvider>(
      (ref) => CardAchievedProvider(ref),
);

class CardAchievedProvider extends ChangeNotifier {
  CardAchievedProvider(this._ref)
      : _restClient = _ref.read(restClientProvider) {
    // getDepartmentList();
  }

  final Ref _ref;
  final RestClient _restClient;


  List<CardAchievedModel> _ticketList = [];
  List<CardAchievedList> _allTicketList = [];

  List<CardAchievedList> get allTicketListState => _allTicketList;

  Future<CardAchievedModel> getAllTickets(String mobNo) async {
    try {
      final map = {
        "mob_no": mobNo,
      };
      final response = await _restClient.getAllTickets(map);
      if (kDebugMode) {
        print("API Response: $response");
      }

      final allTickets = CardAchievedModel.fromJson(response);

      _allTicketList = allTickets.data ?? [];
      notifyListeners();

      return allTickets;
    } catch (e, stackTrace) {
      if (kDebugMode) {
        print("Error occurred: $e");
        print("StackTrace: $stackTrace");
      }

      return CardAchievedModel(data: []);
    }
  }
}
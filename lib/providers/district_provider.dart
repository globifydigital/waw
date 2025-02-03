
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../rest/rest_client_provider.dart';
import '../models/district/district_model.dart';

final districtProvider = ChangeNotifierProvider<DistrictListProvider>(
      (ref) => DistrictListProvider(ref),
);

class DistrictListProvider extends ChangeNotifier {
  DistrictListProvider(this._ref) : _restClient = _ref.read(restClientProvider) {
    getAllDistricts();
  }
  final Ref _ref;
  final RestClient _restClient;


  List<DistrictList> _allDistrictList = [];

  List<DistrictList> get allDistrictListState => _allDistrictList;

  Future<DistrictModel> getAllDistricts() async {
    try {
      final response = await _restClient.getAllDistricts();

      if (kDebugMode) {
        print("API Response: $response");
      }

      final allDistrict = DistrictModel.fromJson(response);

      _allDistrictList = allDistrict.data ?? [];

      notifyListeners();

      return allDistrict;
    } catch (e, stackTrace) {
      if (kDebugMode) {
        print("Error occurred: $e");
        print("StackTrace: $stackTrace");
      }
      return DistrictModel(data: []);
    }
  }
}

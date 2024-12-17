
import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:waw/models/user/user_details_model.dart';

import '../../rest/rest_client_provider.dart';

final userDetailsProvider = ChangeNotifierProvider<UserDetailsProvider>(
      (ref) => UserDetailsProvider(ref),
);

class UserDetailsProvider extends ChangeNotifier {
  UserDetailsProvider(this._ref) : _restClient = _ref.read(restClientProvider) {
    // getDepartmentList();
  }
  final Ref _ref;
  final RestClient _restClient;



  UserDetails? _userDetails;


  Future<UserDetails> registerUser({
    required String name,
    required String mob_no,
    required String whatsapp_no,
    required String email,
    required String address,
    required String location,
    required String image,
  }) async {

    final map = {
      "name" : name,
      "mob_no" : mob_no,
      "whatsapp_no" : whatsapp_no,
      "email" : email,
      "address" : address,
      "location" : location,
      "image" : image
    };

    notifyListeners();

    try {
      final response = await _restClient.userLogin(map);


      final userDetails = UserDetails.fromJson(response);


      _userDetails = userDetails;

      notifyListeners();

      return userDetails;
    } catch (e, stack) {
      print(e);
      print(stack);
      notifyListeners();
      return UserDetails();
    }
  }


}

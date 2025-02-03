
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:waw/models/user/individual_user_model.dart';
import 'package:waw/models/user/user_details_model.dart';

import '../../rest/rest_client_provider.dart';
import '../models/user/user_edit_model.dart';
import '../rest/hive_repo.dart';

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
  ProfileEditModel? _editedUserDetails;

  Future<dynamic> registerUserWithFile({
    required String name,
    required String mob_no,
    required String whatsapp_no,
    required String email,
    required String address,
    required String location,
    required File file,
  }) async {
    try {
      final dio = Dio();
      dio.options.baseUrl = HiveRepo.instance.getBaseUrl().toString();
      dio.options.headers = {
        "api-key": "1W4YUli4lxsxl9PkkMT6pEQjJ0jBmoht",
        "content-type": "multipart/form-data",
      };
      final formData = FormData.fromMap({
        "name": name,
        "mob_no": mob_no,
        "whatsapp_no": whatsapp_no,
        "email": email,
        "address": address,
        "location": location,
        "image": await MultipartFile.fromFile(
          file.path,
          filename: file.path.split('/').last,
        ),
      });

      final response = await dio.post('/user-registration', data: formData);

      if (response.data is Map<String, dynamic>) {
        return UserDetails.fromJson(response.data);
      } else {
        throw Exception("Unexpected response format");
      }
    } catch (e) {
      print('Error: $e');
      throw e;
    }
  }


  Future<UserDetails> registerUser({
    required String name,
    required String mob_no,
    required String whatsapp_no,
    required String email,
    required String address,
    required String location,
    required File file,
  }) async {
    try {
      final response = await registerUserWithFile(
        name: name,
        mob_no: mob_no,
        whatsapp_no: whatsapp_no,
        email: email,
        address: address,
        location: location,
        file: file,
      );

      final userDetails = response;
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


  Future<dynamic> editUserWithFile({
    required String name,
    required String mob_no,
    required String whatsapp_no,
    required String email,
    required String address,
    required String location,
    required File file,
  }) async {
    try {
      final dio = Dio();
      dio.options.baseUrl = HiveRepo.instance.getBaseUrl().toString();
      dio.options.headers = {
        "api-key": "1W4YUli4lxsxl9PkkMT6pEQjJ0jBmoht",
        "content-type": "multipart/form-data",
      };
      final formData = FormData.fromMap({
        "mob_no": mob_no,
        "name": name,
        "whatsapp_no": whatsapp_no,
        "email": email,
        "address": address,
        "image": await MultipartFile.fromFile(
          file.path,
          filename: file.path.split('/').last,
        ),
        "location": location,
      });

      final response = await dio.post('/profile-edit', data: formData);

      if (response.data is Map<String, dynamic>) {
        return ProfileEditModel.fromJson(response.data);
      } else {
        throw Exception("Unexpected response format");
      }
    } catch (e) {
      print('Error: $e');
      throw e;
    }
  }


  Future<ProfileEditModel> editUser({
    required String name,
    required String mob_no,
    required String whatsapp_no,
    required String email,
    required String address,
    required String location,
    required File file,
  }) async {
    try {
      final response = await editUserWithFile(
        name: name,
        mob_no: mob_no,
        whatsapp_no: whatsapp_no,
        email: email,
        address: address,
        location: location,
        file: file,
      );
      final user = response;
      _editedUserDetails = user;
      notifyListeners();
      return user;
    } catch (e, stack) {
      print(e);
      print(stack);
      notifyListeners();
      return ProfileEditModel();
    }
  }


  Future<UserModel> getIndividualUser(String mobNo) async {
    try {
      final map = {
        "mob_no": mobNo,
      };
      final response = await _restClient.getIndividualUser(map);

      // Log the response to inspect it
      if (kDebugMode) {
        print("API Response: $response");
      }

      final user = UserModel.fromJson(response);
      notifyListeners();

      return user;
    } catch (e, stackTrace) {
      // Log the error details
      if (kDebugMode) {
        print("Error occurred: $e");
        print("StackTrace: $stackTrace");
      }
      return UserModel();
    }
  }

  Future<UserModel> userSignIn(String mobNo) async {
    try {
      final map = {
        "mob_no": mobNo,
      };
      final response = await _restClient.userSignIn(map);

      // Log the response to inspect it
      if (kDebugMode) {
        print("API Response: $response");
      }

      final user = UserModel.fromJson(response);
      notifyListeners();

      return user;
    } catch (e, stackTrace) {
      // Log the error details
      if (kDebugMode) {
        print("Error occurred: $e");
        print("StackTrace: $stackTrace");
      }
      return UserModel();
    }
  }


}

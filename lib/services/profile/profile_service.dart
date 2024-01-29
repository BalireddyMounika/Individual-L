
import 'package:life_eazy/models/generic_response.dart';
import 'package:life_eazy/models/profile/user_profile_address_request.dart';
import 'package:life_eazy/models/profile/user_profile_request.dart';

import '../../models/profile/user_profile_update_request.dart';

abstract class ProfileService
{
  Future<GenericResponse> postUserProfile(UserProfileRequest request);
  Future<GenericResponse> postUserProfileAddress(UserProfileAdressRequest request);
  Future<GenericResponse> updateUserProfile(UserProfileUpdateRequest request, int userId);
  Future<GenericResponse> updateUserProfileAddress(UserProfileAdressRequest request,int userId);
  Future<GenericResponse> getProfile(int userId);

}

import 'package:life_eazy/models/family_members/user_family_member_address_request.dart';
import 'package:life_eazy/models/family_members/user_famliy_member_request.dart';
import 'package:life_eazy/models/generic_response.dart';

abstract class FamilyMembersServices
{
  Future<GenericResponse> getFamilyMembersList(int userId);
  Future<GenericResponse> addFamilyMembers(UserFamilyMemberRequest request);
  Future<GenericResponse> addFamilyMembersAddress(UserFamilyMemberAddressRequest request);
  Future<GenericResponse> editFamilyMembers(UserFamilyMemberRequest request,int id);
  Future<GenericResponse> editFamilyMembersAddress(UserFamilyMemberAddressRequest request,int id);


}
import '../../models/generic_response.dart';
import '../../models/pharmacy/pharmacy_order_request.dart';

abstract class PharmacyService {

   Future<GenericResponse> getAllPharmacyList();
   Future<GenericResponse> getPharmacyOrdersByUserID();

   Future<GenericResponse> postPharmacyOrders(PharmacyOrdersRequest request);
   Future<GenericResponse> updatePharmacyOrders(PharmacyOrdersRequest request,int id);

}
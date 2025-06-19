import 'package:dio/dio.dart';

class ApiService {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: "http://shippinganddelivery.runasp.net/api/", // ✅ تم التعديل هنا
      headers: {
        'Content-Type': 'application/json',
      },
      followRedirects: true,
      validateStatus: (status) {
        return status != null && status < 500;
      },
    ),
  );

  // ✅ Register
  Future<Response> register({
    required String name,
    required String email,
    required String password,
    required String phone,
  }) async {
    try {
      final response = await _dio.post(
        'users',
        data: {
          "fullName": name,
          "email": email,
          "password": password,
          "phoneNumber": phone,
        },
      );
      return response;
    } catch (e) {
      print('❌ Register error: $e');
      rethrow;
    }
  }

  // ✅ Login
  Future<Response> login(String email, String password) async {
    try {
      final response = await _dio.post(
        'users/login', // ✅ تم التعديل هنا
        data: {
          "email": email,
          "password": password,
        },
      );
      return response;
    } catch (e) {
      print('❌ Login error: $e');
      rethrow;
    }
  }

  // ✅ Get Companies
  Future<Response> getCompanies(String token) async {
    try {
      final response = await _dio.get(
        'companies',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );
      return response;
    } catch (e) {
      print('❌ Get Companies error: $e');
      rethrow;
    }
  }

  // ✅ Create Order
  Future<Response> createOrder({
    required String pickupLocation,
    required String destination,
    required int weightInKg,
    required String packageSize,
    required String details,
    required String token,
  }) async {
    try {
      final response = await _dio.post(
        'orders',
        data: {
          "pickupLocation": pickupLocation,
          "destination": destination,
          "weightInKg": weightInKg,
          "packageSize": packageSize,
          "details": details,
        },
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );
      return response;
    } catch (e) {
      print('❌ Create Order error: $e');
      rethrow;
    }
  }

  // ✅ git push -u origin mainGet Orders
  Future<Response> getOrders({
    required String token,
    String? status, // Optional query parameter
  }) async {
    try {
      final response = await _dio.get(
        'orders',
        queryParameters: status != null ? {'status': status} : null,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );
      return response;
    } catch (e) {
      print('❌ Get Orders error: $e');
      rethrow;
    }
  }
}

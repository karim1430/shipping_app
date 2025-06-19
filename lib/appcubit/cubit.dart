import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:untitled9/appcubit/state.dart';
import 'package:untitled9/userdata.dart';
import '../api/api-service.dart';
import '../app/Add.dart';
import '../app/Home.dart';
import '../app/ShippingCompaniesScreen.dart';
import '../app/history.dart';
import '../app/offers.dart';
import '../app/profile.dart';
import '../app/tracking.dart';
import '../models/companyModel.dart';
import '../models/order model.dart';
class AppCubit extends Cubit<AppState> {
  AppCubit() : super(AppInitialState());
  final api = ApiService(); //
  //List<CompanyModel> companies = [];
  List<CompanyModel> companies = [] ;
  List<OrderModel> orders = [] ;

  int c = 3 ;
   int i = 0 ;
      List<Widget> Screens = [ShippingCompaniesGrid(),OrderHistoryScreen(),AddOrderPage(),HomePage(),ShippingOffersPage(),TrackOrderPage(),ProfilePage()] ;
    void ChangeCurrent(int v){
      c = v ;
      emit(ChangeCurrentState()) ;
    }
  Future<void> getCompanies(String token) async {
    emit(CompanyLoading());
    try {
      print("CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC");
      final response = await api.getCompanies(token);
      final List<dynamic> data = response.data['data'];

       companies = data.map((e) => CompanyModel.fromJson(e)).toList();
       print(companies.length) ;
      emit(CompanyLoaded());
    } catch (e) {
      print("ZZZZZZZZZZZZ") ;
      print(e.toString()) ;
      emit(CompanyError());
    }
  }
  Future<void> getOrders(String token) async {
    emit(OrderLoading());
    try {
      print("Calling API to get orders...");
      final response = await api.getOrders(token: token).then((v){
        print("Goood") ;
        print(v.data) ;
      });
      print(response.toString()) ;

      print("Full API Response: ${response.data}");

      if (response.data != null && response.data['data'] is List) {
        final List<dynamic> data = response.data['data'];
        orders = data.map((e) => OrderModel.fromJson(e)).toList();
        print("Number of orders: ${orders.length}");
        emit(OrderLoaded());
      } else {
        print("Data key is missing or not a list. Actual: ${response.data['data']}");
        emit(OrderError());
      }
    } catch (e) {
      if (e is DioException) {
        print("DioException: ${e.response?.data}");
      } else {
        print("Unknown Error: $e");
      }
      emit(OrderError());
    }
  }



  Future<void> createOrder({
    required String pickupLocation,
    required String destination,
    required int weightInKg,
    required String packageSize,
    required String details,
    required String token,
  }) async {
    emit(OrderLoading());
    try {
      final response = await api.createOrder(
        pickupLocation: pickupLocation,
        destination: destination,
        weightInKg: weightInKg,
        packageSize: packageSize,
        details: details,
        token: token,
      );

      print("Status Code: ${response.statusCode}");
      print("Response Body: ${response.data}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        print("11");
        emit(OrderSuccess());
      } else {
        print("22");
        emit(OrderError());
      }
    } catch (e) {
      print("Exception: $e");
      emit(OrderError());
    }
  }
}
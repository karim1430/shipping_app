import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
import '../models/Offer Model.dart';
import '../models/companyModel.dart';
import '../models/order model.dart';
class AppCubit extends Cubit<AppState> {
  AppCubit() : super(AppInitialState());
  final api = ApiService(); //
  //List<CompanyModel> companies = [];
  List<CompanyModel> companies = [] ;
  int ORDERID = 0 ;
  List<OrderModel> orders = [] ;
  int pendingCount = 0;

  int deliveredCount = 0;
  List<OrderModel> lastTwoOrders = [] ;
  int c = 3 ;
   int i = 0 ;
  List<OfferModel> offers = [] ;
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
  Future<void> fetchOrders() async {
    final dio = Dio();
    //final String token = 'ضع_التوكن_بتاعك_هنا';

    try {
      final response = await dio.get(
        'http://shippinganddelivery.runasp.net/api/orders',
        queryParameters: {},
        options: Options(
          headers: {
            'Accept': 'application/json',
            'Authorization': 'Bearer $utoken',
          },
        ),
      );

      if (response.statusCode == 200) {
        List<dynamic> data = response.data['data'];
        orders = data.map((order) => OrderModel.fromJson(order)).toList();
         pendingCount = orders.where((order) => order.status == 'Pending').length;

         deliveredCount = orders.where((order) => order.status == 'Delivered').length;
         lastTwoOrders = orders.length >= 2
            ? orders.sublist(orders.length - 2)
            : orders;
        // طباعه كل الاوردرز
        for (var order in orders) {
          print('Order ID: ${order.id}');
          print('Pickup: ${order.pickupLocation}');
          print('Destination: ${order.destination}');
          print('Weight: ${order.weightInKg} Kg');
          print('Package Size: ${order.packageSize}');
          print('Owner Name: ${order.ownerName}');
          print('Status: ${order.status}');
          print('Details: ${order.details}');
          print('Created At: ${order.createdAtUtc}');
          print('---------------------------');
        }
      } else {
        print('Error: ${response.statusCode}');
      }
    } catch (e) {
      print('Exception: $e');
    }
  }
  Future<void> getOrders(String token) async {
      orders = [] ;
    emit(OrderLoading());
    try {
      print("Calling API to get orders...");
      final response = await api.getOrders(token: token, status: 'Pending',);
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
  Future<void> fetchOffersByOrderId(int orderId, String token) async {
      emit(LoadingfetchOffersByOrderId());
    final dio = Dio();

    try {
      final response = await dio.get(
        'http://shippinganddelivery.runasp.net/api/offers',
        queryParameters: {
          'orderId': orderId, // الـ Query Parameter المطلوب
        },
        options: Options(
          headers: {
            'Accept': 'application/json',
            'Authorization': 'Bearer $token', // التوكن القادم من الـ Login
          },
        ),
      );

      if (response.statusCode == 200) {
        print("200") ;
        print(response.data) ;
        print(response.data.toString()) ;
        List<dynamic> data = response.data;
        offers = data.map((offer) => OfferModel.fromJson(offer)).toList();
        print(offers.length) ;
        // مثال: طباعة كل العروض المستلمة
        for (var offer in offers) {
          print('Offer ID: ${offer.id}');
          print('Order ID: ${offer.orderId}');
          print('Customer Name: ${offer.customerName}');
          print('Company ID: ${offer.companyId}');
          print('Company Name: ${offer.companyName}');
          print('Price: ${offer.price}');
          print('Estimated Delivery Time: ${offer.estimatedDeliveryTimeInDays} days');
          print('Notes: ${offer.notes}');
          print('Status: ${offer.status}');
          print('Created At: ${offer.createdAtUtc}');
          print('Delivery Date: ${offer.deliveryDateUtc}');
          print('---------------------------');
        }
        i = 0 ;
        emit(LoadedfetchOffersByOrderId());
      } else {
        print('Error: ${response.statusCode}');
        emit(errorfetchOffersByOrderId());
      }
    } catch (e) {
      print('Exception occurred: $e');
    }
  }
  Future<void> updateOfferStatus({
    required int offerId,
    required String token,
    required String status,
    required String paymentMethod,
  }) async {
    final dio = Dio();

    try {
      final response = await dio.patch(
        'http://shippinganddelivery.runasp.net/api/offers/$offerId',
        data: {
          "status": status,
          "paymentMethod": paymentMethod,
        },
        options: Options(
          headers: {
            'Accept': 'application/json',
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
        ),
      );

      print('Response Status: ${response.statusCode}');
      print('Response Data: ${response.data}');
      i = 0 ;
      fetchOrders();
      emit(UpdateStaate()) ;
    } catch (e) {
      if (e is DioError) {
        print('DioError: ${e.response?.data}');
      } else {
        print('Error: $e');
      }
    }
  }

  Future<void> createOrder({
    required String pickupLocation,
    required String destination,
    required int weightInKg,
    required String packageSize,
    required String details,
    required String token,
    required BuildContext c,
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
        fetchOrders();
        emit(OrderSuccess());
        ScaffoldMessenger.of(c).showSnackBar(
          SnackBar(content: Text("Order Created Successfully!")),
        );
      } else {
        print("22");
        emit(OrderError());
        ScaffoldMessenger.of(c).showSnackBar(
          SnackBar(content: Text("Failed To Creat Order")),
        );
      }
    } catch (e) {
      print("Exception: $e");
      emit(OrderError());
      ScaffoldMessenger.of(c).showSnackBar(
        SnackBar(content: Text("Failed To Creat Order")),
      );
    }
  }
}
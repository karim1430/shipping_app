import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../api/api-service.dart';
import '../models/userModel.dart';
import '../userdata.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(LoginInitialState());
  final api = ApiService();

  Future<void> register(
      String name,
      String email,
      String password,
      String phone,
      ) async {
    emit(RegisterLoading());

    try {
      final response = await api.register(
        name: name,
        email: email,
        password: password,
        phone: phone,
      );

      final responseData = jsonDecode(response.data);

      if (responseData["isSuccess"] == true) {
        final userJson = responseData["data"];
        final user = UserModel.fromJson(userJson);

        // حفظ بيانات اليوزر
        utoken = user.token;
        uemail = user.email;
        ufullName = user.fullName;
        uphoneNumber = user.phoneNumber;

        print("✅ Register Success: $user");
        emit(RegisterSuccess());
      } else {
        String errorMessage = "حدث خطأ غير معروف";
        final errors = responseData["errors"];
        if (errors != null && errors is List && errors.isNotEmpty) {
          errorMessage = errors[0]["errorMessage"] ?? errorMessage;
        } else if (errors is String) {
          errorMessage = errors;
        }
        print("❌ Register Errors: $errorMessage");
        emit(RegisterFailure());
      }
    } catch (e) {
      print("❌ Register Exception: ${e.toString()}");
      emit(RegisterFailure());
    }
  }

  Future<void> login(String email, String password) async {
    emit(LoginLoading());

    try {
      print("📢 Trying login...");
      final response = await api.login(email, password);

      // التأكد من نوع الداتا
      final responseData = response.data is String
          ? jsonDecode(response.data)
          : response.data;

      print("📢 Response Data: $responseData");

      if (responseData["isSuccess"] == true) {
        final userJson = responseData["data"];
        final user = UserModel.fromJson(userJson);

        utoken = user.token;
        uemail = user.email;
        ufullName = user.fullName;
        uphoneNumber = user.phoneNumber;

        print("✅ Login Success: $user");
        emit(LoginSuccess());
      } else {
        final errors = responseData["errors"];
        String errorMessage = "حدث خطأ غير معروف";

        if (errors != null) {
          if (errors is List && errors.isNotEmpty) {
            errorMessage = errors[0]["errorMessage"] ?? errorMessage;
          } else if (errors is String) {
            errorMessage = errors;
          }
        }

        print("❌ Login Errors: $errorMessage");
        emit(LoginFailure());
      }
    } catch (e) {
      print("❌ Login Exception: ${e.toString()}");
      emit(LoginFailure());
    }
  }


  // التحكم في اظهار كلمة المرور
  bool isPasswordVisible = false;
  bool isConfirmPasswordVisible = false;

  void togglePasswordVisibility() {
    isPasswordVisible = !isPasswordVisible;
    emit(LoginPasswordVisibilityChanged());
  }

  void toggleConfirmPasswordVisibility() {
    isConfirmPasswordVisible = !isConfirmPasswordVisible;
    emit(LoginConfirmPasswordVisibilityChanged());
  }
}

// الحالات المختلفة للـ Cubit
abstract class LoginState {}

class LoginInitialState extends LoginState {}

class LoginPasswordVisibilityChanged extends LoginState {}

class LoginConfirmPasswordVisibilityChanged extends LoginState {}

class LoginLoading extends LoginState {}

class LoginSuccess extends LoginState {}

class LoginFailure extends LoginState {}

class RegisterLoading extends LoginState {}

class RegisterSuccess extends LoginState {}

class RegisterFailure extends LoginState {}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Login/Login.dart';
import 'Splash/SplashScreen.dart';
import 'app/app.dart';
import 'appcubit/cubit.dart';
import 'logincubit/cubit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  final seen = prefs.getBool('seenSplash') ?? false;

  runApp(MyApp(showSplash: !seen));
}

class MyApp extends StatelessWidget {
  final bool showSplash;
  const MyApp({required this.showSplash, super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => LoginCubit()),
        BlocProvider(create: (_) => AppCubit()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: showSplash ?  SplashScreen() : LoginScreen() ,
      ),
    );
  }
}

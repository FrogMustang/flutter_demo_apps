import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_demo_apps/providers/art_objects_provider.dart';
import 'package:flutter_demo_apps/repository/museum_repository.dart';
import 'package:flutter_demo_apps/screens/home_screen.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

void main() async {
  runApp(
    MultiProvider(providers: [
      ChangeNotifierProvider(
        create: (_) => ArtObjectsProvider(MuseumRepository()),
      )
    ], child: const MyApp()),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      builder: (builder, child) {
        return MaterialApp(
          title: "Flutter Demo Apps",
          theme: ThemeData(
            fontFamily: Platform.isAndroid
                ? '.Roboto'
                : Platform.isIOS
                    ? ".SF UI Display"
                    : '',
            textTheme: TextTheme(
              headlineMedium: TextStyle(
                color: Colors.white,
                fontSize: 34.sp,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.25.r,
              ),
              labelLarge: TextStyle(
                color: Colors.white,
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                letterSpacing: 1.25.r,
              ),
              titleMedium: TextStyle(
                color: Colors.white,
                fontSize: 16.sp,
                fontWeight: FontWeight.w400,
                letterSpacing: 0.15.r,
              ),
              titleSmall: TextStyle(
                color: Colors.white,
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.1.r,
              ),
              bodyMedium: TextStyle(
                color: Colors.white,
                fontSize: 14.sp,
                fontWeight: FontWeight.w400,
                letterSpacing: 0.25.r,
              ),
              bodySmall: TextStyle(
                color: Colors.white,
                fontSize: 12.sp,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.25.r,
              ),
            ),
          ),
          builder: (context, widget) {
            return MediaQuery(
              data: MediaQuery.of(context).copyWith(
                textScaler: const TextScaler.linear(1.0),
              ),
              child: widget!,
            );
          },
          home: child,
        );
      },
      child: const HomeScreen(),
    );
  }
}

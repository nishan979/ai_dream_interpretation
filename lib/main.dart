import 'package:ai_dream_interpretation/app/bindings/initial_binding.dart';
import 'package:ai_dream_interpretation/constants.dart';
import 'package:ai_dream_interpretation/resources/colors/colors.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:get/get.dart';
import 'dart:async';
import 'app/routes/app_pages.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  FlutterError.onError = (details) {
    final msg = details.exceptionAsString();
    if (msg.contains('Cannot remove entry from a disposed snackbar')) {
      return;
    }
    FlutterError.presentError(details);
  };

  runZonedGuarded(
    () async {
      // Stripe.publishableKey = stripePublishableKey;
      await Firebase.initializeApp();

      runApp(
        ScreenUtilInit(
          designSize: const Size(360, 690),
          minTextAdapt: true,
          splitScreenMode: true,
          builder: (context, child) {
            return GetMaterialApp(
              initialBinding: InitialBinding(),
              title: "Ai Dream Interpretation Expert",
              initialRoute: AppPages.initial,
              getPages: AppPages.routes,
              debugShowCheckedModeBanner: false,
              defaultTransition: Transition.fadeIn,
              transitionDuration: const Duration(milliseconds: 400),
              theme: ThemeData(
                fontFamily: 'Inter',
                brightness: Brightness.dark,
                scaffoldBackgroundColor: const Color(0xFF0D0B1F),
                textTheme: const TextTheme(
                  bodyLarge: TextStyle(color: AppColors.textLight),
                  bodyMedium: TextStyle(color: AppColors.textLight),
                  displayLarge: TextStyle(color: AppColors.textLight),
                ),
                elevatedButtonTheme: ElevatedButtonThemeData(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    foregroundColor: AppColors.textLight,
                  ),
                ),
              ),
            );
          },
        ),
      );
    },
    (error, stack) {
      final msg = error.toString();
      if (msg.contains('Cannot remove entry from a disposed snackbar')) {
        // ignore
        return;
      }
      // (debug print removed)
    },
  );
}

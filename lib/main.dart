import 'package:flutter/material.dart';
import 'package:ivan_territo_alps2alps/providers/ride_booking_provider.dart';
import 'package:ivan_territo_alps2alps/screens/home_screen.dart';
import 'package:provider/provider.dart';

import 'core/themes/app_theme.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => RideBookingProvider()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ride Booking App',
      theme: AppTheme.lightTheme,
      home: HomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

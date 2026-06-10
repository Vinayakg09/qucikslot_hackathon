import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'cubit/auth/auth_cubit.dart';
import 'cubit/booking/booking_cubit.dart';
import 'cubit/venue/venue_cubit.dart';
import 'repo/booking_repo.dart';
import 'repo/venue_repo.dart';
import 'res/app_colors.dart';
import 'view/screens/login_screen.dart';

void main() {
  runApp(const QuickSlotApp());
}

class QuickSlotApp extends StatelessWidget {
  const QuickSlotApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => AuthCubit()..loadUsers()),
        BlocProvider(create: (_) => VenueCubit(VenueRepo())),
        BlocProvider(create: (_) => BookingCubit(BookingRepo())),
      ],
      child: MaterialApp(
        title: 'QuickSlot',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          scaffoldBackgroundColor: AppColors.background,
          colorScheme: const ColorScheme.dark(
            primary: AppColors.primary,
            surface: AppColors.surface,
          ),
          fontFamily: 'SF Pro Display',
        ),
        home: const LoginScreen(),
      ),
    );
  }
}
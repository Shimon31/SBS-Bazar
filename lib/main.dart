import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:sbs_ecommerce_flutter/screens/home_screen.dart';
import 'package:sbs_ecommerce_flutter/screens/profile_screen.dart';

import 'blocs/auth/auth_bloc.dart';
import 'blocs/auth/auth_event.dart';
import 'blocs/auth/auth_state.dart';
import 'blocs/product/product_bloc.dart';
import 'blocs/product/product_event.dart';
import 'blocs/category/category_bloc.dart';
import 'blocs/category/category_event.dart';
import 'blocs/cart/cart_bloc.dart';

import 'repositories/auth_repository.dart';
import 'repositories/product_repository.dart';
import 'repositories/category_repository.dart';

import 'screens/auth/login_screen.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final authRepository = AuthRepository();
    final productRepository = ProductRepository();
    final categoryRepository = CategoryRepository();

    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create: (_) => AuthBloc(authRepository: authRepository)
            ..add(const AuthCheckRequested()),
        ),

        BlocProvider<ProductBloc>(
          create: (_) => ProductBloc(productRepository: productRepository)
            ..add(const FetchAllProducts()),
        ),

        BlocProvider<CategoryBloc>(
          create: (_) => CategoryBloc(categoryRepository: categoryRepository)
            ..add(const FetchCategories()),
        ),

        BlocProvider<CartBloc>(
          create: (_) => CartBloc(),
        ),
      ],
      child: MaterialApp(
        title: 'ShopBlue',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.blueAccent,
            brightness: Brightness.light,
          ).copyWith(
            primary: Colors.blueAccent,
            secondary: Colors.blueAccent,
            surface: Colors.white,
          ),
          useMaterial3: true,
          appBarTheme: const AppBarTheme(
            centerTitle: true,
            elevation: 0,
            backgroundColor: Colors.white,
            foregroundColor: Colors.blueAccent,
            iconTheme: IconThemeData(color: Colors.blueAccent),
            titleTextStyle: TextStyle(
              color: Colors.blueAccent,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          scaffoldBackgroundColor: const Color(0xFFF0F4FF),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blueAccent,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          cardTheme: CardThemeData(
            color: Colors.white,
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          chipTheme: ChipThemeData(
            backgroundColor: Colors.white,
            selectedColor: Colors.blueAccent,
            labelStyle: const TextStyle(color: Colors.black87),
            secondaryLabelStyle: const TextStyle(color: Colors.white),
            side: const BorderSide(color: Colors.blueAccent),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
        ),

        home: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            if (state is AuthInitial || state is AuthLoading) {
              return const Scaffold(
                backgroundColor: Color(0xFFF0F4FF),
                body: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.shopping_bag_outlined,
                          color: Colors.blueAccent, size: 56),
                      SizedBox(height: 16),
                      CircularProgressIndicator(color: Colors.blueAccent),
                    ],
                  ),
                ),
              );
            }

            if (state is AuthAuthenticated) {
              return const HomeScreen();
            }

            return const LoginScreen();
          },
        ),
      ),
    );
  }
}
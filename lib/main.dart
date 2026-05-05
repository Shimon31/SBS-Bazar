import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sbs_ecommerce_flutter/screens/home_screen.dart';
import 'package:sbs_ecommerce_flutter/screens/main_screen.dart';

import 'blocs/product/product_bloc.dart';
import 'blocs/product/product_event.dart';
import 'blocs/category/category_bloc.dart';
import 'blocs/category/category_event.dart';
import 'blocs/cart/cart_bloc.dart';

import 'repositories/product_repository.dart';
import 'repositories/category_repository.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final productRepository = ProductRepository();
    final categoryRepository = CategoryRepository();

    return MultiBlocProvider(
      providers: [
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
        title: 'E-Commerce App',
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

          // AppBar — white with blue accent title/icons
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

          // Scaffold background — soft blue-white tint
          scaffoldBackgroundColor: const Color(0xFFF0F4FF),

          // ElevatedButton — blue accent
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blueAccent,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),

          // ✅ Fixed: use CardThemeData instead of CardTheme
          cardTheme: CardThemeData(
            color: Colors.white,
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),

          // Chip — blue accent selected state
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
        home: const HomeScreen(),
      ),
    );
  }
}
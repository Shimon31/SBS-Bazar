import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/product/product_bloc.dart';
import '../blocs/product/product_event.dart';
import '../blocs/product/product_state.dart';
import '../blocs/category/category_bloc.dart';
import '../blocs/category/category_event.dart';
import '../blocs/category/category_state.dart';

import '../widgets/product_card.dart';

class ExploreScreen extends StatelessWidget {
  const ExploreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(20, 16, 20, 12),
            child: Text(
              'Explore',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
          ),

          BlocBuilder<CategoryBloc, CategoryState>(
            builder: (context, state) {
              if (state is! CategoryLoaded) return const SizedBox();

              return SizedBox(
                height: 44,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    _chip(context, 'All', null, state.selectedCategoryId),
                    ...state.categories.map(
                          (c) => _chip(context, c.name, c.id, state.selectedCategoryId),
                    ),
                  ],
                ),
              );
            },
          ),

          const SizedBox(height: 12),

          Expanded(
            child: BlocBuilder<ProductBloc, ProductState>(
              builder: (context, state) {
                if (state is ProductLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (state is ProductLoaded) {
                  return GridView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: state.products.length,
                    gridDelegate:
                    const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.72,
                    ),
                    itemBuilder: (_, i) =>
                        ProductCard(product: state.products[i]),
                  );
                }

                return const SizedBox();
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _chip(BuildContext context, String label, int? id, int? selected) {
    final isSelected = id == selected;

    return GestureDetector(
      onTap: () {
        context.read<CategoryBloc>().add(SelectCategory(id));

        if (id == null) {
          context.read<ProductBloc>().add(const FetchAllProducts());
        } else {
          context.read<ProductBloc>().add(FetchProductsByCategory(id));
        }
      },
      child: Container(
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue : Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(label),
      ),
    );
  }
}
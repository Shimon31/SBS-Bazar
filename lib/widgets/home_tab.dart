import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../blocs/product/product_bloc.dart';
import '../../blocs/product/product_event.dart';
import '../../blocs/product/product_state.dart';
import '../../blocs/category/category_bloc.dart';
import '../../blocs/category/category_event.dart';
import '../../blocs/category/category_state.dart';
import '../../blocs/cart/cart_bloc.dart';
import '../../blocs/cart/cart_state.dart';
import '../../blocs/auth/auth_bloc.dart';
import '../../blocs/auth/auth_state.dart';

import '../../models/product_model.dart';
import '../../models/category_model.dart';

import '../../widgets/product_card.dart';
import '../../widgets/cart_badge.dart';
import '../screens/cart_screen.dart';
import '../screens/product_detail_screen.dart';


class HomeTab extends StatefulWidget {
  const HomeTab({super.key});

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(child: _buildHeader()),
          SliverToBoxAdapter(child: _buildSearchBar()),
          SliverToBoxAdapter(child: _buildBannerCard()),
          SliverToBoxAdapter(child: _buildCategoriesSection()),
          SliverToBoxAdapter(child: _buildTrendingSection()),
          const SliverToBoxAdapter(child: SizedBox(height: 20)),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, authState) {
        final userName = authState is AuthAuthenticated
            ? (authState.user.displayName ?? 'Shopper')
            : 'Shopper';

        return Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 16, 4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Hello, $userName ',
                    style: const TextStyle(
                      fontSize: 13,
                      color: Colors.black45,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 2),
                  const Text(
                    'Find your style',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
              BlocBuilder<CartBloc, CartState>(
                builder: (context, cartState) {
                  return CartBadge(
                    count: cartState.totalItems,
                    onTap: () {
                      final scaffold = context
                          .findAncestorStateOfType<
                          State<StatefulWidget>>();
                      if (scaffold != null) {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => const _CartNavigator(),
                          ),
                        );
                      }
                    },
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
      child: Container(
        height: 50,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.blueAccent.withOpacity(0.08),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: TextField(
          controller: _searchController,
          onChanged: (value) =>
              setState(() => _searchQuery = value.toLowerCase()),
          decoration: InputDecoration(
            hintText: 'Search products...',
            hintStyle:
            TextStyle(color: Colors.grey.shade400, fontSize: 14),
            prefixIcon: const Icon(Icons.search,
                color: Colors.blueAccent, size: 22),
            suffixIcon: _searchQuery.isNotEmpty
                ? IconButton(
              icon: const Icon(Icons.close,
                  color: Colors.grey, size: 18),
              onPressed: () {
                _searchController.clear();
                setState(() => _searchQuery = '');
              },
            )
                : null,
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(vertical: 14),
          ),
        ),
      ),
    );
  }


  Widget _buildBannerCard() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
      child: Container(
        height: 170,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: const LinearGradient(
            colors: [Color(0xFF1565C0), Colors.blueAccent],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.blueAccent.withOpacity(0.35),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Stack(
          children: [
            Positioned(
              right: -20,
              top: -20,
              child: Container(
                width: 130,
                height: 130,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.08),
                ),
              ),
            ),
            Positioned(
              right: 30,
              bottom: -30,
              child: Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.06),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      'LIMITED OFFER',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Up to 40% Off\nNew Arrivals',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      height: 1.3,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      'Shop Now →',
                      style: TextStyle(
                        color: Colors.blueAccent,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // CATEGORIES SECTION
  Widget _buildCategoriesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.fromLTRB(20, 0, 20, 12),
          child: Text(
            'Categories',
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
        ),
        BlocBuilder<CategoryBloc, CategoryState>(
          builder: (context, state) {
            if (state is CategoryLoading) {
              return const SizedBox(
                height: 100,
                child: Center(
                  child: CircularProgressIndicator(
                      color: Colors.blueAccent, strokeWidth: 2),
                ),
              );
            }
            if (state is CategoryLoaded) {
              return SizedBox(
                height: 100,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: state.categories.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 12),
                  itemBuilder: (context, index) => _buildCategoryCard(
                    context,
                    state.categories[index],
                    state.selectedCategoryId,
                  ),
                ),
              );
            }
            return const SizedBox.shrink();
          },
        ),
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildCategoryCard(
      BuildContext context, Category category, int? selectedId) {
    final isSelected = selectedId == category.id;
    return GestureDetector(
      onTap: () {
        context.read<CategoryBloc>().add(SelectCategory(category.id));
        context
            .read<ProductBloc>()
            .add(FetchProductsByCategory(category.id));
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 80,
        decoration: BoxDecoration(
          color: isSelected ? Colors.blueAccent : Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: isSelected
                  ? Colors.blueAccent.withOpacity(0.3)
                  : Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: CachedNetworkImage(
                imageUrl: category.imageUrl,
                width: 44,
                height: 44,
                fit: BoxFit.cover,
                errorWidget: (_, __, ___) => Icon(
                  Icons.category,
                  color: isSelected ? Colors.white : Colors.blueAccent,
                  size: 28,
                ),
              ),
            ),
            const SizedBox(height: 6),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Text(
                category.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: isSelected ? Colors.white : Colors.black54,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTrendingSection() {
    return BlocBuilder<ProductBloc, ProductState>(
      builder: (context, state) {
        if (state is ProductLoading) {
          return const SizedBox(
            height: 200,
            child: Center(
                child:
                CircularProgressIndicator(color: Colors.blueAccent)),
          );
        }

        if (state is ProductError) {
          return Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                const Icon(Icons.error_outline,
                    color: Colors.redAccent, size: 40),
                const SizedBox(height: 8),
                Text(state.message,
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.black45)),
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: () => context
                      .read<ProductBloc>()
                      .add(const FetchAllProducts()),
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }

        if (state is ProductLoaded) {
          final filtered = _searchQuery.isEmpty
              ? state.products
              : state.products
              .where((p) =>
          p.title.toLowerCase().contains(_searchQuery) ||
              p.category.name
                  .toLowerCase()
                  .contains(_searchQuery))
              .toList();

          if (filtered.isEmpty) {
            return const Padding(
              padding: EdgeInsets.all(40),
              child: Center(
                child: Text('No products found.',
                    style: TextStyle(color: Colors.black45)),
              ),
            );
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Trending horizontal scroll
              if (_searchQuery.isEmpty) ...[
                const Padding(
                  padding: EdgeInsets.fromLTRB(20, 0, 20, 12),
                  child: Text(
                    'Trending Now 🔥',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ),
                SizedBox(
                  height: 220,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    padding:
                    const EdgeInsets.symmetric(horizontal: 16),
                    itemCount:
                    filtered.length > 6 ? 6 : filtered.length,
                    separatorBuilder: (_, __) =>
                    const SizedBox(width: 12),
                    itemBuilder: (context, index) =>
                        _buildTrendingCard(context, filtered[index]),
                  ),
                ),
                const SizedBox(height: 24),
                const Padding(
                  padding: EdgeInsets.fromLTRB(20, 0, 20, 12),
                  child: Text(
                    'All Products',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ),
              ],

              if (_searchQuery.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
                  child: Text(
                    'Results (${filtered.length})',
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ),

              // Product grid
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: GridView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  gridDelegate:
                  const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 0.72,
                  ),
                  itemCount: filtered.length,
                  itemBuilder: (context, index) =>
                      ProductCard(product: filtered[index]),
                ),
              ),
            ],
          );
        }

        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildTrendingCard(BuildContext context, Product product) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
            builder: (_) => ProductDetailScreen(product: product)),
      ),
      child: Container(
        width: 150,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(16)),
                child: CachedNetworkImage(
                  imageUrl: product.imageUrl,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  placeholder: (_, __) => Container(
                    color: const Color(0xFFF0F4FF),
                    child: const Center(
                      child: CircularProgressIndicator(
                          color: Colors.blueAccent, strokeWidth: 2),
                    ),
                  ),
                  errorWidget: (_, __, ___) => Container(
                    color: const Color(0xFFF0F4FF),
                    child: const Icon(Icons.image_not_supported,
                        color: Colors.blueAccent),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '\$${product.price.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: Colors.blueAccent,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CartNavigator extends StatelessWidget {
  const _CartNavigator();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: CartScreenDirect(),
    );
  }
}


class CartScreenDirect extends StatelessWidget {
  const CartScreenDirect({super.key});

  @override
  Widget build(BuildContext context) {
    return const CartScreen(isEmbedded: false);
  }
}
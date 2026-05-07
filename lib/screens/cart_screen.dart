import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../blocs/cart/cart_bloc.dart';
import '../../blocs/cart/cart_event.dart';
import '../../blocs/cart/cart_state.dart';
import '../../models/cart_item_model.dart';

class CartScreen extends StatelessWidget {
  final bool isEmbedded;

  const CartScreen({
    super.key,
    this.isEmbedded = false,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F4FF),

      appBar: isEmbedded
          ? null
          : AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon:
          const Icon(Icons.arrow_back_ios, color: Colors.blueAccent),
          onPressed: () {
            if (Navigator.canPop(context)) {
              Navigator.pop(context);
            }
          },
        ),
        title: const Text(
          'My Cart',
          style: TextStyle(
            color: Colors.blueAccent,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          BlocBuilder<CartBloc, CartState>(
            builder: (context, state) {
              if (state.items.isEmpty) {
                return const SizedBox.shrink();
              }
              return TextButton(
                onPressed: () => _showClearDialog(context),
                child: const Text(
                  'Clear',
                  style: TextStyle(color: Colors.redAccent),
                ),
              );
            },
          ),
        ],
      ),

      body: SafeArea(
        child: BlocBuilder<CartBloc, CartState>(
          builder: (context, state) {
            if (state.items.isEmpty) {
              return _buildEmptyCart(context);
            }
        
            return Column(
              children: [
                Expanded(
                  child: ListView.separated(
                    padding: const EdgeInsets.all(16),
                    itemCount: state.items.length,
                    separatorBuilder: (_, __) =>
                    const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      return _buildCartItem(context, state.items[index]);
                    },
                  ),
                ),
                _buildCheckoutSummary(context, state),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildEmptyCart(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.shopping_cart_outlined,
              size: 80, color: Colors.blueAccent.withOpacity(0.4)),
          const SizedBox(height: 16),
          const Text(
            'Your cart is empty',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.black54,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Add some products to get started!',
            style: TextStyle(color: Colors.black38),
          ),
          const SizedBox(height: 24),

          ElevatedButton(
            onPressed: () {
              if (!isEmbedded && Navigator.canPop(context)) {
                Navigator.pop(context);
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blueAccent,
              padding:
              const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              'Continue Shopping',
              style: TextStyle(
                  color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCartItem(BuildContext context, CartItem item) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: CachedNetworkImage(
              imageUrl: item.product.imageUrl,
              width: 80,
              height: 80,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.product.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                      fontWeight: FontWeight.w600, fontSize: 14),
                ),
                const SizedBox(height: 4),
                Text(
                  '\$${item.product.price.toStringAsFixed(2)}',
                  style: const TextStyle(
                    color: Colors.blueAccent,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),

                Row(
                  children: [
                    _qtyButton(
                      icon: Icons.remove,
                      onTap: () => context
                          .read<CartBloc>()
                          .add(DecrementQuantity(item.product.id)),
                    ),
                    Padding(
                      padding:
                      const EdgeInsets.symmetric(horizontal: 12),
                      child: Text('${item.quantity}'),
                    ),
                    _qtyButton(
                      icon: Icons.add,
                      onTap: () => context
                          .read<CartBloc>()
                          .add(IncrementQuantity(item.product.id)),
                    ),
                  ],
                ),
              ],
            ),
          ),

          Column(
            children: [
              IconButton(
                onPressed: () => context
                    .read<CartBloc>()
                    .add(RemoveFromCart(item.product.id)),
                icon: const Icon(Icons.delete_outline,
                    color: Colors.redAccent),
              ),
              Text('\$${item.totalPrice.toStringAsFixed(2)}'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _qtyButton(
      {required IconData icon, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 28,
        height: 28,
        decoration: BoxDecoration(
          color: Colors.blueAccent.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, size: 16, color: Colors.blueAccent),
      ),
    );
  }

  Widget _buildCheckoutSummary(BuildContext context, CartState state) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
      decoration: const BoxDecoration(color: Colors.white),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Items'),
              Text('${state.totalItems}'),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Total'),
              Text('\$${state.totalPrice.toStringAsFixed(2)}'),
            ],
          ),
          const SizedBox(height: 16),

          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              onPressed: () =>
                  _showCheckoutDialog(context, state.totalPrice),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
              ),
              child: Text(
                  'Checkout  •  \$${state.totalPrice.toStringAsFixed(2)}'),
            ),
          ),
        ],
      ),
    );
  }


  void _showClearDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Clear Cart'),
        content: const Text('Remove all items?'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              context.read<CartBloc>().add(const ClearCart());
              Navigator.pop(context);
            },
            child:
            const Text('Clear', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _showCheckoutDialog(BuildContext context, double total) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Order Placed 🎉'),
        content:
        Text('Total: \$${total.toStringAsFixed(2)}'),
        actions: [
          ElevatedButton(
            onPressed: () {
              context.read<CartBloc>().add(const ClearCart());
              Navigator.pop(context);


              if (!isEmbedded && Navigator.canPop(context)) {
                Navigator.pop(context);
              }
            },
            child: const Text('Done'),
          ),
        ],
      ),
    );
  }
}
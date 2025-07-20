// ignore_for_file: prefer_final_fields

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_zth/bloc/pagination/pagination_bloc.dart';
import 'package:flutter_zth/data/models/paginations.dart';

class PaginationScreen extends StatefulWidget {
  const PaginationScreen({super.key});

  @override
  State<PaginationScreen> createState() => _PaginationScreenState();
}

class _PaginationScreenState extends State<PaginationScreen> {
  final ScrollController _scrollController = ScrollController();

  String _selectedSortBy = 'title';
  String _selectedOrder = 'asc';
  String _selectedCategory = 'all';

  Widget _buildSkeleton() => ListView.builder(
    shrinkWrap: true,
    itemCount: 10,
    itemBuilder:
        (_, __) => const ListTile(
          leading: CircleAvatar(backgroundColor: Colors.grey),
          title: SizedBox(
            height: 10,
            child: DecoratedBox(decoration: BoxDecoration(color: Colors.grey)),
          ),
          subtitle: SizedBox(
            height: 10,
            child: DecoratedBox(decoration: BoxDecoration(color: Colors.grey)),
          ),
        ),
  );

  Widget _buildProductItem(Product product) => ListTile(
    leading:
        product.thumbnail != null
            ? Image.network(product.thumbnail!, width: 50, height: 50)
            : const Icon(Icons.image),
    title: Text(product.title ?? 'No title'),
    subtitle: Text(
      '${product.category ?? 'Unknown'} • \$${product.price?.toStringAsFixed(2) ?? 'N/A'}',
    ),
  );

  void _triggerFetch() {
    context.read<PaginationBloc>().add(
      FetchProducts(
        sortBy: _selectedSortBy,
        order: _selectedOrder,
        category: _selectedCategory == 'all' ? null : _selectedCategory,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    PaginationBloc getProduct = context.read<PaginationBloc>();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (getProduct.state is PaginationInitial) {
        getProduct.add(
          FetchProducts(
            sortBy: _selectedSortBy,
            order: _selectedOrder,
            category: _selectedCategory,
          ),
        );
      }

      _scrollController.addListener(() {
        if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 300) {
          context.read<PaginationBloc>().add(LoadMoreProducts());
        }
      });
    });

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Product List'),
      ),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              DropdownButton<String>(
                value: _selectedCategory,
                onChanged: (val) {
                  if (val == null) return;
                  setState(() => _selectedCategory = val);
                  _triggerFetch();
                },
                items: const [
                  DropdownMenuItem(value: 'all', child: Text('All')),
                  DropdownMenuItem(
                    value: 'smartphones',
                    child: Text('Smartphones'),
                  ),
                  DropdownMenuItem(value: 'laptops', child: Text('Laptops')),
                  DropdownMenuItem(
                    value: 'fragrances',
                    child: Text('Fragrances'),
                  ),
                  DropdownMenuItem(
                    value: 'groceries',
                    child: Text('Groceries'),
                  ),
                ],
              ),
              DropdownButton<String>(
                value: _selectedSortBy,
                onChanged: (val) {
                  if (val == null) return;
                  setState(() => _selectedSortBy = val);
                  _triggerFetch();
                },
                items: const [
                  DropdownMenuItem(value: 'title', child: Text('Title')),
                  DropdownMenuItem(value: 'price', child: Text('Price')),
                  DropdownMenuItem(value: 'rating', child: Text('Rating')),
                ],
              ),
              DropdownButton<String>(
                value: _selectedOrder,
                onChanged: (val) {
                  if (val == null) return;
                  setState(() => _selectedOrder = val);
                  _triggerFetch();
                },
                items: const [
                  DropdownMenuItem(value: 'asc', child: Text('Asc')),
                  DropdownMenuItem(value: 'desc', child: Text('Desc')),
                ],
              ),
            ],
          ),
          Expanded(
            child: BlocConsumer<PaginationBloc, PaginationState>(
              listener: (context, state) {
                if (state is PaginationError) {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text(state.err)));
                }
              },
              builder: (context, state) {
                if (state is PaginationLoading) {
                  return _buildSkeleton();
                } else if (state is PaginationLoaded) {
                  final products = state.products;

                  if (products.isEmpty) {
                    return const Center(child: Text('No products found'));
                  }
                  final isLoadingMore = !state.hasReachedMax;

                  return ListView.builder(
                    controller: _scrollController,
                    itemCount: products.length + (isLoadingMore ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (index < products.length) {
                        return _buildProductItem(products[index]);
                      } else {
                        return const Padding(
                          padding: EdgeInsets.all(16),
                          child: Center(child: CircularProgressIndicator()),
                        );
                      }
                    },
                  );
                } else if (state is PaginationError) {
                  return Center(child: Text('Error: ${state.err}'));
                } else {
                  return const Center(child: CircularProgressIndicator());
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

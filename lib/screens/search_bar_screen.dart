import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_zth/bloc/all_products/products_bloc.dart';
import 'package:flutter_zth/data/models/products.dart';

class SearchBarScreen extends StatefulWidget {
  const SearchBarScreen({super.key});

  @override
  State<SearchBarScreen> createState() => _SearchBarScreenState();
}

class _SearchBarScreenState extends State<SearchBarScreen> {
  bool isDark = false;

  @override
  Widget build(BuildContext context) {
    ProductsBloc getAllProduct = context.read<ProductsBloc>();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (getAllProduct.state is ProductsInitial) {
        getAllProduct.add(FetchAllProducts());
      }
    });

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text("Search Bar"),
      ),
      body: BlocConsumer<ProductsBloc, ProductsState>(
        listener: (context, state) {
          if (state is ProductsError) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text("Error: ${state.error}")));

            debugPrint(state.error);
          }
        },
        builder: (context, state) {
          if (state is ProductsLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is ProductsLoaded) {
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: SearchAnchor(
                    builder: (
                      BuildContext context,
                      SearchController controller,
                    ) {
                      return SearchBar(
                        controller: controller,
                        padding: const WidgetStatePropertyAll<EdgeInsets>(
                          EdgeInsets.symmetric(horizontal: 16.0),
                        ),
                        onTap: () {
                          controller.openView();
                        },
                        onChanged: (_) {
                          controller.openView();
                        },
                        leading: const Icon(Icons.search),
                        backgroundColor: WidgetStateProperty.all(
                          Theme.of(context).colorScheme.inversePrimary,
                        ),
                      );
                    },
                    suggestionsBuilder: (
                      BuildContext context,
                      SearchController controller,
                    ) {
                      final query = controller.text.toLowerCase();
                      final filteredProducts =
                          state.products
                              .where(
                                (p) =>
                                    p.title?.toLowerCase().contains(query) ??
                                    false,
                              )
                              .toList();

                      return List<Widget>.generate(filteredProducts.length, (
                        int index,
                      ) {
                        final data = filteredProducts[index];

                        return Dismissible(
                          key: ValueKey(data.id),
                          background: Container(
                            color: Colors.greenAccent,
                            child: Icon(Icons.check),
                          ),
                          secondaryBackground: Container(
                            color: Colors.redAccent,
                            child: Icon(Icons.cancel),
                          ),
                          child: ListTile(
                            title: Text(data.title ?? "No Title"),
                            subtitle: Text(
                              "\$${data.price?.toStringAsFixed(2) ?? "-"}",
                            ),
                            leading:
                                data.image != null
                                    ? Image.network(
                                      data.image!,
                                      width: 40,
                                      height: 40,
                                    )
                                    : const CircleAvatar(),
                            onTap: () {
                              setState(() {
                                controller.closeView(data.title);
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder:
                                        (_) =>
                                            ProductDetailScreen(product: data),
                                  ),
                                );
                              });
                            },
                          ),
                        );
                      });
                    },
                  ),
                ),
                SizedBox(height: 10),
                Expanded(
                  child: ListView.builder(
                    itemCount: state.products.length,
                    physics: AlwaysScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      final data = state.products[index];

                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (context) =>
                                      ProductDetailScreen(product: data),
                            ),
                          );
                        },
                        child: ListTile(
                          title: Text(data.title ?? "No Title"),
                          subtitle: Text(
                            "\$${data.price?.toStringAsFixed(2) ?? "-"}",
                          ),
                          leading:
                              data.image != null
                                  ? Image.network(
                                    data.image!,
                                    width: 40,
                                    height: 40,
                                  )
                                  : CircleAvatar(),
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          } else {
            return const Center(child: Text("Error Error"));
          }
        },
      ),
    );
  }
}

class ProductDetailScreen extends StatelessWidget {
  final Products product;

  const ProductDetailScreen({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(product.title ?? "Detail"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            product.image != null
                ? Image.network(product.image!, height: 200)
                : CircleAvatar(),
            const SizedBox(height: 16),
            Text(
              product.title ?? "No Title",
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text("\$${product.price?.toStringAsFixed(2) ?? "-"}"),
            const SizedBox(height: 8),
            Text(product.description ?? "No Description"),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_zth/bloc/all_products/products_bloc.dart';
import 'package:flutter_zth/data/constants.dart';
import 'package:flutter_zth/data/models/products.dart';

class SearchBarScreen extends StatefulWidget {
  const SearchBarScreen({super.key});

  @override
  State<SearchBarScreen> createState() => _SearchBarScreenState();
}

class _SearchBarScreenState extends State<SearchBarScreen> {
  bool isDark = false;

  Future<void> _refresh(BuildContext context) async {
    context.read<ProductsBloc>().add(FetchAllProducts());

    await Future.delayed(Duration(seconds: 2));
  }

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
          Widget widget;

          if (state is ProductsLoading) {
            widget = const Center(child: CircularProgressIndicator());
          } else if (state is ProductsLoaded) {
            widget = Column(
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

                        return ListTile(
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
                                      (_) => ProductDetailScreen(product: data),
                                ),
                              );
                            });
                          },
                        );
                      });
                    },
                  ),
                ),
                SizedBox(height: 10),
                Expanded(
                  child: Stack(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(20),
                        child: Align(
                          alignment: Alignment.bottomCenter,
                          child: Text(
                            "Swipe ListTile untuk menghapus data",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(20),
                        child: Align(
                          alignment: Alignment.topCenter,
                          child: Text(
                            "Swipe down untuk refresh data",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      RefreshIndicator(
                        edgeOffset: 0,
                        strokeWidth: 2,
                        color: KTextStyle.generalTextStyle(context),
                        backgroundColor: KTextStyle.generalColor(context),
                        onRefresh: () => _refresh(context),
                        child: ListView.builder(
                          itemCount: state.products.length,
                          physics: AlwaysScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            final data = state.products[index];

                            return Dismissible(
                              key: ValueKey(data.id),
                              onDismissed: (direction) {
                                setState(() {
                                  state.products.removeAt(index);
                                });

                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    backgroundColor: KTextStyle.generalColor(
                                      context,
                                    ),
                                    content: Text(
                                      "List Removed at ${data.id}",
                                      style: KTextStyle.bodyTextStyle(context),
                                    ),
                                  ),
                                );
                              },
                              background: Container(
                                color: Colors.redAccent,
                                child: Icon(Icons.cancel),
                              ),
                              secondaryBackground: Container(
                                color: Colors.redAccent,
                                child: Icon(Icons.cancel),
                              ),
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder:
                                          (context) => ProductDetailScreen(
                                            product: data,
                                          ),
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
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          } else {
            widget = const Center(child: Text("Error Error"));
          }

          return widget;
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

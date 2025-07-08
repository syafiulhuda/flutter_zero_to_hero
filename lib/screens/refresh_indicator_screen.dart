import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_zth/bloc/single_product/product_bloc.dart';
import 'package:flutter_zth/data/constants.dart';

class RefreshIndicatorScreen extends StatelessWidget {
  const RefreshIndicatorScreen({super.key});

  Future<void> _refresh(BuildContext context) async {
    context.read<ProductBloc>().add(
      FetchSingleProduct(userId: 1 + Random().nextInt(20)),
    );

    await Future.delayed(Duration(seconds: 2));
  }

  @override
  Widget build(BuildContext context) {
    ProductBloc getSingleProduct = context.read<ProductBloc>();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (getSingleProduct.state is ProductInitial) {
        getSingleProduct.add(
          FetchSingleProduct(userId: 1 + Random().nextInt(20)),
        );
      }
    });

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text("Refresh Indicator"),
      ),
      body: Stack(
        children: [
          Center(
            child: Text(
              "pull down to refresh content",
              textAlign: TextAlign.center,
            ),
          ),
          BlocConsumer<ProductBloc, ProductState>(
            listener: (context, state) {
              if (state is ProductError) {
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text(state.error)));

                debugPrint(state.error);
              }
            },
            builder: (context, state) {
              if (state is ProductLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is ProductLoaded) {
                return RefreshIndicator.adaptive(
                  edgeOffset: 0,
                  strokeWidth: 2,
                  color: KTextStyle.generalTextStyle(context),
                  backgroundColor: KTextStyle.generalColor(context),
                  onRefresh: () => _refresh(context),
                  child: ListView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    children: [
                      ListTile(
                        subtitle: Text(
                          "\$${state.product.price?.toStringAsFixed(2) ?? "-"}",
                        ),
                        title: Text(state.product.title ?? "No Title"),
                        leading:
                            state.product.image != null
                                ? Image.network(
                                  state.product.image!,
                                  width: 40,
                                  height: 40,
                                )
                                : null,
                      ),
                    ],
                  ),
                );
              } else {
                return const Center(child: Text("Click the button"));
              }
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          getSingleProduct.add(
            FetchSingleProduct(userId: 1 + Random().nextInt(20)),
          );
        },
        child: Icon(Icons.refresh, color: KTextStyle.generalTextStyle(context)),
      ),
    );
  }
}

import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_zth/data/models/products.dart';

import 'package:http/http.dart' as http;

part 'products_event.dart';
part 'products_state.dart';

class ProductsBloc extends Bloc<ProductsEvent, ProductsState> {
  ProductsBloc() : super(ProductsInitial()) {
    on<FetchAllProducts>(_fetchAllProducts);
  }

  void _fetchAllProducts(
    FetchAllProducts event,
    Emitter<ProductsState> emit,
  ) async {
    try {
      emit(ProductsLoading());

      Uri url = Uri.parse("https://fakestoreapi.com/products");
      var response = await http.get(url);

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        List<Products> products =
            data.map((item) => Products.fromMap(item)).toList();

        emit(ProductsLoaded(products: products));
      } else {
        emit(const ProductsError(error: "Failed to Get All Products"));
      }
    } catch (e) {
      emit(ProductsError(error: "Error: $e"));
    }
  }
}

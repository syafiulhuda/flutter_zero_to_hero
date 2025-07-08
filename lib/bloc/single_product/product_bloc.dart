import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_zth/data/models/products.dart';

import 'package:http/http.dart' as http;

part 'product_event.dart';
part 'product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  ProductBloc() : super(ProductInitial()) {
    on<FetchSingleProduct>(_fetchSingleProduct);
  }

  void _fetchSingleProduct(
    FetchSingleProduct event,
    Emitter<ProductState> emit,
  ) async {
    try {
      emit(ProductLoading());

      Uri url = Uri.parse("https://fakestoreapi.com/products/${event.userId}");
      var response = await http.get(url);

      if (response.statusCode == 200) {
        Map<String, dynamic> data = json.decode(response.body);

        Products product = Products.fromMap(data);

        emit(ProductLoaded(product: product));
      }
    } catch (e) {
      emit(ProductError(error: "Error $e"));
    }
  }
}

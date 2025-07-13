import 'package:flutter/material.dart';
import 'package:flutter_zth/data/models/paginations.dart';
import 'package:http/http.dart' as http;

class PaginationRepository {
  Future<PaginationSorting> getProducts({
    int limit = 10,
    int skip = 0,
    String sortBy = 'title',
    String order = 'asc',
    String? category,
  }) async {
    Uri url;
    if (category != null && category != 'all') {
      url = Uri.parse(
        'https://dummyjson.com/products/category/${Uri.encodeComponent(category)}?'
        'limit=$limit&skip=$skip&sortBy=$sortBy&order=$order',
      );
    } else {
      url = Uri.parse(
        'https://dummyjson.com/products?limit=$limit&skip=$skip&sortBy=$sortBy&order=$order',
      );
    }

    final response = await http.get(url);
    debugPrint('URL: ${url.toString()}');
    debugPrint('Response status: ${response.statusCode}');

    if (response.statusCode == 200) {
      try {
        return PaginationSorting.fromJson(response.body);
      } catch (e, stack) {
        debugPrint('Parsing error: $e');
        debugPrint('Stack trace: $stack');
        debugPrint('Response body: ${response.body}');
        rethrow;
      }
    }

    if (response.statusCode == 200) {
      return PaginationSorting.fromJson(response.body);
    } else {
      throw Exception('Failed to load products');
    }
  }
}

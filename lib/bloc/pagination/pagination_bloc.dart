import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_zth/data/pagination_repository.dart';
import 'package:flutter_zth/data/models/paginations.dart';

part 'pagination_event.dart';
part 'pagination_state.dart';

class PaginationBloc extends Bloc<PaginationEvent, PaginationState> {
  final PaginationRepository repo;

  PaginationBloc(this.repo) : super(PaginationInitial()) {
    on<FetchProducts>(_onFetchProducts);
    on<LoadMoreProducts>(_onLoadMore);
  }

  Future<void> _onFetchProducts(
    FetchProducts event,
    Emitter<PaginationState> emit,
  ) async {
    emit(PaginationLoading());

    try {
      final data = await repo.getProducts(
        limit: event.limit,
        skip: event.skip,
        sortBy: event.sortBy,
        order: event.order,
        category: event.category,
      );

      await Future.delayed(const Duration(seconds: 1));

      emit(
        PaginationLoaded(
          products: data.products ?? [],
          hasReachedMax: (data.products?.length ?? 0) < event.limit,
          sortBy: event.sortBy,
          order: event.order,
          category: event.category,
        ),
      );
    } catch (e, stackTrace) {
      debugPrint("Error fetching products: $e");
      debugPrint("Stack trace: $stackTrace");
      emit(PaginationError(err: "Failed to load data: ${e.toString()}"));
    }
  }

  Future<void> _onLoadMore(
    LoadMoreProducts event,
    Emitter<PaginationState> emit,
  ) async {
    if (state is! PaginationLoaded) return;

    final currentState = state as PaginationLoaded;
    if (currentState.hasReachedMax) return;

    try {
      final data = await repo.getProducts(
        limit: 10,
        skip: currentState.products.length,
        sortBy: currentState.sortBy,
        order: currentState.order,
        category: currentState.category,
      );

      final allProducts = [...currentState.products, ...data.products!];

      emit(
        currentState.copyWith(
          products: allProducts,
          hasReachedMax: data.products!.length < 10,
        ),
      );
    } catch (e) {
      emit(PaginationError(err: e.toString()));
    }
  }
}

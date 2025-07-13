part of 'pagination_bloc.dart';

sealed class PaginationState extends Equatable {
  const PaginationState();

  @override
  List<Object> get props => [];
}

final class PaginationInitial extends PaginationState {}

final class PaginationLoading extends PaginationState {}

class PaginationLoaded extends PaginationState {
  final List<Product> products;
  final bool hasReachedMax;
  final String sortBy;
  final String order;
  final String? category;

  const PaginationLoaded({
    required this.products,
    required this.hasReachedMax,
    required this.sortBy,
    required this.order,
    this.category,
  });

  PaginationLoaded copyWith({
    List<Product>? products,
    bool? hasReachedMax,
    String? sortBy,
    String? order,
    String? category,
  }) {
    return PaginationLoaded(
      products: products ?? this.products,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      sortBy: sortBy ?? this.sortBy,
      order: order ?? this.order,
      category: category ?? this.category,
    );
  }

  @override
  List<Object> get props => [
    products,
    hasReachedMax,
    sortBy,
    order,
    if (category != null) category!,
  ];
}

final class PaginationError extends PaginationState {
  final String err;

  const PaginationError({required this.err});

  @override
  List<Object> get props => [err];
}

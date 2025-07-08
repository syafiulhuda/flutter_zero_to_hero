part of 'product_bloc.dart';

sealed class ProductState extends Equatable {
  const ProductState();

  @override
  List<Object> get props => [];
}

final class ProductInitial extends ProductState {}

final class ProductLoading extends ProductState {}

final class ProductLoaded extends ProductState {
  final Products product;

  const ProductLoaded({required this.product});

  @override
  List<Object> get props => [product];
}

final class ProductError extends ProductState {
  final String error;

  const ProductError({required this.error});

  @override
  List<Object> get props => [error];
}

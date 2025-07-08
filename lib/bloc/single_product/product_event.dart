part of 'product_bloc.dart';

sealed class ProductEvent extends Equatable {
  const ProductEvent();

  @override
  List<Object> get props => [];
}

class FetchSingleProduct extends ProductEvent {
  final int userId;

  const FetchSingleProduct({required this.userId});

  @override
  List<Object> get props => [userId];
}

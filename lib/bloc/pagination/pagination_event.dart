part of 'pagination_bloc.dart';

sealed class PaginationEvent extends Equatable {
  const PaginationEvent();

  @override
  List<Object> get props => [];
}

class FetchProducts extends PaginationEvent {
  final int limit;
  final int skip;
  final String sortBy;
  final String order;
  final String? category;

  const FetchProducts({
    this.limit = 10,
    this.skip = 0,
    this.sortBy = 'title',
    this.order = 'asc',
    this.category,
  });

  @override
  List<Object> get props => [
    limit,
    skip,
    sortBy,
    order,
    if (category != null) category!,
  ];
}

class LoadMoreProducts extends PaginationEvent {}

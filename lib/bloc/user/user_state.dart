part of 'user_bloc.dart';

sealed class UserState extends Equatable {
  final List<Users> users;
  const UserState({required this.users});

  @override
  List<Object> get props => [users];
}

final class UserInitial extends UserState {
  const UserInitial({required super.users});
}

final class UserUpdated extends UserState {
  const UserUpdated({required super.users});
}

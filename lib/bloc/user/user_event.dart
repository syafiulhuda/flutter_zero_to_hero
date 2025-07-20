part of 'user_bloc.dart';

sealed class UserEvent extends Equatable {
  const UserEvent();

  @override
  List<Object> get props => [];
}

class AddUser extends UserEvent {
  final Users users;

  const AddUser({required this.users});

  @override
  List<Object> get props => [users];
}

class DeleteUser extends UserEvent {
  final Users users;

  const DeleteUser({required this.users});

  @override
  List<Object> get props => [users];
}

class UpdateUser extends UserEvent {
  final Users users;

  const UpdateUser({required this.users});

  @override
  List<Object> get props => [users];
}

class LoadUsers extends UserEvent {
  @override
  List<Object> get props => [];
}

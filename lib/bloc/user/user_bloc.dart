import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_zth/data/models/users.dart';

part 'user_event.dart';
part 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  UserBloc() : super(UserInitial(users: [])) {
    on<AddUser>(_addUser);
    on<DeleteUser>(_deleteUser);
    on<UpdateUser>(_updateUser);
  }

  void _addUser(AddUser event, Emitter<UserState> emit) {
    final updateUser = List<Users>.from(state.users)..add(event.users);

    emit(UserUpdated(users: updateUser));
  }

  void _deleteUser(DeleteUser event, Emitter<UserState> emit) {
    final deleteUser = List<Users>.from(state.users)..remove(event.users);

    emit(UserUpdated(users: deleteUser));
  }

  void _updateUser(UpdateUser event, Emitter<UserState> emit) {
    final updateUser =
        state.users.map((e) {
          return e.id == event.users.id ? event.users : e;
        }).toList();

    emit(UserUpdated(users: updateUser));
  }
}

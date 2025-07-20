import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_zth/data/models/users.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'user_event.dart';
part 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  UserBloc() : super(UserInitial(users: [])) {
    on<AddUser>(_addUser);
    on<DeleteUser>(_deleteUser);
    on<UpdateUser>(_updateUser);

    on<LoadUsers>(_loadUsers);
    add(LoadUsers());
  }

  /// Event: Load from SharedPreferences
  Future<void> _loadUsers(LoadUsers event, Emitter<UserState> emit) async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = prefs.getStringList('user_list') ?? [];

    final loadedUsers =
        userJson
            .map((userStr) => Users.fromJson(json.decode(userStr)))
            .toList();

    emit(UserUpdated(users: loadedUsers));
  }

  /// Simpan ke SharedPreferences
  Future<void> _saveUsersToPrefs(List<Users> users) async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = users.map((user) => json.encode(user.toJson())).toList();
    await prefs.setStringList('user_list', userJson);
  }

  /// Tambah user
  Future<void> _addUser(AddUser event, Emitter<UserState> emit) async {
    final updatedUsers = List<Users>.from(state.users)..add(event.users);
    await _saveUsersToPrefs(updatedUsers);
    emit(UserUpdated(users: updatedUsers));
  }

  /// Hapus user
  Future<void> _deleteUser(DeleteUser event, Emitter<UserState> emit) async {
    final updatedUsers = List<Users>.from(state.users)
      ..removeWhere((u) => u.id == event.users.id);
    await _saveUsersToPrefs(updatedUsers);
    emit(UserUpdated(users: updatedUsers));
  }

  /// Update user
  Future<void> _updateUser(UpdateUser event, Emitter<UserState> emit) async {
    final updatedUsers =
        state.users
            .map((u) => u.id == event.users.id ? event.users : u)
            .toList();
    await _saveUsersToPrefs(updatedUsers);
    emit(UserUpdated(users: updatedUsers));
  }
}

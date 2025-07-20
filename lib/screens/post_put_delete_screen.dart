import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_zth/bloc/user/user_bloc.dart';
import 'package:flutter_zth/data/constants.dart';
import 'package:flutter_zth/data/models/users.dart';

class PostPutDeleteScreen extends StatelessWidget {
  const PostPutDeleteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final userBloc = context.read<UserBloc>();

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('CRUD'),
      ),
      body: BlocBuilder<UserBloc, UserState>(
        builder: (context, state) {
          if (state.users.isEmpty) {
            return const Center(child: Text("No User Found!"));
          }

          return ListView.builder(
            itemCount: state.users.length,
            itemBuilder: (context, index) {
              final user = state.users[index];
              return _buildUserTile(context, user);
            },
          );
        },
      ),
      floatingActionButton: ElevatedButton(
        onPressed: () {
          final state = userBloc.state;
          final id =
              state.users.isEmpty
                  ? 1
                  : state.users
                          .map((u) => u.id)
                          .reduce((a, b) => a > b ? a : b) +
                      1;

          _showBottomSheet(context: context, id: id);
        },
        child: const Text("Add User"),
      ),
    );
  }

  Widget _buildUserTile(BuildContext context, Users user) {
    final userBloc = context.read<UserBloc>();

    return ListTile(
      leading: Text("${user.id}", style: KTextStyle.bodyTextStyle(context)),
      title: Text(user.name),
      subtitle: Text(user.email),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () => userBloc.add(DeleteUser(users: user)),
          ),
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed:
                () => _showBottomSheet(
                  context: context,
                  id: user.id,
                  isEdit: true,
                  existingUser: user,
                ),
          ),
        ],
      ),
    );
  }

  void _showBottomSheet({
    required BuildContext context,
    required int id,
    bool isEdit = false,
    Users? existingUser,
  }) {
    final userBloc = context.read<UserBloc>();

    final TextEditingController nameController = TextEditingController(
      text: existingUser?.name ?? '',
    );
    final TextEditingController emailController = TextEditingController(
      text: existingUser?.email ?? '',
    );

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return FractionallySizedBox(
              heightFactor: .25,
              child: Padding(
                padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom,
                  top: 16,
                  left: 16,
                  right: 16,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: nameController,
                      decoration: const InputDecoration(hintText: 'Name ...'),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: emailController,
                      decoration: const InputDecoration(hintText: 'Email ...'),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        final user = Users(
                          id: id,
                          name: nameController.text,
                          email: emailController.text,
                        );

                        if (isEdit) {
                          userBloc.add(UpdateUser(users: user));
                        } else {
                          userBloc.add(AddUser(users: user));
                        }

                        Navigator.pop(context);
                      },
                      child: Text(isEdit ? 'Update User' : 'Add User'),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}

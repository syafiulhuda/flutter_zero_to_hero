import 'package:flutter/material.dart';

class TextFieldScreen extends StatefulWidget {
  const TextFieldScreen({super.key});

  @override
  State<TextFieldScreen> createState() => _TextFieldScreenState();
}

class _TextFieldScreenState extends State<TextFieldScreen> {
  TextEditingController username = TextEditingController();
  TextEditingController password = TextEditingController();

  String _displayUsername = '';
  String _displayPassword = '';
  String _displayMenuItem = '';

  bool isChecked = false;

  String? menuItem;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    username.dispose();
    password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text("TextField Screen"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: username,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Username',
                  labelText: 'Username',
                ),
              ),
              SizedBox(height: 10),
              TextField(
                controller: password,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Password',
                  labelText: 'Password',
                ),
                obscureText: true,
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Jenis Kelamin:",
                    style: TextStyle(color: colorScheme.onSurface),
                  ),
                  DropdownButton(
                    value: menuItem,
                    items: [
                      DropdownMenuItem(
                        value: 'Laki-Laki',
                        child: Text("Laki-Laki"),
                      ),
                      DropdownMenuItem(
                        value: 'Perempuan',
                        child: Text("Perempuan"),
                      ),
                    ],
                    onChanged: (String? value) {
                      setState(() {
                        menuItem = value;
                      });
                    },
                  ),
                ],
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text("I Agree with...."),
                  Checkbox(
                    activeColor: colorScheme.inversePrimary,
                    value: isChecked,
                    onChanged:
                        (bool? value) => setState(() {
                          isChecked = value ?? false;
                        }),
                  ),
                ],
              ),
              SizedBox(height: 10),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  elevation: 4,
                  fixedSize: Size(screenWidth * 0.70, 50),
                  backgroundColor: colorScheme.inversePrimary,
                  disabledBackgroundColor: colorScheme.surfaceContainerHighest,
                  disabledForegroundColor: colorScheme.onSurfaceVariant,
                ),
                onPressed:
                    isChecked &&
                            username.text.isNotEmpty &&
                            password.text.isNotEmpty &&
                            menuItem != null
                        ? () {
                          setState(() {
                            _displayUsername = username.text;
                            _displayPassword = password.text;
                            _displayMenuItem = menuItem ?? '';
                          });

                          username.clear();
                          password.clear();

                          menuItem = null;
                          isChecked = false;
                        }
                        : null,
                child: Text(
                  "Submit",
                  style: TextStyle(color: colorScheme.onSurface),
                ),
              ),
              SizedBox(height: 20),
              Text("Your Username: $_displayUsername"),
              Text("Your Password: $_displayPassword"),
              Text("Your Gender: $_displayMenuItem"),
            ],
          ),
        ),
      ),
    );
  }
}

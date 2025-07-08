import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class DrawerScreen extends StatelessWidget {
  const DrawerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text("Drawer Screen"),
        actions: [
          IconButton(
            onPressed: () {
              // context.go('/app');
              context.go('/home');
            },
            icon: Icon(Icons.home),
          ),
        ],
      ),
      drawer: HeroWidget(),
    );
  }
}

class HeroWidget extends StatelessWidget {
  const HeroWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    double height = MediaQuery.of(context).size.height;

    return Hero(
      tag: 'hero1',
      child: Drawer(
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    colorScheme.inversePrimary,
                    colorScheme.onPrimaryContainer,
                  ],
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(75),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Image.network(
                        "https://random-image-pepebigotes.vercel.app/api/random-image",
                        height: height * 0.20,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                      Text(
                        "ClipRRect Widget",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            ListTile(
              title: Text(
                "About",
                style: TextStyle(color: colorScheme.onSurface),
              ),
              trailing: Icon(Icons.person, color: colorScheme.inversePrimary),
            ),
            ListTile(
              title: Text(
                "Help",
                style: TextStyle(color: colorScheme.onSurface),
              ),
              trailing: Icon(Icons.help, color: colorScheme.inversePrimary),
            ),
            Spacer(),
            Divider(
              height: 5,
              thickness: 2,
              color: colorScheme.inversePrimary,
              indent: 10,
              endIndent: 10,
            ),
            ListTile(
              title: Text(
                "Log Out",
                style: TextStyle(color: colorScheme.onSurface),
              ),
              trailing: Icon(
                Icons.logout_outlined,
                color: colorScheme.inversePrimary,
              ),
            ),
            SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}

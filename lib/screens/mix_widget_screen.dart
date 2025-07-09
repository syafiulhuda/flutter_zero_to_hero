import 'package:flutter/material.dart';
import 'package:flutter_zth/data/constants.dart';
import 'package:animated_flip_counter/animated_flip_counter.dart';

class MixWidgetScreen extends StatefulWidget {
  const MixWidgetScreen({super.key});

  @override
  State<MixWidgetScreen> createState() => _MixWidgetScreenState();
}

class _MixWidgetScreenState extends State<MixWidgetScreen> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  void _reset() {
    setState(() {
      _counter -= _counter;
    });
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: KTextStyle.generalColor(context),
        title: Text("Beranda Screen"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            color: colorScheme.onSecondary,
            child: ListTile(
              title: Text(
                "List Tile",
                style: TextStyle(color: colorScheme.inverseSurface),
              ),
              leading: Icon(
                Icons.person,
                color: KTextStyle.generalColor(context),
              ),
              trailing: Icon(
                Icons.star,
                color: KTextStyle.generalColor(context),
              ),
              subtitle: Text(
                "subtitle",
                style: TextStyle(color: colorScheme.inverseSurface),
              ),
            ),
          ),
          SizedBox(height: 10),
          Stack(
            alignment: Alignment(0, 0),
            children: [
              InkWell(
                splashColor: KTextStyle.generalColor(context),
                onTap: () {},
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  height: 250,
                  width: double.infinity,
                  child: Image.network(
                    'https://dummyjson.com/icon/abc123/150',
                    fit: BoxFit.cover,
                    height: double.infinity,
                    width: double.infinity,
                  ),
                ),
              ),
              Text(
                "STACK TEXT",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          SizedBox(height: 10),
          Text(
            'You have pushed the button this many times:',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 20),
          ),
          SizedBox(height: 10),
          Container(
            height: 75,
            width: 75,
            decoration: BoxDecoration(
              color: KTextStyle.generalColor(context),
              borderRadius: BorderRadius.circular(25.0),
            ),
            child: Center(
              child: AnimatedFlipCounter(
                duration: Duration(milliseconds: 500),
                value: _counter,
                textStyle: TextStyle(
                  color: KTextStyle.generalTextStyle(context),
                  fontSize: 25,
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: _incrementCounter,
            tooltip: 'Increment',
            heroTag: null,
            child: const Icon(Icons.add),
          ),
          const SizedBox(height: 10),
          FloatingActionButton(
            onPressed: _reset,
            tooltip: 'Reset',
            heroTag: null,
            child: const Icon(Icons.delete_outline),
          ),
        ],
      ),
    );
  }
}

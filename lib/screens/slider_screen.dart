import 'package:flutter/material.dart';

class SliderScreen extends StatefulWidget {
  const SliderScreen({super.key});

  @override
  State<SliderScreen> createState() => _SliderScreenState();
}

class _SliderScreenState extends State<SliderScreen> {
  double _currentValue = 0.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text("Slider"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Slider(
            max: 100.0,
            min: 0.0,
            divisions: 100,
            label: _currentValue.round().toString(),
            value: _currentValue,
            onChanged: (double value) {
              setState(() {
                _currentValue = value;
              });
            },
          ),
          Text("Slider Value: ${_currentValue.round()}"),
        ],
      ),
    );
  }
}

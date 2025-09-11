import 'package:flutter/material.dart';
// import 'package:razorpay_flutter/razorpay_flutter.dart';

class RzPay extends StatefulWidget {
  const RzPay({Key? key}) : super(key: key);

  @override
  State<RzPay> createState() => _RzPayState();
}

class _RzPayState extends State<RzPay> {
  final int _counter = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  void _incrementCounter() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text("RZ pay"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

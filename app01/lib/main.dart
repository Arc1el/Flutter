import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "AppBar",
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: const MyPage(),
    );
  }
}

class MyPage extends StatelessWidget {
  const MyPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Appbar icon menu"),
        centerTitle: true,
        elevation: 0.0,
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () {
            // ignore: avoid_print
            print("menu button is clicked");
          },
        ),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () {
              // ignore: avoid_print
              print("Shopping cart button is clicked");
            },
          ),
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // ignore: avoid_print
              print("Search button is clicked");
            },
          ),
        ],
      ),
    );
  }
}

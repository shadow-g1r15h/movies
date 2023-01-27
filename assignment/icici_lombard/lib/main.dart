import 'package:flutter/material.dart';
import 'package:icici_lombard/Provider/movie_provider.dart';
import 'package:provider/provider.dart';
import 'package:icici_lombard/movies/home.dart';

void main() async {
  runApp(const RootAppWrapper());
}

//RootAppWrapper used to set the providers when the app starts.
class RootAppWrapper extends StatelessWidget {
  const RootAppWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => MovieApi()),
      ],
      child: const MyApp(),
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'My Movies',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(),
    );
  }
}

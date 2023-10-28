import 'package:flutter/material.dart';
import 'package:pokedex/UI/home.dart';
import 'package:pokedex/UI/pokemon_favorites.dart';
import 'package:pokedex/UI/pokemon_view.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(scaffoldBackgroundColor: Colors.white),
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: <String, WidgetBuilder>{
        '/': (BuildContext context) => const HomePage(),
        'pokemonView': (BuildContext context) => const PokemonView(),
        'favorites': (BuildContext context) => const PokemonFavorites(),
      },
    );
  }
}

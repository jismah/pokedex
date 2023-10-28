import 'package:flutter/material.dart';

class PokemonFavorites extends StatefulWidget {
  const PokemonFavorites({super.key});

  @override
  State<PokemonFavorites> createState() => _PokemonFavoritesState();
}

class _PokemonFavoritesState extends State<PokemonFavorites> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Favoritos",
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: const Center(child: Text("Lista de Favoritos")),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:pokedex/Models/pokemon.dart';
import 'package:pokedex/Utils/pokemon-favorites.dart';

class PokemonFavorites extends StatefulWidget {
  const PokemonFavorites({super.key});

  @override
  State<PokemonFavorites> createState() => _PokemonFavoritesState();
}

class _PokemonFavoritesState extends State<PokemonFavorites> {
  List<Pokemon> pokemonFavoritesList =
      ListPokemonFavorites().getPokemonFavorites();

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
        body: const Center(child: Text("Favoritos")));
  }

  Text _getinitialtext() {
    print(pokemonFavoritesList);
    //JOHN MODIFICA ESTOOO
    return Text(pokemonFavoritesList[0].name ?? "toy vacio mmg llename");
  }
}

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pokedex/Models/pokemon.dart';
import 'package:pokedex/UI/pokemon_view.dart';
import 'package:pokedex/Utils/pokemon-favorites.dart';

class Favorites extends StatelessWidget {
  const Favorites({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favoritos', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25)),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        toolbarHeight: 70,
        // actions: <Widget>[
        //   IconButton(
        //     icon: const Icon(
        //       Icons.favorite,
        //       color: Colors.black,
        //     ),
        //     onPressed: () {
        //       Navigator.pushNamed(context, 'favorites');
        //     },
        //   ),
        // ],
      ),
      body: const PokemonFavorites(),
      /* floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.red.shade900,
        onPressed: () {
          Navigator.pushNamed(context, 'favorites');
        },
        child: const Icon(
          Icons.favorite,
          color: Colors.white,
        ),
      ), */
    );
  }
}

class PokemonFavorites extends StatefulWidget {
  const PokemonFavorites({super.key});

  @override
  State<PokemonFavorites> createState() => _PokemonFavoritesState();
}

class _PokemonFavoritesState extends State<PokemonFavorites> {
  ListPokemonFavorites pokemonFavorites = ListPokemonFavorites();
  List<Pokemon> pokemonListAll = [];

  @override
  void initState() {
    _getPokemonListAll();
    // _getFavorites();
    super.initState();
  }

  @override
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Padding(
        //   padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
        //   child: TextField(
        //     onChanged: (value) {
        //       filterSearchResults(value);
        //     },
        //     controller: searchController,
        //     decoration: InputDecoration(
        //       enabledBorder: OutlineInputBorder(
        //         borderSide: const BorderSide(color: Colors.black38, width: 1.5),
        //         borderRadius: BorderRadius.circular(10.0),
        //       ),
        //       contentPadding: const EdgeInsets.symmetric(vertical: 15),
        //       prefixIcon: const Icon(
        //         Icons.search,
        //         size: 30.0,
        //       ),
        //       border: OutlineInputBorder(
        //         borderRadius: BorderRadius.circular(10.0),
        //       ),
        //       hintText: 'Buscar...',
        //     ),
        //   ),
        // ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
            child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 200, childAspectRatio: 3 / 4, crossAxisSpacing: 2, mainAxisSpacing: 5),
                itemCount: pokemonFavorites.getPokemonFavorites().length,
                itemBuilder: (BuildContext ctx, index) {
                  final Pokemon pokemon = pokemonListAll[index];

                  return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GestureDetector(
                        onLongPress: () {
                          showCupertinoModalPopup(
                              context: context,
                              builder: (BuildContext context) => CupertinoActionSheet(
                                    title: const Text("Opciones"),
                                    actions: [
                                      CupertinoActionSheetAction(
                                          onPressed: () {
                                            _removeFavorite(pokemon);
                                            Navigator.pop(context, 'Fav');
                                          },
                                          child: const Text("Quitar de Favoritos")),
                                      CupertinoActionSheetAction(
                                          onPressed: () {
                                            Navigator.pop(context, 'See');
                                          },
                                          child: const Text("Ver Pokemón 👁️")),
                                    ],
                                    cancelButton: CupertinoActionSheetAction(
                                        isDefaultAction: true,
                                        onPressed: () {
                                          Navigator.pop(context, 'Cancelar');
                                        },
                                        child: const Text('Cancelar')),
                                  ));
                        },
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PokemonView(pokemon: pokemon),
                            ),
                          );
                        },
                        child: Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            image: const DecorationImage(
                              image: AssetImage('Assets/bgPoke.png'),
                              fit: BoxFit.cover,
                              opacity: 0.9,
                            ),
                            borderRadius: BorderRadius.circular(15),
                            color: Colors.grey,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.2),
                                spreadRadius: 3,
                                blurRadius: 5,
                                offset: const Offset(0, 0),
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end, // Alinea los elementos a la derecha
                                children: [
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.only(right: 14.0, top: 10.0),
                                      child: Text(
                                        '#${pokemon.id}',
                                        textAlign: TextAlign.right,
                                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.white),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              CachedNetworkImage(
                                placeholder: (context, url) => const CircularProgressIndicator(),
                                imageUrl: pokemon.urlimage,
                                errorWidget: (context, url, error) => const Icon(Icons.error),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 10.0),
                                child: Text(
                                  pokemon.name,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 17,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ));
                }),
          ),
        ),
      ],
    );
  }

  void _getPokemonListAll() {
    try {
      pokemonListAll = pokemonFavorites.getPokemonFavorites();
      setState(() {
        // Actualiza el estado con la lista de Pokémon obtenida
        pokemonListAll = pokemonListAll;
        print("FAVS _getPokemonListAll: ${pokemonListAll}");
      });
    } catch (e) {
      print('Error al obtener la lista de Pokémon: $e');
    }
  }

  void _removeFavorite(Pokemon pokemon) async {
    try {
      pokemonFavorites.deletePokemon(pokemon);
      pokemonListAll = pokemonFavorites.getPokemonFavorites();
      setState(() {
        // Actualiza el estado con la lista de Pokémon obtenida
        pokemonListAll = pokemonListAll;
      });
    } catch (e) {
      print('Error al obtener la lista de Pokémon: $e');
    }
  }
}

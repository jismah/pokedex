import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pokedex/Models/pokemon.dart';
import 'package:pokedex/UI/pokemon_view.dart';
import 'package:pokedex/Utils/pokemon-favorites.dart';
import 'package:pokedex/Utils/pokemon-services.dart';
import 'package:flutter_debouncer/flutter_debouncer.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pokédex',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30)),
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
        elevation: 1,
        toolbarHeight: 70,
        actions: <Widget>[
          IconButton(
            icon: const Icon(
              Icons.favorite,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.pushNamed(context, 'favorites');
            },
          ),
        ],
      ),
      body: const HomePageContent(),
    );
  }
}

class HomePageContent extends StatefulWidget {
  const HomePageContent({super.key});

  @override
  State<HomePageContent> createState() => _HomePageContentState();
}

class _HomePageContentState extends State<HomePageContent> {
  TextEditingController searchController = TextEditingController();
  ListPokemonFavorites pokemonFavorites = ListPokemonFavorites();
  PokemonService pokemonService = PokemonService();
  List<Pokemon> pokemonListAll = [];
  List<Pokemon> pokemonListFiltered = [];

  @override
  void initState() {
/*     _fetchPokemons(); */
    // _getFavorites();
    super.initState();
  }

  Future<void> _fetchPokemons() async {
    try {
      pokemonListAll = await pokemonService.fetchPokemonList();
      setState(() {
        // Actualiza el estado con la lista de Pokémon obtenida
        pokemonListAll = pokemonListAll;
        pokemonListFiltered = pokemonListAll;
      });
    } catch (e) {
      print('Error al obtener la lista de Pokémon: $e');
    }
  }

  void filterSearchResults(String query) {
    if (query.isEmpty) {
      setState(() {
        pokemonListFiltered = pokemonListAll;
      });
      return;
    }

    // Filtrar en segundo plano para evitar bloqueos
    Future(() {
      return pokemonListAll
          .where((pokemon) =>
              pokemon.name.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }).then((filteredPokemonList) {
      setState(() {
        pokemonListFiltered = filteredPokemonList;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
          child: TextField(
            onChanged: (value) {
              filterSearchResults(value);
            },
            controller: searchController,
            decoration: InputDecoration(
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.red.shade600, width: 2.5),
                borderRadius: BorderRadius.circular(10.0),
              ),
              contentPadding: const EdgeInsets.symmetric(vertical: 15),
              prefixIcon: const Icon(
                Icons.search,
                size: 30.0,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              hintText: 'Buscar...',
            ),
          ),
        ),
        Expanded(
          child: FutureBuilder(
              future: _fetchPokemons(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  // Muestra un indicador de carga mientras se espera la carga de datos
                  return const Center(
                    child: CircularProgressIndicator(
                      color: Colors.red,
                    ),
                  );
                } else {
                  return Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                    child: GridView.builder(
                        gridDelegate:
                            const SliverGridDelegateWithMaxCrossAxisExtent(
                                maxCrossAxisExtent: 200,
                                childAspectRatio: 3 / 4,
                                crossAxisSpacing: 2,
                                mainAxisSpacing: 5),
                        itemCount: pokemonListFiltered.length,
                        itemBuilder: (BuildContext ctx, index) {
                          final Pokemon pokemon = pokemonListFiltered[index];

                          return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: GestureDetector(
                                onLongPress: () {
                                  showCupertinoModalPopup(
                                      context: context,
                                      builder: (BuildContext context) =>
                                          CupertinoActionSheet(
                                            title: const Text("Opciones"),
                                            actions: [
                                              CupertinoActionSheetAction(
                                                  onPressed: () {
                                                    pokemonFavorites
                                                        .addFavorite(pokemon);
                                                    Navigator.pop(
                                                        context, 'Fav');
                                                  },
                                                  child: const Text(
                                                      "Agregar a Favoritos ❤️")),
                                              CupertinoActionSheetAction(
                                                  onPressed: () {
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) =>
                                                            PokemonView(
                                                                pokemon:
                                                                    pokemon),
                                                      ),
                                                    );
                                                  },
                                                  child: const Text(
                                                      "Ver Pokemón 👁️")),
                                            ],
                                            cancelButton:
                                                CupertinoActionSheetAction(
                                                    isDefaultAction: true,
                                                    onPressed: () {
                                                      Navigator.pop(
                                                          context, 'Cancelar');
                                                    },
                                                    child:
                                                        const Text('Cancelar')),
                                          ));
                                },
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          PokemonView(pokemon: pokemon),
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
                                        mainAxisAlignment: MainAxisAlignment
                                            .end, // Alinea los elementos a la derecha
                                        children: [
                                          Expanded(
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  right: 14.0, top: 10.0),
                                              child: Text(
                                                '#${pokemon.id}',
                                                textAlign: TextAlign.right,
                                                style: const TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 14,
                                                    color: Colors.white),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Hero(
                                        tag: 'pokemon_image_${pokemon.id}',
                                        child: CachedNetworkImage(
                                          placeholder: (context, url) =>
                                              const CircularProgressIndicator(),
                                          imageUrl: pokemon.urlimage,
                                          errorWidget: (context, url, error) =>
                                              const Icon(Icons.error),
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(top: 10.0),
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
                  );
                }
              }),
        ),
      ],
    );
  }
}

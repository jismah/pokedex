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
        title: const Text('Favoritos',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25)),
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
  List<String> allTypes = [
    "All",
    "Normal",
    "Fighting",
    "Flying",
    "Poison",
    "Ground",
    "Rock",
    "Bug",
    "Ghost",
    "Steel",
    "Fire",
    "Water",
    "Grass",
    "Electric",
    "Psychic",
    "Ice",
    "Dragon",
    "Dark",
    "Fairy",
    "Unknown",
    "Shadow"
  ];
  String selectedType = 'All'; // Tipo por defecto

  @override
  void initState() {
    _getPokemonListAll();
    // _getFavorites();
    super.initState();
  }

  // COLORES DEPENDIENDO DEL TIPO DEL POKEMON
  Color obtenerColorPorTipo(String tipoEnIngles) {
    switch (tipoEnIngles) {
      case 'Fire':
        return Colors.red;
      case 'Water':
        return Colors.blue;
      case 'Grass':
        return Colors.green;
      case 'Poison':
        return Colors.lightGreen;
      case 'Normal':
        return Colors.blueAccent;
      case 'Electric':
        return Colors.yellow;
      case 'Ice':
        return Colors.lightBlue;
      case 'Fighting':
        return Colors.orange;
      case 'Ground':
        return Colors.brown;
      case 'Flying':
        return Colors.lightBlueAccent;
      case 'Psychic':
        return Colors.pink;
      case 'Bug':
        return Colors.green.shade800;
      case 'Rock':
        return Colors.grey;
      case 'Ghost':
        return Colors.lightBlueAccent;
      case 'Dragon':
        return Colors.pink;
      case 'Dark':
        return Colors.green.shade800;
      case 'Steel':
        return Colors.pink;
      case 'Fairy':
        return Colors.green.shade800;

      default:
        return Colors.grey;
    }
  }

  Icon determinarIconoTipo(String tipoEnIngles) {
    Map<String, IconData> iconosPorTipo = {
      'Fire': Icons.whatshot,
      'Water': Icons.water_drop,
      'Grass': Icons.grass,
      'Normal': Icons.arrow_drop_down,
      'Electric': Icons.electric_bolt,
      'Ice': Icons.ac_unit,
      'Fighting': Icons.dry,
      'Poison': Icons.coronavirus,
      'Bug': Icons.emoji_nature,
      'Ground': Icons.volcano,
      'Flying': Icons.air,
      'Psychic': Icons.psychology,
      'Rock': Icons.public,
      'Ghost': Icons.help_center,
      'Dragon': Icons.local_fire_department,
      'Dark': Icons.nights_stay,
      'Steel': Icons.smart_toy,
      'Fairy': Icons.auto_fix_normal,
    };

    if (iconosPorTipo.containsKey(tipoEnIngles)) {
      return Icon(iconosPorTipo[tipoEnIngles],
          color: obtenerColorPorTipo(tipoEnIngles));
    }

    return const Icon(Icons.arrow_drop_down);
  }

  @override
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          child: Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: DropdownButtonFormField<String>(
                    value: selectedType,
                    icon: determinarIconoTipo(selectedType),
                    dropdownColor: Colors.white,
                    iconSize: 30,
                    elevation: 16,
                    style: TextStyle(color: Colors.black),
                    items: allTypes.map((String type) {
                      return DropdownMenuItem<String>(
                        value: type,
                        child: Text(type),
                      );
                    }).toList(),
                    onChanged: (newType) {
                      setState(() {
                        selectedType = newType!;
                        _filterPokemonsByType(newType);
                      });
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
            child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 200,
                    childAspectRatio: 3 / 4,
                    crossAxisSpacing: 2,
                    mainAxisSpacing: 5),
                itemCount: pokemonListAll.length,
                itemBuilder: (BuildContext ctx, index) {
                  final Pokemon pokemon = pokemonListAll[index];

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
                                            _removeFavorite(pokemon);
                                            Navigator.pop(context, 'Fav');
                                          },
                                          child: const Text(
                                              "Quitar de Favoritos")),
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
                              CachedNetworkImage(
                                placeholder: (context, url) =>
                                    const CircularProgressIndicator(),
                                imageUrl: pokemon.urlimage,
                                errorWidget: (context, url, error) =>
                                    const Icon(Icons.error),
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
      // pokemonListAll = pokemonFavorites.getPokemonFavorites();
      // setState(() {
      //   // Actualiza el estado con la lista de Pokémon obtenida
      //   pokemonListAll = pokemonListAll;
      // });
      _filterPokemonsByType(selectedType);
    } catch (e) {
      print('Error al obtener la lista de Pokémon: $e');
    }
  }

  void _filterPokemonsByType(String newType) {
    List<Pokemon> filteredPokemons = [];

    if (newType == 'All') {
      filteredPokemons = pokemonFavorites.getPokemonFavorites();
    } else {
      pokemonListAll = pokemonFavorites.getPokemonFavorites();
      filteredPokemons = pokemonListAll
          .where(
              (pokemon) => pokemon.types.containsValue(newType.toLowerCase()))
          .toList();
      print("filteredPokemons: $filteredPokemons");
    }

    setState(() {
      pokemonListAll = filteredPokemons;
    });
  }
}

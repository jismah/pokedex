import 'package:flutter/material.dart';

import 'package:pokedex/Models/pokemon.dart';
import 'package:pokedex/Utils/pokemon-services.dart';

class PokemonView extends StatefulWidget {
  final Pokemon pokemon;

  const PokemonView({super.key, required this.pokemon});

  @override
  State<PokemonView> createState() => _PokemonViewState();
}

class _PokemonViewState extends State<PokemonView> {
  final PokemonService pokemonService = PokemonService();
  List<String> tipos = [];
  Map<String, int> estadisticas = {};

  @override
  void initState() {
    super.initState();
    loadPokemon();
  }

  Future<void> loadPokemon() async {
    try {
      await pokemonService.fetchPokemon(widget.pokemon);
      setState(() {
        tipos = widget.pokemon.types.values.toList();
        estadisticas = widget.pokemon.stats;
      });
    } catch (e) {
      // ignore: avoid_print
      print(e);
    }
  }

  // DICCIONARIO DE TRADUCCIONES DE LOS TIPOS
  String traducirTipo(String tipoEnIngles) {
    Map<String, String> traducciones = {
      'normal': 'Normal',
      'fire': 'Fuego',
      'water': 'Agua',
      'electric': 'Eléctrico',
      'grass': 'Planta',
      'ice': 'Hielo',
      'fighting': 'Lucha',
      'poison': 'Veneno',
      'ground': 'Tierra',
      'flying': 'Volador',
      'psychic': 'Psíquico',
      'bug': 'Bicho',
      'rock': 'Roca',
      'ghost': 'Fantasma',
      'dragon': 'Dragón',
      'dark': 'Siniestro',
      'steel': 'Acero',
      'fairy': 'Hada',
    };

    // Verifica si existe una traducción para el tipo en inglés
    if (traducciones.containsKey(tipoEnIngles)) {
      return traducciones[tipoEnIngles]!;
    }

    // Si no hay traducción, se devuelve el mismo tipo
    return tipoEnIngles;
  }

  // DICCIONARIO DE TRADUCCIONES DE LAS ESTADISTICAS
  String traducirEstadistica(String stat) {
    Map<String, String> traduccionEstadistica = {
      'hp': 'Vida',
      'attack': 'Ataque',
      'defense': 'Defensa',
      'special-attack': 'Atq Especial',
      'special-defense': 'Df Especial',
      'speed': 'Velocidad',
    };

    // Verifica si existe una traducción para el tipo en inglés
    if (traduccionEstadistica.containsKey(stat)) {
      return traduccionEstadistica[stat]!;
    }

    // Si no hay traducción, se devuelve el mismo tipo
    return stat;
  }

  // COLORES DEPENDIENDO DEL TIPO DEL POKEMON
  Color obtenerColorPorTipo(String tipoEnIngles) {
    switch (tipoEnIngles) {
      case 'fire':
        return Colors.red;
      case 'water':
        return Colors.blue;
      case 'grass':
        return Colors.green;
      case 'poison':
        return Colors.lightGreen;
      case 'normal':
        return Colors.blueAccent;
      case 'electric':
        return Colors.yellow;
      case 'ice':
        return Colors.lightBlue;
      case 'fighting':
        return Colors.orange;
      case 'ground':
        return Colors.brown;
      case 'flying':
        return Colors.lightBlueAccent;
      case 'psychic':
        return Colors.pink;
      case 'bug':
        return Colors.green.shade800;
      case 'rock':
        return Colors.grey;
      case 'ghost':
        return Colors.lightBlueAccent;
      case 'dragon':
        return Colors.pink;
      case 'dark':
        return Colors.green.shade800;
      case 'steel':
        return Colors.pink;
      case 'fairy':
        return Colors.green.shade800;

      default:
        return Colors.grey;
    }
  }

  // DETERMINAR EL COLOR DEPENDIENDO EL FONDO DEL CONTAINER
  Color determineColorBasedOnBackground(Color backgroundColor) {
    // Obtener el brillo o luminosidad del color de fondo
    final luminance = backgroundColor.computeLuminance();

    // Si el color de fondo es claro, devuelve el color del texto negro; de lo contrario, blanco
    return luminance > 0.5 ? Colors.black : Colors.white;
  }

  // DETERMINAR EL COLOR DEPENDIENDO EL VALOR DE LA ESTADISTICA
  Color determineColorBasedOnValue(int value) {
    if (value <= 30) {
      return Colors.lightBlue;
    } else if (value <= 60) {
      return Colors.blue;
    } else if (value <= 100) {
      return Colors.indigo;
    } else if (value <= 120) {
      return Colors.amber;
    } else if (value <= 160) {
      return Colors.orange;
    } else if (value <= 180) {
      return Colors.deepOrange;
    } else if (value <= 200) {
      return Colors.red;
    } else {
      return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('Assets/bgPoke.png'),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
          appBar: AppBar(
            title: Text(
              widget.pokemon.name,
              style:
                  const TextStyle(fontWeight: FontWeight.bold, fontSize: 23.0),
            ),
            bottom: PreferredSize(
                preferredSize: Size.zero,
                child: Text(
                  "#${widget.pokemon.id}",
                  style: const TextStyle(fontWeight: FontWeight.bold),
                )),
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
            elevation: 0,
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 0, left: 50, right: 50),
                  child: Image.network(
                    widget.pokemon.urlimage,
                    width: 200,
                    height: 200,
                    loadingBuilder: (BuildContext context, Widget child,
                        ImageChunkEvent? loadingProgress) {
                      if (loadingProgress == null) {
                        return child;
                      } else {
                        return const CircularProgressIndicator();
                      }
                    },
                  ),
                ),
                const SizedBox(
                  height: 20, // Altura del espacio entre los widgets
                ),
                SizedBox(
                  height: 40,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: tipos.length,
                    itemBuilder: (BuildContext context, int index) {
                      String tipoEnIngles = tipos[index];
                      String tipoTraducido = traducirTipo(tipos[index]);
                      Color colorTipo = obtenerColorPorTipo(tipoEnIngles);

                      return Container(
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: colorTipo,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          tipoTraducido,
                          style: TextStyle(
                              color: determineColorBasedOnBackground(colorTipo),
                              fontWeight: FontWeight.bold),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(
                  height: 40, // Altura del espacio entre los widgets
                ),
                Column(
                  children: estadisticas.entries.map((entry) {
                    String stat = entry.key;
                    int value = entry.value;
                    String estadisticaTipo = traducirEstadistica(stat);

                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 8.0, horizontal: 10.0),
                      child: Row(
                        children: [
                          Text(
                            estadisticaTipo,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            child: LinearProgressIndicator(
                              value: value / 200,
                              backgroundColor: Colors.grey,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                determineColorBasedOnValue(value),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Text(
                            '$value',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(
                  height: 15,
                ),
                const SizedBox(
                  height: 10,
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Placeholder(
                    fallbackHeight: 400.0,
                    fallbackWidth: 200.0,
                  ),
                ),
              ],
            ),
          )),
    );
  }
}

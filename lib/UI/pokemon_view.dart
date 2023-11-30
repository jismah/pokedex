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
  Color colorBase = Colors.red;

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

  Icon determinarIconoTipo(String tipoEnIngles) {
    Map<String, IconData> iconosPorTipo = {
      'fire': Icons.whatshot,
      'water': Icons.water_drop,
      'grass': Icons.grass,
      'normal': Icons.pets,
      'electric': Icons.electric_bolt,
      'ice': Icons.ac_unit,
      'fighting': Icons.dry,
      'poison': Icons.coronavirus,
      'bug': Icons.emoji_nature,
      'ground': Icons.volcano,
      'flying': Icons.air,
      'psychic': Icons.psychology,
      'rock': Icons.public,
      'ghost': Icons.help_center,
      'dragon': Icons.local_fire_department,
      'dark': Icons.nights_stay,
      'steel': Icons.smart_toy,
      'fairy': Icons.auto_fix_normal,
    };

    if (iconosPorTipo.containsKey(tipoEnIngles)) {
      return Icon(iconosPorTipo[tipoEnIngles]);
    }

    return const Icon(Icons.pets);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
          backgroundColor: colorBase,
          appBar: AppBar(
            title: Text(
              widget.pokemon.name,
              style:
                  const TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
            ),
            bottom: PreferredSize(
                preferredSize: Size.zero,
                child: Text(
                  "#${widget.pokemon.id}",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: determineColorBasedOnBackground(colorBase)),
                )),
            backgroundColor: colorBase,
            foregroundColor: determineColorBasedOnBackground(colorBase),
            elevation: 0,
            actions: <Widget>[
              IconButton(
                icon: Icon(
                  Icons.favorite,
                  color: determineColorBasedOnBackground(colorBase),
                ),
                onPressed: () {},
              ),
            ],
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Container(
                        height: MediaQuery.of(context).size.height / 4,
                        width: double.infinity,
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage('Assets/pokeballIcon.png'),
                            fit: BoxFit.contain,
                            alignment: Alignment.centerRight,
                            opacity: 0.1,
                          ),
                        ),
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                  top: 0, left: 50, right: 50),
                              child: Image.network(
                                widget.pokemon.urlimage,
                                width: 200,
                                height: 200,
                                loadingBuilder: (BuildContext context,
                                    Widget child,
                                    ImageChunkEvent? loadingProgress) {
                                  if (loadingProgress == null) {
                                    return child;
                                  } else {
                                    return const CircularProgressIndicator();
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                Container(
                  height: MediaQuery.of(context).size.height / 1.5,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(50.0),
                      topRight: Radius.circular(50.0),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        spreadRadius: 2,
                        blurRadius: 3,
                        offset: const Offset(0, 0),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 20, // Altura del espacio entre los widgets
                      ),
                      SizedBox(
                        height: 40,
                        child: Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: tipos.map((tipoEnIngles) {
                              String tipoTraducido = traducirTipo(tipoEnIngles);
                              Color colorTipo =
                                  obtenerColorPorTipo(tipoEnIngles);
                              Icon tipoIcon = determinarIconoTipo(tipoEnIngles);
                              colorBase = colorTipo;

                              return Container(
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 4),
                                padding: const EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                  color: colorTipo,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      tipoIcon.icon,
                                      color: determineColorBasedOnBackground(
                                          colorTipo),
                                    ),
                                    const SizedBox(
                                        width:
                                            5), // Espacio entre el icono y el texto
                                    Text(
                                      tipoTraducido,
                                      style: TextStyle(
                                        color: determineColorBasedOnBackground(
                                            colorTipo),
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20, // Altura del espacio entre los widgets
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
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
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
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                    ],
                  ),
                )
              ],
            ),
          )),
    );
  }
}

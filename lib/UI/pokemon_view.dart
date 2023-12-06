import 'package:flutter/material.dart';
import 'package:pokedex/UI/home.dart';
import 'package:share_plus/share_plus.dart';
import 'package:pokedex/Models/pokemon.dart';
import 'package:pokedex/UI/evoluciones.dart';
import 'package:pokedex/Utils/pokemon-favorites.dart';
import 'package:pokedex/Utils/pokemon-services.dart';
import 'package:screenshot/screenshot.dart';

class PokemonView extends StatefulWidget {
  final Pokemon pokemon;

  const PokemonView({super.key, required this.pokemon});

  @override
  State<PokemonView> createState() => _PokemonViewState();
}

class _PokemonViewState extends State<PokemonView> {
  final PokemonService pokemonService = PokemonService();
  ListPokemonFavorites pokemonFavorites = ListPokemonFavorites();
  final ScreenshotController screenshotController = ScreenshotController();

  int baseExp = 0;
  int height = 0;
  int weight = 0;
  List<String> tipos = [];
  List<String> habilidades = [];
  List<String> movimientos = [];
  Map<String, int> estadisticas = {};

  bool isIconChanged = false;
  Color colorBase = Colors.red;
  Color colorAux = Colors.grey;

  @override
  void initState() {
    super.initState();
    loadPokemon();
    isIconChanged = widget.pokemon.isFavorit;
  }

  // CARGA TODOS LOS DATOS DEL POKEMON
  Future<void> loadPokemon() async {
    try {
      await pokemonService.fetchPokemon(widget.pokemon);
      setState(() {
        tipos = widget.pokemon.types.values.toList();
        habilidades = widget.pokemon.abilities.keys.toList();
        estadisticas = widget.pokemon.stats;
        movimientos = widget.pokemon.moves.values.toList();
        baseExp = widget.pokemon.baseExperience;
        weight = widget.pokemon.weight;
        height = widget.pokemon.height;
      });
    } catch (e) {
      // ignore: avoid_print
      print(e);
    } finally {
/*       print(tipos);
      print(habilidades);
      print(estadisticas);
      print(baseExp);
      print(movimientos); */
      await Future.delayed(const Duration(milliseconds: 150));
      refreshBg();
    }
  }

  // CAMBIA DE COLOR EL BG DEPENDIENDO DEL POKEMON
  void refreshBg() {
    setState(() {
      colorBase = colorAux; // Cambiar a otro color
    });
  }

  // TIRA UN SCREENSHOT DEL POKEMON Y LO COMPARTE
  Future<void> captureAndShare() async {
    // Capturar la imagen y guardarla como archivo temporal
    Share.share(
        '¡Hola, te comparto mi pokemon ${widget.pokemon.name}, su id es ${widget.pokemon.id} y su imagen es ${widget.pokemon.urlimage}');
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

  // DICCIONARIO DE TRADUCCIONES DE LAS HABILIDADES
  String traducirHabilidad(String habilidadEnIngles) {
    Map<String, String> traducciones = {
      'overgrow': 'Espesura',
      'chlorophyll': 'Clorofila',
      'blaze': 'Mar Llamas',
      'torrent': 'Torrente',
      'swarm': 'Enjambre',
      'static': 'Estática',
      'keen eye': 'Vista Lince',
      'levitate': 'Levitación',
      'intimidate': 'Intimidación',
      'sand veil': 'Velo Arena',
      'swift swim': 'Nado Rápido',
      'run Away': 'Fuga',
      'insomnia': 'Insomnio',
      'immunity': 'Inmunidad',
      'magnet pull': 'Imán',
      'trace': 'Rastro',
      'huge power': 'Potencia',
      'synchronize': 'Sincronía',
    };

    // Verifica si existe una traducción para el tipo en inglés
    if (traducciones.containsKey(habilidadEnIngles)) {
      return traducciones[habilidadEnIngles]!;
    }

    // Si no hay traducción, se devuelve el mismo tipo
    return habilidadEnIngles;
  }

  // DICCIONARIO DE TRADUCCIONES DE LAS ESTADISTICAS
  String traducirEstadistica(String stat) {
    Map<String, String> traduccionEstadistica = {
      'hp': 'Vida',
      'attack': 'Ataque',
      'defense': 'Defensa',
      'special-attack': 'Atq Esp',
      'special-defense': 'Df Esp',
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
    return Scaffold(
        backgroundColor: colorBase,
        appBar: AppBar(
          title: Text(
            widget.pokemon.name,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
          ),
          backgroundColor: colorBase,
          foregroundColor: determineColorBasedOnBackground(colorBase),
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.of(context).pop(false);
            },
          ),
          actions: <Widget>[
            IconButton(
              icon: Icon(
                widget.pokemon.isFavorit
                    ? Icons.favorite
                    : Icons.favorite_border,
                color: determineColorBasedOnBackground(colorBase),
              ),
              onPressed: () {
                if (widget.pokemon.isFavorit) {
                  pokemonFavorites.deletePokemon(widget.pokemon);
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text('Pokemon Removido de Favoritos!')));
                } else {
                  pokemonFavorites.addFavorite(widget.pokemon);
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text('Pokemon Agregado a Favoritos!')));
                }
                setState(() {
                  // isIconChanged = !isIconChanged;
                  widget.pokemon.isFavorit = !widget.pokemon.isFavorit;
                });
              },
            ),
            IconButton(
              icon: Icon(
                Icons.account_tree_rounded,
                color: determineColorBasedOnBackground(colorBase),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        EvolucionesUI(pokemon: widget.pokemon),
                  ),
                );
              },
            ),
            IconButton(
              icon: Icon(
                Icons.share,
                color: determineColorBasedOnBackground(colorBase),
              ),
              onPressed: () {
                captureAndShare();
              },
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
                            child: Hero(
                              tag: 'pokemon_image_${widget.pokemon.id}',
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
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(100.0),
                    topRight: Radius.circular(0.0),
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
                      height: 20,
                    ),

                    // CONTAINER DE TIPOS DEL POKEMON
                    SizedBox(
                      height: 40,
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: tipos.map((tipoEnIngles) {
                            String tipoTraducido = traducirTipo(tipoEnIngles);
                            Color colorTipo = obtenerColorPorTipo(tipoEnIngles);
                            Icon tipoIcon = determinarIconoTipo(tipoEnIngles);
                            colorAux = colorTipo;

                            return Container(
                              margin: const EdgeInsets.symmetric(horizontal: 4),
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: colorTipo,
                                borderRadius: BorderRadius.circular(8),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.3),
                                    spreadRadius: 2,
                                    blurRadius: 5,
                                    offset: const Offset(
                                        0, 1), // changes position of shadow
                                  ),
                                ],
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
                      height: 20,
                    ),

                    // DATOS GENERALES DEL POKEMON
                    Column(
                      children: [
                        const Row(
                          mainAxisAlignment: MainAxisAlignment
                              .center, // Alineación horizontal al centro
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.only(bottom: 20.0),
                              child: Text(
                                'Datos Generales',
                                style: TextStyle(
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),

                        // PRIMER CONJUNTO DE DATOS
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                child: Row(
                                  children: <Widget>[
                                    const Text(
                                      'Altura:',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.blueGrey),
                                    ),
                                    const SizedBox(width: 5.0),
                                    Text(
                                      "$height",
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ),
                              // Cuarto conjunto de información
                              Expanded(
                                child: Row(
                                  children: <Widget>[
                                    const Text(
                                      'Peso:',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.blueGrey),
                                    ),
                                    const SizedBox(width: 5.0),
                                    Text(
                                      "$weight",
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),

                        // SEGUNDO CONJUNTO DE DATOS
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10.0, vertical: 15.0),
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                child: Row(
                                  children: <Widget>[
                                    const Text(
                                      'Exp Base:',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.blueGrey),
                                    ),
                                    const SizedBox(width: 5.0),
                                    Text(
                                      "$baseExp",
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ),
                              // Cuarto conjunto de información
                              Expanded(
                                child: Row(
                                  children: <Widget>[
                                    const Text(
                                      'ID Pokemon:',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.blueGrey),
                                    ),
                                    const SizedBox(width: 5.0),
                                    Text(
                                      "#${widget.pokemon.id}",
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),

                        // HABILIDADES
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          child: Row(
                            children: [
                              const Text(
                                'Habilidades:',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blueGrey),
                              ),
                              const SizedBox(width: 5.0),
                              // Iterar y mostrar habilidades
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: habilidades.map((habilidad) {
                                  String habilidadTraducida =
                                      traducirHabilidad(habilidad);
                                  return Text("$habilidadTraducida ",
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold));
                                }).toList(),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(
                      height: 30,
                    ),

                    // ESTADISTICAS
                    const Row(
                      mainAxisAlignment: MainAxisAlignment
                          .center, // Alineación horizontal al centro
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(bottom: 20.0),
                          child: Text(
                            'Estadisticas',
                            style: TextStyle(
                                fontSize: 20.0, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
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
                              Container(
                                width: 70.0,
                                child: Text(
                                  estadisticaTipo,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Text(
                                '$value',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: determineColorBasedOnValue(value)),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: LinearProgressIndicator(
                                  value: value / 250,
                                  backgroundColor: Colors.grey,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    determineColorBasedOnValue(value),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),

                    const SizedBox(
                      height: 30,
                    ),

                    const Row(
                      mainAxisAlignment: MainAxisAlignment
                          .center, // Alineación horizontal al centro
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(bottom: 20.0),
                          child: Text(
                            'Movimientos',
                            style: TextStyle(
                                fontSize: 20.0, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                    ListView.builder(
                      shrinkWrap: true,
                      itemCount: movimientos.length,
                      itemBuilder: (context, index) {
                        return Column(
                          children: [
                            ListTile(
                              title: Text(
                                movimientos[index],
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                              trailing: Text('#${index + 1}'),
                            ),
                            const Divider(height: 1, color: Colors.grey),
                          ],
                        );
                      },
                    ),
                  ],
                ),
              )
            ],
          ),
        ));
  }
}

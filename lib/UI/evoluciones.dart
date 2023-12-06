import 'package:flutter/material.dart';
import 'package:pokedex/Models/pokemon.dart';
import 'package:pokedex/UI/pokemon_view.dart';

class EvolucionesUI extends StatefulWidget {
  final Pokemon pokemon;

  const EvolucionesUI({super.key, required this.pokemon});

  @override
  State<EvolucionesUI> createState() => _EvolucionesUIState();
}

class _EvolucionesUIState extends State<EvolucionesUI> {
  List<Pokemon> listPokemon = [];
  Color colorBase = Colors.red;
  Color colorAux = Colors.grey;

  @override
  void initState() {
    listPokemon = widget.pokemon.nextGeneration;
    listPokemon.remove(widget.pokemon);
    super.initState();
  }

  void cambiarBg(Color nuevoColor) {
    setState(() {
      colorBase = nuevoColor; // Cambiar a otro color
    });
  }

  // DETERMINAR EL COLOR DEPENDIENDO EL FONDO DEL CONTAINER
  Color determineColorBasedOnBackground(Color backgroundColor) {
    // Obtener el brillo o luminosidad del color de fondo
    final luminance = backgroundColor.computeLuminance();

    // Si el color de fondo es claro, devuelve el color del texto negro; de lo contrario, blanco
    return luminance > 0.5 ? Colors.black : Colors.white;
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

  @override
Widget build(BuildContext context) {
  return Scaffold(
    backgroundColor: colorBase,
    appBar: AppBar(
      title: const Text(
        "Evoluciones",
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
      ),
      backgroundColor: colorBase,
      foregroundColor: determineColorBasedOnBackground(colorBase),
      elevation: 0,
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
           SizedBox(
            height: 500,
            child: ListView.builder(
              scrollDirection: Axis.vertical,
              itemCount: listPokemon.length,
              itemBuilder: (BuildContext context, int index) {
                Pokemon pokemon = listPokemon[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PokemonView(pokemon: pokemon),
                      ),
                    );
                  },
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: Card(
                      color: Colors.white12,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Expanded(
                            flex: 2,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Image.network(
                                pokemon.urlimage,
                                width: 125,
                                height: 125,
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
                          ),
                          Expanded(
                            flex: 3,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  pokemon.name,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 36,
                                    color: determineColorBasedOnBackground(colorAux),
                                  ),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  'ID: #${pokemon.id}',
                                  style: TextStyle(
                                    fontSize: 24,
                                    color: determineColorBasedOnBackground(colorAux),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    ),
  );
}

}

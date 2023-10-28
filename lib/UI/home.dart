import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pokedex/Models/pokemon_simple.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

// FUNCION PARA HACER EL FETCH AL ENDPOINT DE LOS POSTS
Future<List<PokemonSimple>> getPokemons() async {
  final response =
      await http.get(Uri.parse('https://pokeapi.co/api/v2/pokemon/'));

  if (response.statusCode == 200) {
    final List body = json.decode(response.body);
    return body.map((e) => PokemonSimple.fromJson(e)).toList();
  } else {
    throw Exception('Failed to load Pokemons');
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pokédex',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25)),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        toolbarHeight: 70,
      ),
      body: const HomePageContent(),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.red,
        onPressed: () {
          Navigator.pushNamed(context, 'favorites');
        },
        child: const Icon(Icons.favorite),
      ),
    );
  }
}

class HomePageContent extends StatefulWidget {
  const HomePageContent({super.key});

  @override
  State<HomePageContent> createState() => _HomePageContentState();
}

class _HomePageContentState extends State<HomePageContent> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: TextField(
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.search, size: 30.0),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30.0),
              ),
              hintText: 'Buscar...',
            ),
          ),
        ),
        Expanded(
            child: GridView.count(
                crossAxisCount: 2,
                children: List.generate(
                  10,
                  (index) {
                    return GestureDetector(
                      onLongPress: () {
                        showCupertinoModalPopup(
                            context: context,
                            builder: (BuildContext context) =>
                                CupertinoActionSheet(
                                  title: const Text("Opciones"),
                                  actions: [
                                    CupertinoActionSheetAction(
                                        onPressed: () {
                                          Navigator.pop(context, 'Fav');
                                        },
                                        child: const Text(
                                            "Agregar a Favoritos ❤️")),
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
                        Navigator.pushNamed(context, 'pokemonView');
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 12, horizontal: 24),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.grey.withOpacity(0.2),
                                spreadRadius: 2,
                                blurRadius: 2,
                                offset: const Offset(0, 1)),
                          ],
                        ),
                        margin: const EdgeInsets.all(8),
                        child: Center(
                          child: Text(
                            'Item $index',
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                )))
      ],
    );
  }
}

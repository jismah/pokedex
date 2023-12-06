import 'dart:collection';
import 'dart:math';

import 'package:pokedex/Utils/pokemon-services.dart';

const String baseurl = 'https://pokeapi.co/api/v2/';
const int limit = 20;
String? nextUrl = 'pokemon?limit=$limit&offset=0';

class Pokemon extends PokemonService {
  late int id;
  String name;
  String url;
  late bool isFavorit;
  late int baseExperience;
  late int height;
  late int weight;
  late String urlimage;
  late Map<String, int> stats;
  late Map<int, String> types;
  late Map<String, bool> abilities;
  late Map<int, String> moves;
  late List<Pokemon> nextGeneration;

  Pokemon({required this.name, required this.url});

  factory Pokemon.fromJson(Map<String, dynamic> json) {
    Pokemon pokemon = Pokemon(name: json['name'] as String, url: json['url'] as String);
    // pokemon.name = pokemon.name[0].toUpperCase() + pokemon.name.substring(1); No se puede hacer esto porque al buscarlo tira un not found ya que el nombre esta en mayuscula
    if (json['urlimage'] != null) {
      pokemon.urlimage = json['urlimage'];
    }

    if (json['id'] != null) {
      pokemon.id = json['id'];
    }

    if (json['height'] != null) {
      pokemon.height = json['height'];
    }

    if (json['weight'] != null) {
      pokemon.weight = json['weight'];
    }

    if (json['base_experience'] != null) {
      pokemon.baseExperience = json['base_experience'];
    }

    if (json['favorite'] != null) {
      pokemon.isFavorit = json['favorite'];
    }

    if (json['types'] != null) {
      Map<int, String> hash = new HashMap<int, String>();
      for (String element in json['types']) {
        int rand = Random().nextInt(1000);
        hash[rand] = element;
      }
      pokemon.types = hash;
    }
    return pokemon;
  }
}

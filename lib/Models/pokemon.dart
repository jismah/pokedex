import 'package:pokedex/Utils/pokemon-services.dart';

const String baseurl = 'https://pokeapi.co/api/v2/';
const int limit = 20;
String? nextUrl = 'pokemon?limit=$limit&offset=0';

class Pokemon extends PokemonService {
  late int id;
  String name;
  String url;
  late String urlimage;
  late Map<String, int> stats;
  late Map<int, String> types;
  late Map<String, bool> abilities;
  late Map<int, String> moves;

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

    return pokemon;
  }
}

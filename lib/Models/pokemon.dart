import 'package:pokedex/Utils/pokemon-services.dart';

const String baseurl = 'https://pokeapi.co/api/v2/';
const int limit = 20;
String? nextUrl = 'pokemon?limit=$limit&offset=0';

class Pokemon extends PokemonService {
  late int id;
  final String name;
  final String url;
  late String urlimage;
  late Map<String, int> stats;
  late Map<int, String> types;

  Pokemon({required this.name, required this.url});

  factory Pokemon.fromJson(Map<String, dynamic> json) {
    Pokemon pokemon = Pokemon(name: json['name'] as String, url: json['url'] as String);
    if (json['urlimage'] != null) {
      pokemon.urlimage = json['urlimage'];
    }
    if (json['id'] != null) {
      pokemon.id = json['id'];
    }

    return pokemon;
  }
}

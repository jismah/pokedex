import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:pokedex/Models/pokemon.dart';

int limit = 1300;

class PokemonService {
  String baseurl = 'https://pokeapi.co/api/v2/';
  String? nextUrl = 'pokemon?limit=$limit&offset=0';

  Future<List<Pokemon>> fetchPokemonList() async {
    final response = await http.get(Uri.parse('$baseurl$nextUrl'));

    if (response.statusCode == 200) {
      Map<String, dynamic> body =
          jsonDecode(response.body) as Map<String, dynamic>;
      final List<Pokemon> lista = (body['results'] as List<dynamic>)
          .map<Pokemon>((item) => Pokemon.fromJson(item))
          .toList();

      for (var pokemon in lista) {
        pokemon.id = findId(pokemon.url);
        pokemon.urlimage =
            'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/home/${pokemon.id}.png';
      }
      nextUrl = body['nextUrl'];
      return lista;
    } else {
      throw Exception('Failed to load the Pokemons list');
    }
  }

  Future<void> fetchPokemon(Pokemon pokemon) async {
    final response =
        await http.get(Uri.parse('$baseurl/pokemon/${pokemon.name}'));

    if (response.statusCode == 200) {
      Map<String, dynamic> body =
          jsonDecode(response.body) as Map<String, dynamic>;
      final statsjson = body['stats'] as List<dynamic>;

      pokemon.id = body['id'] as int;

      pokemon.urlimage =
          body['sprites']['other']['home']['front_default'] as String;

      pokemon.stats = getstatsfromjson(statsjson);

      pokemon.types = gettypesfronjson(body['types'] as List<dynamic>);

      print("Datos del Pokemon Cargados!");
      print(pokemon.stats);
      print(pokemon.types);
    } else {
      throw Exception('Failed to load the Pokemon: ${pokemon.name}');
    }
  }

  Map<String, int> getstatsfromjson(List statsjson) {
    Map<String, int> hash = <String, int>{};

    for (var stat in statsjson) {
      String name = stat['stat']['name'];
      hash[name] = stat['base_stat'];
    }
    return hash;
  }

  Map<int, String> gettypesfronjson(List json) {
    Map<int, String> hash = <int, String>{};

    for (var type in json) {
      int slot = type['slot'];
      hash[slot] = type['type']['name'];
    }
    return hash;
  }

  int findId(String url) {
    List<String> parts = url.split('/');
    int id = int.parse(parts[parts.length - 2]);
    return id;
  }
}

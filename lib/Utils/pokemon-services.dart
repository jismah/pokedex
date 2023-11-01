import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:pokedex/Models/pokemon.dart';

int limit = 20;

class PokemonService {
  String baseurl = 'https://pokeapi.co/api/v2/';
  String? nextUrl = 'pokemon?limit=$limit&offset=0';

  Future<List<Pokemon>> fetchPokemonList() async {
    final response = await http.get(Uri.parse('$baseurl$nextUrl'));

    if (response.statusCode == 200) {
      Map<String, dynamic> body = jsonDecode(response.body) as Map<String, dynamic>;
      final List<Pokemon> lista = (body['results'] as List<dynamic>).map<Pokemon>((item) => Pokemon.fromJson(item)).toList();

      for (var pokemon in lista) {
        await fetchPokemon(pokemon);
      }
      nextUrl = body['nextUrl'];
      return lista;
    } else {
      throw Exception('Failed to load the Pokemons list');
    }
  }

  Future<void> fetchPokemon(Pokemon pokemon) async {
    final response = await http.get(Uri.parse('$baseurl/pokemon/${pokemon.name}'));
    if (response.statusCode == 200) {
      Map<String, dynamic> body = jsonDecode(response.body) as Map<String, dynamic>;
      pokemon.id = body['id'] as int;
      pokemon.urlimage = body['sprites']['other']['home']['front_default'] as String;
    } else {
      throw Exception('Failed to load the Pokemon: ${pokemon.name}');
    }
  }
}

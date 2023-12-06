import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:pokedex/Models/pokemon.dart';

int limit = 1300;

class PokemonService {
  String baseurl = 'https://pokeapi.co/api/v2/';
  String? nextUrl = 'pokemon?limit=$limit&offset=0';
  static List<Pokemon> misPokemons = [];

  /// La funcion busca en el API el json de los Pokemon, lo convierte a un objeto.
  /// y retorna la lista de los Pokemones.
  Future<List<Pokemon>> fetchPokemonList() async {
    final response = await http.get(Uri.parse('$baseurl$nextUrl'));

    if (response.statusCode == 200) {
      Map<String, dynamic> body = jsonDecode(response.body) as Map<String, dynamic>;
      final List<Pokemon> lista = (body['results'] as List<dynamic>).map<Pokemon>((item) => Pokemon.fromJson(item)).toList();

      ///Para todos los pokemones extraemos el ID de la url y creamos la url de la imagen
      ///para no tener que hacer otra petición para extraer el ID y la imagen.

      for (var pokemon in lista) {
        pokemon.id = findId(pokemon.url);
        pokemon.isFavorit = false;
        try {
          final imageUrl = 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/home/${pokemon.id}.png';

          if (pokemon.id > 900) {
            pokemon.urlimage = 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/${pokemon.id}.png';
            /*  pokemon.urlimage =
                'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/shiny/${pokemon.id}.png'; */
          } else {
            pokemon.urlimage = imageUrl;
          }
        } catch (e) {
          print(e);
        }
      }

      nextUrl = body['nextUrl'];
      PokemonService.misPokemons.addAll(lista);
      return lista;
    } else {
      throw Exception('Failed to load the Pokemons list');
    }
  }

  // Función para verificar la validez de la URL de la imagen
  Future<bool> checkImageUrl(String imageUrl) async {
    final urlResponse = await http.head(Uri.parse(imageUrl));
    return urlResponse.statusCode == 200;
  }

  ///Funcion que busca los detalles de un pokemon dado
  Future<void> fetchPokemon(Pokemon pokemon) async {
    final response = await http.get(Uri.parse('$baseurl/pokemon/${pokemon.name}'));

    if (response.statusCode == 200) {
      Map<String, dynamic> body = jsonDecode(response.body) as Map<String, dynamic>;

      final statsjson = body['stats'] as List<dynamic>;
      final typesjson = body['types'] as List<dynamic>;
      final abilitiesjson = body['abilities'] as List<dynamic>;
      final movesjson = body['moves'] as List<dynamic>;

      pokemon.id = body['id'] as int;
      pokemon.urlimage = body['sprites']['other']['home']['front_default'] as String;

      pokemon.height = body['height'] as int;
      pokemon.weight = body['weight'] as int;
      pokemon.baseExperience = body['base_experience'] as int;

      pokemon.stats = getstatsfromjson(statsjson);
      pokemon.types = gettypesfromjson(typesjson);
      pokemon.abilities = getabilitiesfromjson(abilitiesjson);
      pokemon.moves = getmovesfromjson(movesjson);

      if (body['species']['url'] != null) {
        pokemon.nextGeneration = await getnextgenerations(body['species']['url']);
      }

      for (Pokemon element in pokemon.nextGeneration) {
        print("NAME: ${element.name}");
      }

      print("Datos del Pokemon Cargados!");
      print("Hay un total de: ${pokemon.nextGeneration.length} evoluciones para: ${pokemon.name}");
      //print(pokemon.types);
      //print(pokemon.abilities);
      //print(pokemon.moves);
      //print(pokemon.height);
      //print(pokemon.weight);
    } else {
      throw Exception('Failed to load the Pokemon: ${pokemon.name}');
    }
  }

  //Funcion que retorna las estadisticas de un pokemon dado el json
  Map<String, int> getstatsfromjson(List statsjson) {
    Map<String, int> hash = <String, int>{};

    for (var stat in statsjson) {
      String name = stat['stat']['name'];
      hash[name] = stat['base_stat'];
    }
    return hash;
  }

//Funcion que retorna los tipos de un pokemon dado el json
  Map<int, String> gettypesfromjson(List json) {
    Map<int, String> hash = <int, String>{};

    for (var type in json) {
      int slot = type['slot'];
      hash[slot] = type['type']['name'];
    }
    return hash;
  }

  Map<String, bool> getabilitiesfromjson(List abilitiesjson) {
    Map<String, bool> hash = <String, bool>{};

    for (var ability in abilitiesjson) {
      bool hidden = ability['is_hidden'];
      hash[ability['ability']['name']] = hidden;
    }
    return hash;
  }

  Map<int, String> getmovesfromjson(List movesjson) {
    Map<int, String> hash = <int, String>{};
    int count = 0;

    for (var move in movesjson) {
      hash[count] = move['move']['name'];
      count++;
    }
    return hash;
  }

  //Funcion que busca el ID dada la url que llega en el json principal
  int findId(String url) {
    List<String> parts = url.split('/');
    int id = int.parse(parts[parts.length - 2]);
    return id;
  }

  Future<List<Pokemon>> getnextgenerations(String urlEspecie) async {
    List<Pokemon> next = [];

    try {
      final especie = await http.get(Uri.parse(urlEspecie));
      var body = json.decode(especie.body);

      if (especie.statusCode == 200 && body['evolution_chain']['url'] != null) {
        final chain = await http.get(Uri.parse(body['evolution_chain']['url']));
        body = json.decode(chain.body);

        for (var evolve in body['chain']['evolves_to']) {
          String name = evolve['species']['name'];
          Pokemon? poke = findPokemonByName(name);

          if (poke != null) {
            next.add(poke);
          }
        }
      }
    } catch (e) {
      print("Huubo un error en la funcion: getnextgenerations: $e");
    }

    return next;
  }

  Pokemon? findPokemonByName(String name) {
    Pokemon? pokemon = PokemonService.misPokemons.where((poke) => poke.name.toLowerCase() == name.toLowerCase()).firstOrNull;
    return pokemon;
  }
}

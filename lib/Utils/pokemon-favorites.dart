import 'dart:convert';

import 'package:pokedex/Models/pokemon.dart';
import 'package:pokedex/Utils/pokemon-services.dart';
import 'package:shared_preferences/shared_preferences.dart';

//Clase Singleton que manejará los favoritos con SharedPreference
class ListPokemonFavorites {
  static final ListPokemonFavorites _instance = ListPokemonFavorites._internal();
  PokemonService pokemonService = PokemonService();
  List<String>? jsonFavorites;

  ListPokemonFavorites._();

  factory ListPokemonFavorites() {
    return _instance;
  }

  static ListPokemonFavorites getInstance() {
    return _instance;
  }

  ListPokemonFavorites._internal() {
    _getFavoritesFromSP();
  }

  //Funcion que busca en el shared preference los pokemones almacenados como favoritos
  Future<void> _getFavoritesFromSP() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      // print("SHARED PREFRENCE: ${prefs.getStringList("favorites")}");
      _instance.jsonFavorites = prefs.getStringList("favorites");
    } catch (e) {
      print('Error al obtener la lista de Favoritos: $e');
    }
  }

  //Funcion que convierte un pokemon en un json para almacenarlo en string en el SharedPreference
  void addFavorite(Pokemon pokemon) async {
    try {
      await pokemonService.fetchPokemon(pokemon);
      pokemon.isFavorit = true;
      List<String> types = pokemon.types.values.toList();
      // print(types);

      Map<String, dynamic> jsonbase = {'id': pokemon.id, 'name': pokemon.name, 'url': pokemon.url, 'urlimage': pokemon.urlimage, 'types': types, 'favorite' : pokemon.isFavorit};
      final String jsonString = jsonEncode(jsonbase);
      // print(jsonString);
      final SharedPreferences prefs = await SharedPreferences.getInstance();

      jsonFavorites ??= [];

      _instance.jsonFavorites?.add(jsonString);
      prefs.setStringList("favorites", jsonFavorites ?? []);
      print("FAVS addFavorite: $jsonFavorites");
    } catch (e) {
      // ignore: avoid_print
      print(e);
    }
  }

  //Funcion que retorna una lista del objeto de Pokemon dado el json almacenado en SharedPreference
  List<Pokemon> getPokemonFavorites() {
    List<Pokemon> favoritePokemonList = [];

    if (jsonFavorites == null) {
      return favoritePokemonList;
    }

    jsonFavorites?.forEach((jsonString) {
      Map<String, dynamic> parsedJson = jsonDecode(jsonString);
      Pokemon pokemon = Pokemon.fromJson(parsedJson);
      favoritePokemonList.add(pokemon);
    });

    return favoritePokemonList;
  }

  String jsonEncode(Object? object, {Object? Function(Object? nonEncodable)? toEncodable}) => json.encode(object, toEncodable: toEncodable);

  void deletePokemon(Pokemon pokemon) async {
    try {
      List<String>? favorites = ListPokemonFavorites.getInstance().jsonFavorites;

      if (favorites != null) {
        for (String element in favorites) {
          Map<String, dynamic> dato = json.decode(element);
          if (dato['id'] == pokemon.id) {
            favorites.remove(element);
          }
        }
      }

      pokemon.isFavorit = true;
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('favorites', json.encode(favorites));

      jsonFavorites = favorites;
      print("FAVS REMOVE: $jsonFavorites");
    } catch (e) {
      // ignore: avoid_print
      print(e);
    }
  }
}

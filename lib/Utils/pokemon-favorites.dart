import 'dart:convert';

import 'package:pokedex/Models/pokemon.dart';
import 'package:shared_preferences/shared_preferences.dart';

//Clase Singleton que manejará los favoritos con SharedPreference
class ListPokemonFavorites {
  static final ListPokemonFavorites _instance = ListPokemonFavorites._internal();
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
    Map<String, dynamic> jsonbase = {'id': pokemon.id, 'name': pokemon.name, 'urlimage': pokemon.urlimage, 'url': pokemon.url};
    final String jsonString = jsonEncode(jsonbase);
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    jsonFavorites ??= [];

    _instance.jsonFavorites?.add(jsonString);
    prefs.setStringList("favorites", jsonFavorites ?? []);
    print("FAVS: $jsonFavorites");
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
}

class PokemonSimple {
  String? name;
  String? url;

  PokemonSimple({this.name, this.url});

  PokemonSimple.fromJson(Map<String, dynamic> json) {
    name = json['results.name'];
    url = json['results.url'];
  }
}
